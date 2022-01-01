// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:admin_app/screen/home_page.dart';
import 'package:admin_app/widget/brand_colors.dart';
import 'package:admin_app/widget/custom_http_request.dart';
import 'package:admin_app/widget/text_field.dart';
import 'package:admin_app/widget/widgets.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: isLoading == true,
        progressIndicator: spinkit,
        opacity: 1,
        child: Container(
          decoration: BoxDecoration(
              color: const Color(0xffD7DBDD),
              image: DecorationImage(
                  image: AssetImage('assets/images/background.png'),
                  fit: BoxFit.fill)),
          padding: const EdgeInsets.all(25),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                height: 100,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    image: DecorationImage(
                      image: AssetImage("images/1.jpg"),
                    )),
              ),
              SizedBox(
                height: 20,
              ),
              Center(
                child: Text(
                  "Sign in using Email & Password",
                  style: myStyles20(),
                ),
              ),
              SizedBox(
                height: 80,
              ),
              Text(
                "Enter your Email",
                style: myStyles14(),
              ),
              CustomTextField(
                controller: emailController,
                icon: Icons.email,
                hintText: "Enter email",
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                "Enter your Password",
                style: myStyles14(),
              ),
              CustomTextField(
                controller: passwordController,
                icon: Icons.lock_outlined,
                hintText: "Enter Password",
              ),
              SizedBox(
                height: 20,
              ),
              Center(
                child: MaterialButton(
                    onPressed: () {
                      getLogin();
                    },
                    height: 50,
                    minWidth: 120,
                    child: Text(
                      "Login",
                      style: myStyle(18, Colors.white, FontWeight.w800),
                    ),
                    color: Colors.lightBlue[700]),
              )
            ],
          ),
        ),
        color: Colors.amber,
      ),
    );
  }

  SharedPreferences? sharedPreferences;
  getLogin() async {
    try {
      setState(() {
        isLoading = true;
      });
      final result = await CustomHttpRequest()
          .login(emailController.text, passwordController.text);
      print("result is $result");
      var data = jsonDecode(result);
      sharedPreferences = await SharedPreferences.getInstance();
      if (data["access_token"] != null) {
        showtoast("Login Successful");
        setState(() {
          sharedPreferences!.setString("token", data["access_token"]);
          isLoading = false;
          print("save token ${sharedPreferences!.getString("token")}");
        });
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomePage()));
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      showtoast("Email or Password Doesn't Match");
    }
  }

  isLogin() async {
    sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences!.getString("token");
    if (token != null) {
      showtoast("Already Login user");
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => HomePage()));
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    isLogin();
    super.initState();
  }
}
