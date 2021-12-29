import 'package:admin_app/screen/login_page.dart';
import 'package:admin_app/widget/brand_colors.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  SharedPreferences? sharedPreferences;

  logOut() async {
    sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences!.clear();
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        width: double.infinity,
        color: Colors.red,
        child: MaterialButton(
          onPressed: () {
            logOut();
          },
          child: Text(
            "Log out",
            style: myStyles14(),
          ),
        ),
      ),
    );
  }
}
