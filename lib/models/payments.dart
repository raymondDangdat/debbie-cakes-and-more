class PaymentsModel {
  static const ID = "id";
  static const PAYMENT_ID = "paymentId";
  static const CART = "cart";
  static const AMOUNT = "amount";
  static const STATUS = "status";
  static const CREATED_AT = "createdAt";
  static const USER_NAME = "name";
  static const USER_ADDRESS = "address";
  static const PHONE = "phone";

   String id;
   String paymentId;
   String amount;
   String status;
   DateTime createdAt;
   List cart;
   String username;
   String userAddress;
   String phone;

  PaymentsModel({this.id, this.paymentId, this.amount, this.status, this.createdAt, this.cart, this.username, this.userAddress, this.phone});

  PaymentsModel.fromMap(Map data){
    id = data[ID];
    createdAt = data[CREATED_AT].toDate();
    paymentId = data[PAYMENT_ID];
    amount = data[AMOUNT];
    status = data[STATUS];
    cart = data[CART];
    username = data[USER_NAME];
    userAddress = data[USER_ADDRESS];
    phone = data[PHONE];
  }
}