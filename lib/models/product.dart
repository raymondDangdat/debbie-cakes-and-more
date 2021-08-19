class ProductModel{
  static const ID = "id";
  static const IMAGE = "image";
  static const NAME = "name";
  static const CATEGORY = "category";
  static const PRICE = "price";

   String id;
   String image;
   String name;
   String category;
   double price;

  ProductModel({this.id, this.image, this.name, this.category, this.price});

  ProductModel.fromMap(Map<String, dynamic> data){
    id = data[ID];
    image = data[IMAGE];
    name = data[NAME];
    category = data[CATEGORY];
    price = data[PRICE].toDouble();
  }

}