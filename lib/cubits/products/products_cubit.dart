import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:meta/meta.dart';
import 'package:tabe3/constants.dart';
import 'package:tabe3/enum.dart';
import 'package:tabe3/models/firebase/firestore_services.dart';
import 'package:tabe3/models/product.dart';
import 'package:tabe3/models/size.dart';
import 'package:tabe3/view/screens/products/product_details.dart';
import 'package:tabe3/view/screens/products/products_screen.dart';

part 'products_state.dart';

class ProductsCubit extends Cubit<ProductsState> {
  List<Product> filteredProducts = [];
  List<Product> products = [];
  TextEditingController searchController = TextEditingController();

  ProductsCubit() : super(ProductsInitial()){
    filteredProducts = products;
  }

  static ProductsCubit get(BuildContext context) => BlocProvider.of(context);

  Future<List<Product>> getProductsFromDB() async{
    List<Product> productsFromDB = [];
    var productsBox = Hive.box(productsTable);
    var keys = productsBox.keys.toList();
    for(var key in keys){
      Product temp = Product.fromJson(productsBox.get(key));
      temp.id = key;
      productsFromDB.add(temp);
    }
    return productsFromDB;
  }

  void getProducts() async{
    if(products.isNotEmpty) return;

    emit(LoadingProductsState());
    products = await getProductsFromDB();
    filteredProducts = products;
    emit(SuccessProductsState());
  }

  void addProduct(Product product, BuildContext context) async{
    emit(LoadingOneProductState());
    try{
      var productBox = Hive.box(productsTable);
      product.id = await productBox.add(product.toJson());
      products.add(product);
      filteredProducts = products;
      log(filteredProducts.toString());
      emit(ProductAddedState());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Done 😉"))
      );
      Navigator.pop(context);
    }
    catch(e){
      emit(FailOneProductState());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Try again later"), backgroundColor: Colors.red,)
      );

    }
  }

  void deleteProduct(Product product, BuildContext context) async{
    emit(LoadingOneProductState());
    try{
      var productBox = Hive.box(productsTable);
      await productBox.delete(product.id ?? -1);
      products.remove(product);
      filteredProducts = products;
      emit(ProductAddedState());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Product Deleted"))
      );
      Navigator.of(context)..pop()..pop();
    }
    catch(e){
      emit(FailOneProductState());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Try again later"), backgroundColor: Colors.red,)
      );

    }
  }

  void filterProducts(String value){
    if(value.isEmpty){
      filteredProducts = products;
    }
    else{
      filteredProducts = products.where((e) => e.name.toString().toLowerCase().startsWith(value.toString().toLowerCase())).toList();
    }
    emit(FilterState());
  }

  void editProduct(Product oldProduct, Product newProduct, BuildContext context) async{
    int index = products.indexOf(oldProduct);
    if(index > -1){
      products[index] = newProduct;
      emit(LoadingEditProductState());
      Hive.box(productsTable).put(oldProduct.id, newProduct.toJson());
      emit(EditProductState());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Edited Done 🤙"))
      );
      Navigator.of(context)..pop()..pop();
    }
  }

  void sellSize(Product p, ProductSize size, int quantity){
    int i = products.indexOf(p);
    if(i != -1){
      int j = products[i].sizes.indexOf(size);
      products[i].sizes[j].quantity = products[i].sizes[j].quantity! - quantity;
      products[i].noOfSells += quantity;
      Hive.box(productsTable).put(products[i].id!, products[i].toJson());
      //FirestoreServices.update(productsTable, products[i].id!, products[i].toJson());
      emit(SellSizeState());
    }
  }

  void getProductByCode(BuildContext context, String code){
    List<Product> temp = products.where((item) => item.code == code).toList();
    if(temp.isNotEmpty){
      Navigator.push(context, MaterialPageRoute(builder: (_) => ProductDetails(product: temp.first)));
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Doesn't exist 🤔"))
      );
    }
  }

  Product? refundProduct(int? id, ProductSize size, int quantity) {
    if(id == null) return null;
    for(int i=0; i<products.length; i++){
      if(products[i].id == id){
        for(int j=0; j<products[i].sizes.length; j++){
          if(products[i].sizes[j].name == size.name){
            products[i].sizes[j].quantity = products[i].sizes[j].quantity! + quantity;
            products[i].noOfSells -= quantity;
            log("Sells: ${products[i].noOfSells}");
            filteredProducts = products;
            emit(EditProductState());
            return products[i];
          }
        }
      }
    }
    return null;
  }

}
