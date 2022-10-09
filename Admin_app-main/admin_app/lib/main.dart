import 'package:admin_app/screen/home_page.dart';
import 'package:admin_app/screen/login_page.dart';
import 'package:admin_app/widget/widgets.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  SharedPreferences? sharedPreferences;
  isLogin() async {
    sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences!.getString("token");
    if (token != null) {
      showtoast("Already Login user");
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => HomePage()));
    }
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => LoginPage()));
  }

  @override
  void initState() {
    // TODO: implement initState
    isLogin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
    );
    // home: LoginPage());
  }
}
