import 'package:admin_app/http/custom_http_request.dart';
import 'package:admin_app/provider/category_provider.dart';
import 'package:admin_app/screen/edit_category.dart';
import 'package:admin_app/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

class Categories extends StatefulWidget {
  const Categories({Key? key}) : super(key: key);

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  @override
  void initState() {
    // TODO: implement initState
    Provider.of<CategoryProvider>(context, listen: false).getCategory(context);
    super.initState();
  }

  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    var categoryData = Provider.of<CategoryProvider>(context).categoryList;
    return Scaffold(
      body: Container(
        width: double.infinity,
        child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            itemCount: categoryData.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Card(
                child: Column(
                  children: [
                    Expanded(
                      flex: 8,
                      child: Stack(
                        children: [
                          Image.network(
                            "https://homechef.antapp.space/category/${categoryData[index].image}",
                            fit: BoxFit.cover,
                          ),
                          Positioned(
                            top: 5,
                            bottom: 5,
                            left: 5,
                            right: 5,
                            child: CircleAvatar(
                              radius: 20,
                              backgroundImage: NetworkImage(
                                  "https://homechef.antapp.space/category/${categoryData[index].icon}"),
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Row(
                        children: [
                          MaterialButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(
                                      builder: (context) => EditCategory(
                                            categoryModel: categoryData[index],
                                          )))
                                  .then((value) =>
                                      Provider.of<CategoryProvider>(context,
                                              listen: false)
                                          .getCategory(context));
                            },
                            child: Text("Edit"),
                          ),
                          MaterialButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return ModalProgressHUD(
                                      inAsyncCall: isLoading == true,
                                      progressIndicator: spinkit,
                                      child: AlertDialog(
                                        title: Text("Are you sure?"),
                                        content: Text(
                                            "You want to delete this item?"),
                                        actions: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              MaterialButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text("Cancle"),
                                                color: Colors.blue,
                                              ),
                                              MaterialButton(
                                                onPressed: () async {
                                                  setState(() {
                                                    isLoading = true;
                                                  });
                                                  bool data =
                                                      await CustomHttpRequest()
                                                          .deleteCategory(
                                                              categoryData[
                                                                      index]
                                                                  .id!
                                                                  .toInt());
                                                  print(
                                                      "cccccccccccccccccasdddddddcccc $data");
                                                  if (data == true) {
                                                    setState(() {
                                                      isLoading = false;
                                                      showInToast(
                                                          "Deleted Successfully");
                                                      categoryData
                                                          .removeAt(index);
                                                    });
                                                  } else {
                                                    setState(() {
                                                      isLoading = false;

                                                      showInToast(
                                                          "Something wrong");

                                                      print(
                                                          "ddddddddddddddddddddddd");
                                                    });
                                                  }
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text("Delete"),
                                                color: Colors.red,
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    );
                                  });
                            },
                            child: Text("Delete"),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              );
            }),
      ),
    );
  }
}
