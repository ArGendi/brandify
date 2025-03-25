import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tabe3/enum.dart';
import 'package:tabe3/models/product.dart';
import 'package:tabe3/models/sell_side.dart';
import 'package:tabe3/models/side.dart';
import 'package:tabe3/models/size.dart';

class Sell{
  int? id;
  Product? product;
  DateTime? date;
  int? quantity;
  int profit = 0;
  int? priceOfSell;
  int extraExpenses = 0;
  List<SellSide> sideExpenses = [];
  ProductSize? size;
  bool isRefunded = false;
  SellPlace? place;

  Sell({this.id, this.product, this.date, this.quantity, this.priceOfSell, 
    this.profit = 0, this.sideExpenses = const [], this.extraExpenses = 0, this.size,
    this.place});

  Sell.fromJson(Map<dynamic, dynamic> json){
    product = Product.fromJson(json["product"]);
    date = DateTime.parse(json["date"]);
    quantity = json["quantity"];
    profit = json["profit"];
    priceOfSell = json["priceOfSell"];
    sideExpenses = [for(var item in json["sideExpenses"]) SellSide.fromJson(item)];
    extraExpenses = json["extraExpenses"];
    size = ProductSize.fromJson(json["size"]);
    isRefunded = json["isRefunded"] ?? false;
    place = convertPlaceFromString(json["place"]);
  }

  Map<String, dynamic> toJson(){
    return {
      "product": product?.toJson(),
      "date": DateFormat('yyyy-MM-dd HH:mm:ss').format(date!),
      "quantity": quantity,
      "profit": profit,
      "priceOfSell": priceOfSell,
      "sideExpenses": [for(var item in sideExpenses) item.toJson()],
      "extraExpenses": extraExpenses,
      "size": size?.toJson(),
      "isRefunded": isRefunded,
      "place": getPlace(),
    };
  }

  String getAllSideExpenses(){
    String temp = "";
    for(var item in sideExpenses){
      temp += "${item.usedQuantity} ${item.side?.name}, ";
    }
    return temp;
  }

  String getPlace(){
    switch(place){
      case SellPlace.online: return "Online";
      case SellPlace.offline: return "Offline";
      case SellPlace.inEvent: return "In event";
      default: return "Other";
    }
  }

  SellPlace convertPlaceFromString(String value){
    switch(value){
      case "Online": return SellPlace.online;
      case "Offline": return SellPlace.offline;
      case "In event": return SellPlace.inEvent;
      default: return SellPlace.other;
    }
  }
}