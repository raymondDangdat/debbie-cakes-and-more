import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:untitled/constants/firebase.dart';
import 'package:untitled/models/user.dart';
import 'package:path/path.dart';
import 'package:untitled/screens/home/home.dart';
import 'package:untitled/utils/helpers/showLoading.dart';

class AddProductController extends GetxController {
  static AddProductController instance = Get.find();
  UploadTask task;
  Rx<User> firebaseUser;
  RxBool isLoggedIn = false.obs;
  TextEditingController productTitle = TextEditingController();
  TextEditingController productName = TextEditingController();
  TextEditingController category = TextEditingController();
  TextEditingController price = TextEditingController();
  String cakes = "cakes";
  Rx<UserModel> userModel = UserModel().obs;
  String url;

  @override
  void onReady() {
    super.onReady();
    firebaseUser = Rx<User>(auth.currentUser);
    firebaseUser.bindStream(auth.userChanges());
  }

  _addFoodToFirestore(String productId, String image) async{
    await firebaseFirestore.collection(cakes).doc(productId).set({
      "name": productName.text.trim(),
      "id": productId,
      "category": category.text.trim(),
      "price": double.parse(price.text.trim()),
      "image" : image,
    });
      _clearControllers();
    Get.offAll(() => HomeScreen());
  }

  _clearControllers() {
    productTitle.clear();
    productName.clear();
    category.clear();
  }

  Future uploadFile(File file, String productId) async {
    if (file == null) return;
    showLoading();
    final fileName = basename(file.path);
    final destination = 'cakes/$fileName';
    task = FirebaseApi.uploadFile(destination, file);
    if (task == null) return;
    final snapshot = await task.whenComplete(() {});
    url = await snapshot.ref.getDownloadURL();
    if(url != null){
      await _addFoodToFirestore(productId, url);
    }else{
      Fluttertoast.showToast(msg: "Image could not be uploaded!");
    }
    print('Download-Link: $url');
  }
}
