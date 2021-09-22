import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/constants/controllers.dart';
import 'package:untitled/screens/home/widgets/products.dart';
import 'package:untitled/screens/home/widgets/shopping_cart.dart';
import 'package:untitled/screens/products/products.dart';
import 'package:untitled/widgets/custom_text.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String userEmail = '';
  @override
  void initState() {
    getUserDetail();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
          title: CustomText(
            text: "Debbie's Cakes",
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
                    Positioned(
                      right: 0,
                        top: 7,
                        child: Obx(() => Text('${cartController.cartItems.value}', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),)))
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
                  color: Colors.blueAccent,
                  image: DecorationImage(image: AssetImage('images/logo.png'), fit: BoxFit.cover)
                ),
                  accountName: Container(
                    padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: Text(userController.userModel.value.name ?? "")),
                  accountEmail: Container(
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(10)
                    ),
                      padding: EdgeInsets.all(4),
                      child: Text(userController.userModel.value.email ?? "")))),
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
              userEmail == "debbie@gmail.com" ? Column(children: [
                ListTile(
                  leading: Icon(Icons.restaurant_rounded),
                  title: CustomText(
                    text: "Manage Cakes",
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
                    // Get.to(() => OrdersScreen());
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
        body: Container(
          color: Colors.white30,
          child: ProductsWidget(),
        ));
  }

  void getUserDetail() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      userEmail = prefs.getString('email');
      cartController.cartItems.value = userController.userModel.value.cart.length;
    });
  }
}
