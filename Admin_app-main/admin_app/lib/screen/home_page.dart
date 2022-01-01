// ignore_for_file: prefer_const_constructors

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
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          tooltip: "Cancel and Return to List",
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
        automaticallyImplyLeading: false,
        title: Text("home page"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            tooltip: "Save Tool & Log out to page",
            onPressed: () {
              logOut();
            },
          )
        ],
      ), //AppBar
      body: Container(
        width: double.infinity,
        // color: Colors.red[100],
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            image: DecorationImage(
                image: AssetImage("images/2.jpg"), fit: BoxFit.cover)),

        child: Column(
          children: [
            SizedBox(
              height: 80,
            ),
            Center(
              child: Text(
                "Welcome to Home_Page",
                style: myStyles20(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
