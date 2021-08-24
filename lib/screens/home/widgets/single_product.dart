import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/constants/constant.dart';
import 'package:untitled/constants/controllers.dart';
import 'package:untitled/models/cake.dart';
import 'package:untitled/screens/products/cake_details.dart';
import 'package:untitled/screens/products/edit_product.dart';
import 'package:untitled/widgets/custom_text.dart';

class SingleProductWidget extends StatefulWidget {
  final ProductModel product;

  const SingleProductWidget({Key key, this.product}) : super(key: key);

  @override
  _SingleProductWidgetState createState() => _SingleProductWidgetState();
}

class _SingleProductWidgetState extends State<SingleProductWidget> {
  String userEmail = "";
  @override
  void initState() {
    // TODO: implement initState
    getUserDetail();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(.5),
                offset: Offset(3, 2),
                blurRadius: 7)
          ]),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 220,
              decoration: BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                )
              ),
              child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                  child: Image.network(
                    widget.product.image,
                    width: double.infinity,
                  fit: BoxFit.cover,)),
            ),
          ),
          CustomText(
            text: widget.product.name,
            color: Colors.black,
            weight: FontWeight.bold,
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: CustomText(
                  text: "₦${moneyFormat.format(widget.product.price)}",
                  size: 15,
                  weight: FontWeight.bold,
                ),
              ),
              SizedBox(
                width: 30,
              ),
              userEmail == "debbie@gmail.com" ? Row(
                children: [
                  IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => EditProductsScreen(product: widget.product,)));
                      },
                  color: Theme.of(context).primaryColor,),

                  IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        Get.dialog(
                          AlertDialog(
                            content: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                ElevatedButton(onPressed: (){
                                  Navigator.pop(context);
                                }, child: Text("No")),

                                ElevatedButton(onPressed: (){
                                  Navigator.pop(context);
                                  addProductController.deleteProduct(widget.product.id);
                                }, child: Text("Confirm")),
                              ],
                            ),
                          )
                        );
                      },
                      color: Colors.redAccent),
                ],
              ) : IconButton(
                  icon: Icon(Icons.add_shopping_cart),
                  onPressed: () {
                    cartController.addProductToCart(widget.product);
                  })
            ],
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: CustomText(
                  text: widget.product.category,
                  size: 10,
                  weight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: 10,),

          Center(child: ElevatedButton.icon(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => CakeDetails(product: widget.product,)));
          }, icon: Icon(Icons.more_vert_outlined), label: Text('More')),),
          SizedBox(height: 10,),
        ],
      ),
    );
  }

  void getUserDetail() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      userEmail = prefs.getString('email');
      cartController.cartItems.value = userController.userModel.value.cart.length;
    });
  }
}
