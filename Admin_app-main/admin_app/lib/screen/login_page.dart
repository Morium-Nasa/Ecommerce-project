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
        child: Container(
          padding: EdgeInsets.all(25),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  "Login",
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
                icon: Icons.password,
                hintText: "Enter Password",
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
                  color: Colors.teal,
                ),
              )
            ],
          ),
        ),
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
      showtoast("email or password not match");
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
