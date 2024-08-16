import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:tabe3/constants.dart';
import 'package:tabe3/enum.dart';
import 'package:tabe3/models/firebase/firestore_services.dart';
import 'package:tabe3/models/product.dart';
import 'package:tabe3/models/size.dart';
import 'package:tabe3/view/screens/products/products_screen.dart';

part 'products_state.dart';

class ProductsCubit extends Cubit<ProductsState> {
  List<Product> filteredProducts = [];
  List<Product> products = [];
  ProductsCubit() : super(ProductsInitial()){
    filteredProducts = products;
  }

  static ProductsCubit get(BuildContext context) => BlocProvider.of(context);

  void getProducts() async{
    if(products.isNotEmpty) return;

    emit(LoadingProductsState());
    var res = await FirestoreServices.getProducts();
    log(res.data.toString());
    if(res.status == Status.success){
      products = res.data;
      filteredProducts = products;
      emit(SuccessProductsState());
    }
    else{
      emit(FailProductsState());
    }
  }

  void addProduct(Product product, BuildContext context) async{
    emit(LoadingOneProductState());
    var res = await FirestoreServices.add(productsTable, product.toJson());
    if(res.status == Status.success){
      product.id = res.data.toString();
      products.add(product);
      filteredProducts = products;
      emit(ProductAddedState());
      Navigator.pop(context);
    }
    else{
      emit(FailOneProductState());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Try again later"), backgroundColor: Colors.red,)
      );
      return null;
    }
    
  }

  void filterProducts(String value){
    if(value.isEmpty){
      filteredProducts = products;
    }
    else{
      filteredProducts = products.where((e) => e.name!.startsWith(value)).toList();
    }
    emit(FilterState());
  }

  void editProduct(Product p, BuildContext context) async{
    int index = products.indexOf(p);
    if(index > -1){
      products[index] = p;
      emit(LoadingEditProductState());
      var res = await FirestoreServices.update(productsTable, products[index].id!, products[index].toJson());
      if(res.status == Status.success){
        emit(EditProductState());
        Navigator.of(context)..pop()..pop();
      }
      else{
        emit(FailEditProductState());
         ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Try again later"), backgroundColor: Colors.red,)
        );
      }
    }
  }

  void sellSize(Product p, ProductSize size){
    int i = products.indexOf(p);
    if(i != -1){
      int j = products[i].sizes.indexOf(size);
      products[i].sizes[j].quantity = products[i].sizes[j].quantity! - 1;
      FirestoreServices.update(productsTable, products[i].id!, products[i].toJson());
      emit(SellSizeState());
    }
  }

}
