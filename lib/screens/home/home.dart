import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:untitled/constants/controllers.dart';
import 'package:untitled/screens/home/widgets/products.dart';
import 'package:untitled/screens/home/widgets/shopping_cart.dart';
import 'package:untitled/screens/products/products.dart';
import 'package:untitled/widgets/custom_text.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
          title: CustomText(
            text: "Debbie's Cakes and More",
            size: 24,
            weight: FontWeight.bold,
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10, top: 10),
              child: Container(
                width: 45,
                height: 40,
                child: Stack(
                  children: [
                    IconButton(
                        icon: Icon(Icons.shopping_cart),
                        onPressed: () {
                          showBarModalBottomSheet(
                            context: context,
                            builder: (context) => Container(
                              color: Colors.white,
                              child: ShoppingCartWidget(),
                            ),
                          );
                        }),
                    // Positioned(
                    //   right: 0,
                    //     top: 7,
                    //     child: Text('${cartController.cartItems.value}', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),))
                  ],
                ),
              ),
            )
          ],
          elevation: 0,
          centerTitle: true,
        ),
        backgroundColor: Colors.white,
        drawer: Drawer(
          child: ListView(
            children: [
              Obx(()=>UserAccountsDrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blueAccent
                ),
                  accountName: Text(userController.userModel.value.name ?? ""),
                  accountEmail: Text(userController.userModel.value.email ?? ""))),
              ListTile(
                leading: Icon(Icons.book),
                title: CustomText(
                  text: "Payments History",
                ),
                onTap: ()async {
                  Navigator.pop(context);
                 paymentsController.getPaymentHistory();
                },
              ),
              userController.userModel.value.name == "Admin" && userController.userModel.value.email == "dorcasadmin@gmail.com" ? Column(children: [
                ListTile(
                  leading: Icon(Icons.restaurant_rounded),
                  title: CustomText(
                    text: "Manage Foods",
                  ),
                  onTap: ()async {
                    Navigator.pop(context);
                    Get.to(() => ProductsScreen());
                  },
                ),

                ListTile(
                  leading: Icon(Icons.bookmark_border_rounded),
                  title: CustomText(
                    text: "Manage Orders",
                  ),
                  onTap: ()async {
                    Navigator.pop(context);
                    paymentsController.getOrders();
                  },
                ),
              ],) : Container(),
              ListTile(
                onTap: () {
                  userController.signOut();
                },
                leading: Icon(Icons.exit_to_app),
                title: Text("Log out"),
              )
            ],
          ),
        ),
        body: SingleChildScrollView(

          child: Container(
            color: Colors.white30,
            child: ProductsWidget(),
          ),
        ));
  }
}
