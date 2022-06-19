import 'package:admin_app/provider/category_provider.dart';
import 'package:admin_app/provider/order_provider.dart';
import 'package:admin_app/screen/home.dart';
import 'package:admin_app/screen/login_page.dart';
import 'package:admin_app/screen/main_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
    ChangeNotifierProvider<OrderProvider>(create: (_) => OrderProvider()),
    ChangeNotifierProvider<CategoryProvider>(create: (_) => CategoryProvider()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
    );
  }
}
