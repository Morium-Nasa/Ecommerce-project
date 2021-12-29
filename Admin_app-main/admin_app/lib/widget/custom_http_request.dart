import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CustomHttpRequest {
  static const String uri = "https://apihomechef.antapp.space/api/";

  login(String email, password) async {
    try {
      var responce = await http.post(Uri.parse("${uri}admin/sign-in"),
          body: {"email": email, "password": password});
      print("status Code is ${responce.statusCode}");
      if (responce.statusCode == 200) {
        return responce.body;
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
