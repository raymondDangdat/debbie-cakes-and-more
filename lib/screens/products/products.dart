import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as img;
import 'package:untitled/constants/controllers.dart';
import 'package:untitled/constants/firebase.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

class ProductsScreen extends StatefulWidget {
  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final GlobalKey<FormState> formState = GlobalKey<FormState>();

  final TextEditingController categoryController = TextEditingController();

  final TextEditingController nameController = TextEditingController();

  final TextEditingController priceController = TextEditingController();


  FirebaseStorage storage = FirebaseStorage.instance;




  String id = Uuid().v4();

  bool isUploading = false;

  File file;
  UploadTask task;

  handleTakePhoto(BuildContext context) async {
    Navigator.pop(context);
    File file = await ImagePicker.pickImage(
        source: ImageSource.camera, maxHeight: 675, maxWidth: 960);

    setState(() {
      this.file = file;
    });
  }

  bool _isFormValidated() {
    final FormState form = formState.currentState;
    return form.validate();
  }

  handleChooseFromGallery(BuildContext context) async {
    Navigator.pop(context);
    File file = await ImagePicker.pickImage(
      source: ImageSource.gallery,
    );
    setState(() {
      this.file = file;
    });
  }

  selectImage(parentContext) {
    return showDialog(
        context: parentContext,
        builder: (context) {
          return SimpleDialog(
            title: Text("Upload Food from"),
            children: [
              SimpleDialogOption(
                child: Text("Camera"),
                onPressed:(){
                  handleTakePhoto(context);
                }
              ),
              SimpleDialogOption(
                child: Text("Gallery"),
                onPressed: (){
                  handleChooseFromGallery(context);
                }
              ),
              SimpleDialogOption(
                child: Text("Cancel"),
                onPressed: () => Navigator.pop(context),
              )
            ],
          );
        });
  }

  clearImage() {
    file = null;
  }

  Future uploadFile() async {
    if (file == null) return;

    final fileName = basename(file.path);
    final destination = 'products/$fileName';

    task = FirebaseApi.uploadFile(destination, file);
    setState(() {});

    if (task == null) return;

    final snapshot = await task.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();

    if(urlDownload != null){
      await addProductController.uploadFile(file, id);
    }else{
      Fluttertoast.showToast(msg: "Image could not be uploaded!");
    }

    print('Download-Link: $urlDownload');
  }

  compressImage() async {
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    img.Image imageFile = img.decodeImage(file.readAsBytesSync());
    final compressedImageFile = File('$path/img_$id.jpg')
      ..writeAsBytesSync(img.encodeJpg(imageFile, quality: 90));

    setState(() {
      file = compressedImageFile;
    });
  }


  // createPostInFirestore(
  //     {String description, String location, String mediaUrl}) {
  //   postsRef
  //       .document(widget.currentUser.id)
  //       .collection("userPosts")
  //       .document(id)
  //       .setData({
  //     "postId": id,
  //     "ownerId": widget.currentUser.id,
  //     "username": widget.currentUser.username,
  //     "mediaUrl": mediaUrl,
  //     "description": description,
  //     "location": location,
  //     "timeStamp": timestamp,
  //     "likes": {},
  //   });
  // }
  //
  // handleSubmit() async {
  //   setState(() {
  //     isUploading = true;
  //   });
  //   await compressImage();
  //   String mediaUrl = await uploadImage(file);
  //   createPostInFirestore(
  //       mediaUrl: mediaUrl,
  //   setState(() {
  //     file = null;
  //     isUploading = false;
  //     id = Uuid().v4();
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            }),
        backgroundColor: Colors.grey.withOpacity(.1),
        iconTheme: IconThemeData(color: Colors.black),
        centerTitle: true,
        elevation: 0,
        title: Text(
          "Foods",
          style: TextStyle(color: Colors.black),
        ),

      ),
      body: SafeArea(child:
      SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        physics: BouncingScrollPhysics(),
        child: Form(
          key: formState,
            child: Column(
          children: [
            SizedBox(height: 10,),
            InkWell(
              onTap: (){
                selectImage(context);
              },
              child: Container(height: 200, width: 200,
              decoration: BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.circular(100),
                image: DecorationImage(image: file == null ?  AssetImage('images/upload.png') : FileImage(file), fit: BoxFit.cover)
              ),),
            ),
            
            SizedBox(height: 10,),
            TextFormField(
              controller: addProductController.category,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(labelText: 'Category'),
              textInputAction: TextInputAction.next,
              onSaved: (value) {
                addProductController.category.text = value;
              },
              validator: (value) {
                if (value.length < 3) {
                  return 'Please enter a valid category name';
                } else
                  return null;
              },
            ),

            TextFormField(
              controller: addProductController.productName,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(labelText: 'Food Name'),
              textInputAction: TextInputAction.next,
              onSaved: (value) {

              },
              validator: (value) {
                if (value.length < 3) {
                  return 'Please enter a valid food name';
                } else
                  return null;
              },
            ),

            TextFormField(
              controller: addProductController.price,
              keyboardType: TextInputType.number,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(labelText: 'Food Price'),
              textInputAction: TextInputAction.next,
              onSaved: (value) {

              },
              validator: (value) {
                if (value.length < 3) {
                  return 'Please enter a valid food price';
                } else
                  return null;
              },
            ),

            SizedBox(height: 50,),

            ElevatedButton(onPressed: (){
              if(_isFormValidated()){
                uploadFile();
              }
            }, child: Text("Add Food"))
          ],
        )),
      ))
    );
  }
}
