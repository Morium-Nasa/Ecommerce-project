import 'dart:convert';
import 'dart:io';
import 'package:admin_app/widget/text_field.dart';
import 'package:admin_app/widget/widget.dart';
import 'package:http/http.dart' as http;
import 'package:admin_app/http/custom_http_request.dart';
import 'package:admin_app/widget/brand_colors.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:http/http.dart' as http;

class AddCategory extends StatefulWidget {
  const AddCategory({Key? key}) : super(key: key);

  @override
  _AddCategoryState createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  TextEditingController titleController = TextEditingController();
  bool isLoading = false;
  uploadCategory() async {
    try {
      setState(() {
        isLoading = true;
      });
      final url = "https://apihomechef.antapp.space/api/admin/category/store";
      var request = http.MultipartRequest("POST", Uri.parse(url));
      request.headers.addAll(await CustomHttpRequest.getHeaderWithToken());
      request.fields["name"] = titleController.text;
      var iconn = await http.MultipartFile.fromPath("icon", _icon!.path);
      request.files.add(iconn);

      var imagee = await http.MultipartFile.fromPath("image", _image!.path);
      request.files.add(imagee);
      var responce = await request.send();
      var responceData = await responce.stream.toBytes();
      var responceString = String.fromCharCodes(responceData);
      var data = jsonDecode(responceString);
      print("aaaaaaaaaaaaaaaaaaaa $data");
      if (responce.statusCode == 201) {
        print("Successssssssssssssssssssss");
        showInToast("${data["message"]}");
        setState(() {
          isLoading = false;
        });
        Navigator.pop(context);
      } else {
        setState(() {
          isLoading = false;
        });
        showInToast("${data["message"]}");
        print("Something wronggggggggggg");
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      showInToast("Failed to upload");
      print("Something wronggggggggggg");
    }
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
                      : Icon(Icons.add_a_photo),
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
                      : Icon(Icons.add_a_photo),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              MaterialButton(
                onPressed: () {
                  uploadCategory();
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

  File? _image, _icon;

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
}
