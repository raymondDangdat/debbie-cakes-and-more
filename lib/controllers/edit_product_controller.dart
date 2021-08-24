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

class EditProductController extends GetxController {
  static EditProductController instance = Get.find();
  UploadTask task;
  Rx<User> firebaseUser;
  RxString image = ''.obs;
  RxBool isLoggedIn = false.obs;
  TextEditingController cakeTitle = TextEditingController();
  TextEditingController cakeName = TextEditingController();
  TextEditingController cakeDescription = TextEditingController();
  TextEditingController cakeCategory = TextEditingController();
  TextEditingController cakePrice = TextEditingController();
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
    await firebaseFirestore.collection(cakes).doc(productId).update({
      "name": cakeName.text.trim(),
      "id": productId,
      "category": cakeCategory.text.trim(),
      "price": double.parse(cakePrice.text.trim()),
      "image" : image,
      "description": cakeDescription.text.trim(),
    });
    _clearControllers();
    Get.offAll(() => HomeScreen());
  }

  updateToFirestore(String productId) async{
    await firebaseFirestore.collection(cakes).doc(productId).update({
      "name": cakeName.text.trim(),
      "id": productId,
      "category": cakeCategory.text.trim(),
      "price": double.parse(cakePrice.text.trim()),
      "description": cakeDescription.text.trim(),
    });
    _clearControllers();
    Get.offAll(() => HomeScreen());
  }

  deleteProduct(String productId) async{
    await firebaseFirestore.collection(cakes).doc(productId).delete(
    );
    Get.offAll(() => HomeScreen());
  }

  _clearControllers() {
    cakeTitle.clear();
    cakeName.clear();
    cakeCategory.clear();
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
