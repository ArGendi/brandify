import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tabe3/models/product.dart';

class Sell{
  String? id;
  Product? product;
  DateTime? date;
  int? quantity;
  int profit = 0;
  int? priceOfSell;

  Sell({this.product, this.date, this.quantity, this.priceOfSell, this.profit = 0});
  Sell.fromJson(Map<String, dynamic> json){
    product = Product.fromJson(json["product"]);
    date = json["date"].toDate();
    quantity = json["quantity"];
    profit = json["profit"];
    priceOfSell = json["priceOfSell"];
  }

  Map<String, dynamic> toJson(){
    return {
      "product": product?.toJson(),
      "date": Timestamp.fromDate(date!),
      "quantity": quantity,
      "profit": profit,
      "priceOfSell": priceOfSell,
    };
  }
}