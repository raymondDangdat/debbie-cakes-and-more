import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled/controllers/add_product_controller.dart';
import 'package:untitled/controllers/cart_controller.dart';
import 'package:untitled/controllers/payments_controller.dart';
import 'package:untitled/controllers/product_controller.dart';
import 'package:untitled/screens/splash/splash.dart';

import 'constants/firebase.dart';
import 'controllers/appController.dart';
import 'controllers/authController.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initialization.then((value){
    Get.put(AppController());
    Get.put(UserController());
    Get.put(ProductsController());
    Get.put(CartController());
    Get.put(PaymentsController());
    Get.put(AddProductController());
  });
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Debbi's Cakes",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),
    );
  }
}
