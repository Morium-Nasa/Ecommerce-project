import 'dart:convert';

import 'package:admin_app/screen/main_page.dart';
import 'package:http/http.dart' as http;
import 'package:admin_app/http/custom_http_request.dart';
import 'package:admin_app/screen/home.dart';
import 'package:admin_app/widget/brand_colors.dart';
import 'package:admin_app/widget/text_field.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool onProgress = false;
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool obser = true;
  String? token;
  SharedPreferences? sharedPreferences;

  isLogin() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    token = sharedPreferences.getString("token");
    if (token != null) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return MainPage();
      }));
    }
  }

  _submit() async {
    if (mounted) {
      setState(() {
        //  onProgress = true;
      });
      final form = _formKey.currentState;
      if (form!.validate()) {
        form.save();
        print('|valeditor accessed asasa');
        if (await getLogin()) {
          print('|valeditor accessed |');
          emailController.clear();
          passwordController.clear();
          onProgress = false;
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) {
            return MainPage();
          }));
          print(":Succcccccccccccccccccccccc");
          return "Logged In";
        } else {
          setState(() {
            onProgress = false;
          });
          return "Incorrect Credentials";
        }
      } else {
        setState(() {
          onProgress = false;
        });
        return "Required email and password";
      }
    }
  }

  @override
  void initState() {
    isLogin();
    super.initState();
  }

  getLogin() async {
    setState(() {
      onProgress = true;
    });
    try {
      sharedPreferences = await SharedPreferences.getInstance();
      final result = await CustomHttpRequest()
          .login(emailController.text, passwordController.text);
      final data = jsonDecode(result);
      print('111111111111111111111');
      print(" the login data are : $data");
      if (data["access_token"] != null) {
        showInToast("Login successfully");
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return MainPage();
        }));
        setState(() {
          sharedPreferences!.setString("token", data['access_token']);
        });
        print("save token");
        token = sharedPreferences!.getString("token");
        print('token is $token');
        return true;
      } else {
        showInToast("Email & Password didn't match");
        return false;
      }
    } catch (e) {
      setState(() {
        onProgress = false;
      });

      print("something wrong  $e");
      showInToast("Email & Password didn't match");
    }
  }

  showInToast(String value) {
    Fluttertoast.showToast(
      msg: "$value",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.yellow,
      textColor: Colors.red,
      fontSize: 16.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.black,
      body: ModalProgressHUD(
        inAsyncCall: onProgress,
        opacity: 0.2,
        progressIndicator: CircularProgressIndicator(
          strokeWidth: 5,
        ),
        child: Container(
          child: Form(
            key: _formKey,
            child: Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(top: 260),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.only(top: 30, left: 12, right: 12),
                child: ListView(
                  //crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Hey!',
                      style: TextStyle(
                          fontSize: 22,
                          color: Colors.white,
                          fontWeight: FontWeight.w800),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Get Start with Homechef Admin',
                        style: TextStyle(
                            fontSize: 18,
                            color: BrandColors.colorPrimaryDark,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Email',
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                          fontWeight: FontWeight.normal),
                    ),
                    LoginTextEdit(
                      controller: emailController,
                      hintText: 'Enter your Email Address',
                      icon: Icons.email,
                      function: (value) {
                        if (value.isEmpty) {
                          return "*email addresBrandColors.colorPrimaryDark";
                        }
                        if (!value.contains('@')) {
                          return "*wrong email address";
                        }
                        if (!value.contains('.')) {
                          return "*wrong email address";
                        }
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Password',
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                          fontWeight: FontWeight.normal),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            gapPadding: 5.0,
                            borderSide:
                                BorderSide(color: Colors.white, width: 2.5)),
                        prefixIcon: Icon(
                          Icons.lock_sharp,
                          color: Colors.black54,
                          size: 18,
                        ),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              obser = !obser;
                            });
                          },
                          child: Icon(
                            obser ? Icons.visibility_off : Icons.visibility,
                            color: !obser ? Colors.white : Colors.grey,
                            size: 18,
                          ),
                        ),
                        hintText: 'password',
                      ),
                      obscureText: obser,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "*please enter password";
                        }
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: 50,
                      width: 200,
                      decoration: BoxDecoration(
                        color: BrandColors.colorPrimaryDark,
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      margin: EdgeInsets.only(top: 50),
                      child: TextButton(
                        onPressed: () {
                          getLogin();
                          // _submit();
                        },
                        child: Center(
                          child: Text(
                            'Log In',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    /*Center(
                      child: Text(
                        'Forgot your Password?',
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 14,
                          // decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    Divider(
                      color: Colors.black54,
                      endIndent: 98,
                      indent: 98,
                      height: 2,
                    ),
                    SizedBox(
                      height: 30,
                    ),*/
                    /*Row(
                      children: [
                        Text(
                          "Don't have an account?",
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                        Spacer(),
                        Container(
                          height: 35,
                          width: 100,
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: aPrimaryColor, width: 2.0),
                            borderRadius:
                            BorderRadius.all(Radius.circular(10)),
                          ),
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context){
                                return RegistrationPage();
                              }));
                            },
                            child: Center(
                                child: Text(
                                  'Sign Up',
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.black),
                                )),
                          ),
                        ),

                      ],
                    ),
                    SizedBox(height: 10,),*/
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
