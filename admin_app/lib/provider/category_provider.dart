import 'package:admin_app/http/custom_http_request.dart';
import 'package:admin_app/model/category_model.dart';
import 'package:admin_app/model/order_model.dart';
import 'package:flutter/cupertino.dart';

class CategoryProvider with ChangeNotifier {
  //Orders orders = Orders();
  List<CategoryModel> categoryList = [];

  getCategory(context) async {
    categoryList = await CustomHttpRequest.fetchCategory();
    notifyListeners();
  }
}
