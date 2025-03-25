import 'package:tabe3/models/size.dart';

class Product{
  int? id;
  String? code;
  String? name;
  String? image;
  int? price;
  List<ProductSize> sizes = [];
  int noOfSells = 0;

  Product({this.name, this.image, this.price, this.noOfSells = 0, this.code});
  Product.fromJson(Map<dynamic, dynamic> json){
    id = json["id"];
    code = json["code"];
    name = json["name"];
    image = json["image"];
    price = json["price"];
    noOfSells = json["noOfSells"] ?? 0;
    sizes = [for(var x in json["sizes"]) ProductSize.fromJson(x)]; 
  }

  Map<String, dynamic> toJson(){
    return {
      "id": id,
      "code": code,
      "name": name,
      "image": image,
      "price": price,
      "noOfSells": noOfSells,
      "sizes": [for(var size in sizes) size.toJson()],
    };
  }

  int getNumberOfAllItems(){
    int total = 0;
    for(var item in sizes){
      total += item.quantity ?? 0;
    }
    return total;
  }
}