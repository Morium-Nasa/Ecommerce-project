import 'dart:convert';
import 'package:admin_app/model/category_model.dart';
import 'package:admin_app/model/order_model.dart';
import 'package:admin_app/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CustomHttpRequest {
  static const String uri = "https://apihomechef.antapp.space";

  static SharedPreferences? sharedPreferences;

  static Future<Map<String, String>> getHeaderWithToken() async {
    sharedPreferences = await SharedPreferences.getInstance();
    var header = {
      "Accept": "application/json",
      "Authorization": "bearer ${sharedPreferences!.getString("token")}",
    };
    print("user token is :${sharedPreferences!.getString('token')}");
    return header;
  }

  login(String email, String password) async {
    try {
      print("asdasdasdas");
      var url = "https://apihomechef.antapp.space/api/admin/sign-in";
      var response = await http.post(
        Uri.parse(url),
        body: {'email': email, 'password': password},
      );
      print('Response status: ${response.statusCode}');
      //  var result=response.body;
      // print('Response body: ${result}');
      if (response.statusCode == 200) {
        return response.body;
      }
    } catch (e) {
      return e.toString();
    }
  }

  static Future<dynamic> getOrder(context) async {
    OrderModel orders;
    List<OrderModel> orderList = [];
    try {
      String url = "$uri/api/admin/all/orders";

      var response =
          await http.get(Uri.parse(url), headers: await getHeaderWithToken());
      print(response.statusCode);
      if (response.statusCode == 200) {
        final item = json.decode(response.body);
        print("All Orders are $item");
        for (var i in item) {
          orders = OrderModel.fromJson(i);
          orderList.add(orders);
        }
      } else {
        print('Data not found');
      }
    } catch (e) {
      print(e);
    }
    return orderList;
  }

  static Future<dynamic> fetchCategory() async {
    var ulr = "https://apihomechef.antapp.space/api/admin/category";
    List<CategoryModel> categoryList = [];
    CategoryModel categoryModel;
    http.Response response =
        await http.get(Uri.parse(ulr), headers: await getHeaderWithToken());

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print("All category are $data");
      for (var i in data) {
        categoryModel = CategoryModel.fromJson(i);
        categoryList.add(categoryModel);
      }
    } else {
      print("something wrong in category data");
    }
    return categoryList;
  }

  Future<bool> deleteCategory(int id) async {
    String link = "$uri/api/admi/category/$id/delete";
    var responce =
        await http.delete(Uri.parse(link), headers: await getHeaderWithToken());
    if (responce.statusCode == 200) {
      var data = jsonDecode(responce.body);
      print("Success");

      return true;
    } else {
      print("Something wrong");
      showInToast("Something wrong");
      return false;
    }
  }
}
