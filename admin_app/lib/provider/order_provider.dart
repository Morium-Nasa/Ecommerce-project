import 'package:admin_app/http/custom_http_request.dart';
import 'package:admin_app/model/order_model.dart';
import 'package:flutter/cupertino.dart';

class OrderProvider with ChangeNotifier {
  //Orders orders = Orders();
  List<OrderModel> orderList = [];
  String name = "pp";

  getRecentOrders(context) async {
    orderList = await CustomHttpRequest.getOrder(context);
    notifyListeners();
  }
}
