import 'package:tabe3/models/size.dart';

class Product{
  String? id;
  String? name;
  String? image;
  int? price;
  List<ProductSize> sizes = [];
  int noOfSales = 0;

  Product({this.name, this.image, this.price, this.noOfSales = 0});
  Product.fromJson(Map<String, dynamic> json){
    name = json["name"];
    image = json["image"];
    price = json["price"];
    sizes = [for(var x in json["sizes"]) ProductSize.fromJson(x)]; 
  }

  Map<String, dynamic> toJson(){
    return {
      "name": name,
      "image": image,
      "price": price,
      "sizes": [for(var size in sizes) size.toJson()],
    };
  }
}