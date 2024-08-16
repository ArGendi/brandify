import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tabe3/constants.dart';
import 'package:tabe3/enum.dart';
import 'package:tabe3/models/data.dart';
import 'package:tabe3/models/product.dart';
import 'package:tabe3/models/sell.dart';
import 'package:tabe3/models/side.dart';

abstract class FirestoreServices{
  static Future<Data> add(String collection, Map<String, dynamic> data) async{
    try{
      var res = await FirebaseFirestore.instance.collection(collection).add(data);
      return Data<String>(res.id, Status.success);
    }
    catch(e){
      return Data<String>(e.toString(), Status.fail);
    }
  }

  static Future<Data> update(String collection, String id, Map<String, dynamic> data) async{
    try{
      await FirebaseFirestore.instance.collection(collection).doc(id).update(data);
      return Data<String>("done", Status.success);
    }
    catch(e){
      return Data<String>(e.toString(), Status.fail);
    }
  }

  static Future<Data> getProducts() async{
    try{
      var snapshot = await FirebaseFirestore.instance.collection(productsTable).get();
      List<Product> products = [];
      for(var doc in snapshot.docs){
        Map<String, dynamic> map = doc.data();
        log(map.toString());
        var p = Product.fromJson(map);
        p.id = doc.id;
        products.add(p);
      }
      return Data<List<Product>>(products, Status.success);
    }
    catch(e){
      return Data<String>(e.toString(), Status.fail);
    }
  }

  static Future<Data> getSides() async{
    try{
      var snapshot = await FirebaseFirestore.instance.collection(sidesTable).get();
      List<Side> sides = [];
      for(var doc in snapshot.docs){
        Map<String, dynamic> map = doc.data();
        var temp = Side.fromJson(map);
        temp.id = doc.id;
        sides.add(temp);
      }
      return Data<List<Side>>(sides, Status.success);
    }
    catch(e){
      return Data<String>(e.toString(), Status.fail);
    }
  }

  static Future<Data> getSells() async{
    try{
      var snapshot = await FirebaseFirestore.instance.collection(sellsTable).get();
      List<Sell> sells = [];
      for(var doc in snapshot.docs){
        Map<String, dynamic> map = doc.data();
        var temp = Sell.fromJson(map);
        temp.id = doc.id;
        sells.add(temp);
      }
      return Data<List<Sell>>(sells, Status.success);
    }
    catch(e){
      return Data<String>(e.toString(), Status.fail);
    }
  }

}