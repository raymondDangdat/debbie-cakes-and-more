import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled/constants/asset_paths.dart';
import 'package:untitled/controllers/appController.dart';
import 'package:untitled/screens/authentication/widgets/bottom_text.dart';
import 'package:untitled/screens/authentication/widgets/login.dart';
import 'package:untitled/screens/authentication/widgets/registration.dart';

class AuthenticationScreen extends StatelessWidget {

  final AppController _appController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() => SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: MediaQuery.of(context).size.width / 6),
            Container(
              height: 200,
                width: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: Colors.red,
                  image: DecorationImage(image: AssetImage(logo), fit: BoxFit.cover)
                ),),
            SizedBox(height: MediaQuery.of(context).size.width / 12),

            Visibility(
                visible: _appController.isLoginWidgetDisplayed.value,
                child: LoginWidget()),
            Visibility(
                visible: !_appController.isLoginWidgetDisplayed.value,
                child: RegistrationWidget()),
            SizedBox(
              height: 10,
            ),
            Visibility(
              visible: _appController.isLoginWidgetDisplayed.value,
              child: BottomTextWidget(
                onTap: () {
                  _appController.changeDIsplayedAuthWidget();
                },
                text1: "Don\'t have an account?",
                text2: "Create account!",
              ),
            ),
            Visibility(
              visible: !_appController.isLoginWidgetDisplayed.value,
              child: BottomTextWidget(
                onTap: () {
                  _appController.changeDIsplayedAuthWidget();
                },
                text1: "Already have an account?",
                text2: "Sign in!!",
              ),
            ),

            SizedBox(height: 20,)
          ],
        ),
      ),)
    );
  }
}
