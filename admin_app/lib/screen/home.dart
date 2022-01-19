import 'package:admin_app/provider/order_provider.dart';
import 'package:admin_app/screen/add_category.dart';
import 'package:admin_app/screen/add_products.dart';
import 'package:admin_app/widget/brand_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ScrollController? _scrollController;
  bool showFav = true;
  @override
  void initState() {
    // TODO: implement initState
    Provider.of<OrderProvider>(context, listen: false)
        .getRecentOrders(context); //  recentOrders.getRecentOrders(context);
    _scrollController = ScrollController();

    super.initState();
  }

  @override
  void dispose() {
    _scrollController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final recentOrders = Provider.of<OrderProvider>(context);
    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: showFav
          ? FloatingActionButton(
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (BuildContext context) {
                      return bottomSheet(context);
                    });
              },
              backgroundColor: aBlackCardColor,
              child: Icon(
                Icons.add,
                size: 30,
                color: aPrimaryColor,
              ),
            )
          : null,
      body: NotificationListener<UserScrollNotification>(
        onNotification: (notification) {
          setState(() {
            if (notification.direction == ScrollDirection.forward) {
              showFav = true;
              print("uppppppppppppppp${recentOrders.name}");
            } else if (notification.direction == ScrollDirection.reverse) {
              showFav = false;
              print("downnnnnnn");
            }
          });
          return true;
        },
        child: Container(
          width: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              children: [
                recentOrders.orderList.isNotEmpty
                    ? ListView.builder(
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
                        itemCount: recentOrders.orderList.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 15),
                            child: Row(
                              children: [
                                Icon(
                                  recentOrders.orderList[index].payment!
                                              .paymentStatus
                                              .toString() ==
                                          '1'
                                      ? Icons.check_circle_outlined
                                      : Icons.access_time_rounded,
                                  color: recentOrders.orderList[index].payment!
                                              .paymentStatus
                                              .toString() ==
                                          '1'
                                      ? Colors.green
                                      : aPrimaryColor,
                                  size: 15,
                                ),
                                /* recentOrders.orderList[index].orderStatus
                                      .orderStatusCategory.name ==
                                      'Complete'
                                      ? Icons.check_circle_outlined
                                      : Icons.access_time_rounded,
                                  color: recentOrders.orderList[index].orderStatus
                                      .orderStatusCategory.name ==
                                      'Complete'
                                      ? Colors.green
                                      : aPrimaryColor,
                                ),*/
                                SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${recentOrders.orderList[index].orderStatus!.orderStatusCategory!.name ?? ""}',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      '#${recentOrders.orderList[index].id ?? ""}',
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                ),
                                Spacer(),
                                Text(
                                  '\৳ ${recentOrders.orderList[index].price ?? ""}',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: aPriceTextColor),
                                )
                              ],
                            ),
                          );
                        })
                    : Center(child: CircularProgressIndicator()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container bottomSheet(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      height: MediaQuery.of(context).size.height * 0.20,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            height: 2,
          ),
          SizedBox(
            height: 2,
            width: 30,
            child: Container(
              decoration: BoxDecoration(color: Colors.grey),
            ),
          ),
          SizedBox(height: 5),
          Container(
            //height: MediaQuery.of(context).size.height * 0.20,
            child: Row(
              children: [
                Expanded(
                    child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddCategory()),
                    ).then(
                      (value) => Navigator.pop(context),
                    );
                  },
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                            color: aPrimaryColor,
                          ),
                          child: Center(),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          'Add Category',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        )
                      ],
                    ),
                  ),
                )),
                Expanded(
                    child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddProducts()),
                    ).then(
                      (value) => Navigator.pop(context),
                    );
                  },
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                            color: aPrimaryColor,
                          ),
                          child: Center(
                            child: Container(
                              height: 20,
                              width: 20,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          'Add Products',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        )
                      ],
                    ),
                  ),
                )),
              ],
            ),
          )
        ],
      ),
    );
  }
}
