import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:untitled/models/cart_item.dart';

class UserModel {
  static const ID = "id";
  static const NAME = "name";
  static const EMAIL = "email";
  static const CART = "cart";
  static const PHONE = "phone";
  static const ADDRESS = "address";

   String id;
   String name;
   String email;
   List<CartItemModel> cart;
   String phone;
   String address;

  UserModel({this.id, this.name, this.email, this.cart, this.phone, this.address});

  UserModel.fromSnapshot(DocumentSnapshot snapshot) {
    name = snapshot.data()[NAME];
    email = snapshot.data()[EMAIL];
    id = snapshot.data()[ID];
    cart = _convertCartItems(snapshot.data()[CART] ?? []);
    phone = snapshot.data()[PHONE];
    address = snapshot.data()[ADDRESS];

  }

  List<CartItemModel> _convertCartItems(List cartFomDb){
    List<CartItemModel> _result = [];
    if(cartFomDb.length > 0){
      cartFomDb.forEach((element) {
      _result.add(CartItemModel.fromMap(element));
    });
    }
    return _result;
  }

  List cartItemsToJson() => cart.map((item) => item.toJson()).toList();
}
