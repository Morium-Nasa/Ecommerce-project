import 'dart:io';

import 'package:admin_app/http/custom_http_request.dart';
import 'package:admin_app/model/category_model.dart';
import 'package:admin_app/provider/category_provider.dart';
import 'package:admin_app/widget/text_field.dart';
import 'package:admin_app/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class EditCategory extends StatefulWidget {
  EditCategory({Key? key, this.categoryModel}) : super(key: key);
  CategoryModel? categoryModel;

  @override
  _EditCategoryState createState() => _EditCategoryState();
}

class _EditCategoryState extends State<EditCategory> {
  bool isLoading = false;
  File? _image, _icon;
  TextEditingController? titleController;
  @override
  void initState() {
    // TODO: implement initState
    titleController = TextEditingController(text: widget.categoryModel!.name);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading == true,
      progressIndicator: CircularProgressIndicator(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(),
        body: Container(
          width: double.infinity,
          child: Column(
            children: [
              Text("Enter title"),
              LoginTextEdit(
                controller: titleController,
                hintText: 'Enter Product category title',
                icon: Icons.title,
              ),
              Text("Add Category icon"),
              InkWell(
                onTap: () {
                  selectImage(context, "icon");
                },
                child: Container(
                  height: 200,
                  width: 500,
                  child: _icon != null
                      ? Image.file(_icon!)
                      : Image.network(
                          "https://homechef.antapp.space/category/${widget.categoryModel!.icon}"),
                ),
              ),
              Text("Add Category Image"),
              InkWell(
                onTap: () {
                  selectImage(context, "image");
                },
                child: Container(
                  height: 200,
                  width: 500,
                  child: _image != null
                      ? Image.file(_image!)
                      : Image.network(
                          "https://homechef.antapp.space/category/${widget.categoryModel!.image}"),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              MaterialButton(
                onPressed: () {
                  //   uploadCategory();
                  uploadCategory(widget.categoryModel!.id);
                },
                child: Text("Submit"),
                height: 80,
                minWidth: 120,
                color: Colors.blue,
              )
            ],
          ),
        ),
      ),
    );
  }

  selectImage(ctx, String source) {
    return showDialog(
        context: ctx,
        builder: (context) {
          return SimpleDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            title: Text("Upload Image"),
            children: [
              SimpleDialogOption(
                onPressed: () {
                  source == "image"
                      ? getImageFromCamera()
                      : getIconFromCamera();
                },
                child: Text("Choose from camera"),
              ),
              SimpleDialogOption(
                onPressed: () {
                  source == "icon"
                      ? getIconFromGallery()
                      : getImageFromGallery();
                },
                child: Text("Choose from gallery"),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Cancel"),
              ),
            ],
          );
        });
  }

  final ImagePicker _picker = ImagePicker();

  Future getImageFromGallery() async {
    var pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = File(pickedFile!.path);
    });
    Navigator.of(context).pop();
  }

  Future getIconFromGallery() async {
    var pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _icon = File(pickedFile!.path);
    });
    Navigator.of(context).pop();
  }

  Future getImageFromCamera() async {
    var pickedFile = await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      _image = File(pickedFile!.path);
    });
    Navigator.of(context).pop();
  }

  Future getIconFromCamera() async {
    var pickedFile = await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      _icon = File(pickedFile!.path);
    });
    Navigator.of(context).pop();
  }

  Future uploadCategory(var id) async {
    setState(() {
      isLoading = true;
    });
    String link =
        "https://apihomechef.antapp.space/api/admin/category/$id/update";
    var request = http.MultipartRequest("POST", Uri.parse(link));
    request.headers.addAll(await CustomHttpRequest.getHeaderWithToken());

    request.fields["name"] = titleController!.text.toString();

    if (_image != null) {
      var image = await http.MultipartFile.fromPath("image", _image!.path);
      request.files.add(image);
    }

    if (_icon != null) {
      var icon = await http.MultipartFile.fromPath("icon", _icon!.path);
      request.files.add(icon);
    }

    var responce = await request.send();

    if (responce.statusCode == 200) {
      setState(() {
        isLoading = false;
      });
      print("aaaaaaaaaaaaaaaaaa");
      //  Provider.of<CategoryProvider>(context, listen: false) .categoryList .clear();
      print("bbbbbbbbbbbbb");
      // Provider.of<CategoryProvider>(context, listen: false) .getCategory(context);
      showInToast("Successfull");
      Navigator.of(context).pop();
      print("Successsssssssssssss");
    } else {
      setState(() {
        isLoading = false;
        showInToast("Failed to upload");
      });
      print("failed to upload");
    }
  }
}
