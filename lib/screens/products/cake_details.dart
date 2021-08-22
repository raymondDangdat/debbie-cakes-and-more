import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:untitled/constants/controllers.dart';
import 'package:untitled/models/cake.dart';
import 'package:untitled/screens/home/widgets/shopping_cart.dart';
import 'package:untitled/widgets/custom_text.dart';

class CakeDetails extends StatefulWidget {
  final ProductModel product;
  const CakeDetails({Key key, this.product}) : super(key: key);
  @override
  _CakeDetailsState createState() => _CakeDetailsState();
}
class _CakeDetailsState extends State<CakeDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: CustomText(
          text: "Cake Details",
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
      body: SafeArea(child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10,),
            Container(
              decoration: BoxDecoration(
                // color: Colors.redAccent
              ),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    widget.product.image,
                    width: double.infinity,
                    fit: BoxFit.cover,)),
            ),
            SizedBox(height: 10),
            Text(widget.product.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),),
            SizedBox(height: 5),
            Row(
              children: [
                Text('Category: '),
                Text(widget.product.category, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              ],
            ),
            SizedBox(height: 5),
            Row(
              children: [
                Text('Price: '),
                Text('₦${widget.product.price.toString()}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              ],
            ),
            SizedBox(height: 5),
            Text("Description", style: TextStyle(fontWeight: FontWeight.bold),),
            Text(widget.product.description),
            SizedBox(height: 50,),
          ],
        ),
      )),
    );
  }
}
