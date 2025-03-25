import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:tabe3/models/product.dart';
import 'package:tabe3/models/sell.dart';
part 'best_products_state.dart';

class BestProductsCubit extends Cubit<BestProductsState> {
  List<Product> bestProducts = [];

  BestProductsCubit() : super(BestProductsInitial());
  static BestProductsCubit get(BuildContext context) => BlocProvider.of(context);

  void getBestProducts(List<Product> products){
    bestProducts = products.where((e) => e.noOfSells > 0).toList();
    bestProducts.sort((a,b) => b.noOfSells.compareTo(a.noOfSells));
    if(bestProducts.length > 10){
      bestProducts = bestProducts.getRange(0,10).toList();
    }
    emit(BestProductsChangedState());
  }

  void getMostSoldProducts(List<Sell> sells) {
    // Create a map to store the total quantity sold for each product
    Map<Product, int> productQuantities = {};

    // Iterate through the sales list and calculate total quantities
    for (var sale in sells) {
      if (productQuantities.containsKey(sale.product)) {
        productQuantities[sale.product!] = productQuantities[sale.product!]! + (sale.quantity ?? 0);
      } else {
        productQuantities[sale.product!] = sale.quantity ?? 0;
      }
    }

    // Sort the products by quantity sold in descending order
    var sortedProducts = productQuantities.entries.toList()
      ..sort((a, b) => a.value.compareTo(b.value));

    var topProducts = sortedProducts.take(10).map((entry) => Product(name: entry.key.name, noOfSells: entry.value)).toList();
    bestProducts = topProducts;
    emit(BestProductsChangedState());
  }

  void getTopSellingProducts(List<Sell> sells, int topN) {
    // Create a map to store the total quantity sold for each product
    Map<int, Map<Product,int>> productSales = {};

    // Calculate total sales for each product
    for (var sell in sells) {
      if(sell.isRefunded) continue;

      Product product = sell.product!;
      int quantity = sell.quantity ?? 0;

      if (productSales.containsKey(product.id)) {
        productSales[product.id!]![product] = productSales[product.id!]![product]??0 + quantity;
      } else {
        if(product.id != null){
          productSales[product.id!] = {
            product : quantity,
          };
        }
      }
    }

    // Sort the products by total sales in descending order
    var sortedProducts = productSales.entries.toList()
      ..sort((a, b) => a.value.values.toList()[0].compareTo(b.value.values.toList()[0]));

    // Get the top N products
    var topProducts = sortedProducts.take(topN).map((entry) => entry.value.keys.toList()[0]).toList();
    bestProducts = topProducts;
    emit(BestProductsChangedState());
  }

  int getIncreasePercent(int i){
    if(i < 3){
      return 10;
    }
    else if(i < 6){
      return 8;
    }
    else{
      return 5;
    }
  }
}
