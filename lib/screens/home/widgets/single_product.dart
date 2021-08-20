import 'package:flutter/material.dart';
import 'package:untitled/constants/controllers.dart';
import 'package:untitled/models/cake.dart';
import 'package:untitled/screens/products/cake_details.dart';
import 'package:untitled/widgets/custom_text.dart';

class SingleProductWidget extends StatelessWidget {
  final ProductModel product;

  const SingleProductWidget({Key key, this.product}) : super(key: key);
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
                    product.image,
                    width: double.infinity,
                  fit: BoxFit.cover,)),
            ),
          ),
          CustomText(
            text: product.name,
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
                  text: "₦${product.price}",
                  size: 15,
                  weight: FontWeight.bold,
                ),
              ),
              SizedBox(
                width: 30,
              ),
              IconButton(
                  icon: Icon(Icons.add_shopping_cart),
                  onPressed: () {
                    cartController.addProductToCart(product);
                  })
            ],
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: CustomText(
                  text: product.category,
                  size: 10,
                  weight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: 10,),

          Center(child: ElevatedButton.icon(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => CakeDetails(product: product,)));
          }, icon: Icon(Icons.more_vert_outlined), label: Text('More')),),
          SizedBox(height: 10,),
        ],
      ),
    );
  }
}
