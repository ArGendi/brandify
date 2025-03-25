import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:meta/meta.dart';
import 'package:tabe3/constants.dart';
import 'package:tabe3/cubits/products/products_cubit.dart';
import 'package:tabe3/cubits/reports/reports_cubit.dart';
import 'package:tabe3/cubits/sides/sides_cubit.dart';
import 'package:tabe3/enum.dart';
import 'package:tabe3/models/firebase/firestore_services.dart';
import 'package:tabe3/models/local/cache.dart';
import 'package:tabe3/models/product.dart';
import 'package:tabe3/models/sell.dart';

part 'all_sells_state.dart';

class AllSellsCubit extends Cubit<AllSellsState> {
  List<Sell> sells = [];
  int totalProfit = 0;
  int total = 0;

  AllSellsCubit() : super(AllSellsInitial());
  static AllSellsCubit get(BuildContext context) => BlocProvider.of(context);

  void add(Sell sell){
    total += sell.priceOfSell!;
    totalProfit += sell.profit;
    sells.add(sell);
    Cache.setTotal(total);
    emit(NewSellsAddedState());
  }

  void addTotalAndProfit(int totalValue, int profitValue){
    total += totalValue;
    totalProfit += profitValue;
    Cache.setTotal(totalProfit);
    emit(ProfitChangedState());
  }

  void getTotalAndProfit(){
    total = Cache.getTotal() ?? 0;
    totalProfit = Cache.getProfit() ?? 0;
    emit(ProfitChangedState());
  }

  Future<List<Sell>> getSellsFromDB() async{
    List<Sell> sellsFromDB = [];
    var sellsBox = Hive.box(sellsTable);
    var keys = sellsBox.keys.toList();
    for(var key in keys){
      Sell temp = Sell.fromJson(sellsBox.get(key));
      temp.id = key;
      sellsFromDB.add(temp);
    }
    return sellsFromDB;
  }

  void getSells({int ads = 0}) async{
    if(sells.isNotEmpty) return;

    //emit(LoadingAllSellsState());
    sells = await getSellsFromDB();
    sells.sort((a,b) => b.date!.compareTo(a.date!));
    for(var one in sells){
      if(!one.isRefunded){
        total += one.priceOfSell!;
        totalProfit += one.profit;
      }
    }
    totalProfit -= ads;
    emit(SuccessAllSellsState());
  }

  void refund(BuildContext context, Sell targetSell) async{
    emit(LoadingRefundSellsState());
    try{
      log("${targetSell.product?.id} : ${targetSell.size?.toJson()}");
      Product? refundedProduct = ProductsCubit.get(context).refundProduct(
        targetSell.product?.id,
        targetSell.size!,
        targetSell.quantity ?? 0,
      );
      log(refundedProduct?.toJson().toString() ?? "No refund");
      int index = sells.indexOf(targetSell);
      if(refundedProduct != null && targetSell.product != null && index > -1){
        sells[index].isRefunded = true;
        SidesCubit.get(context).refundSide(targetSell.sideExpenses);
        await Hive.box(productsTable).put(targetSell.product!.id, refundedProduct.toJson());
        await Hive.box(sellsTable).put(sells[index].id, sells[index].toJson());
        total -= sells[index].priceOfSell ?? 0;
        totalProfit -= sells[index].profit;

        log(sells[index].profit.toString());

        ReportsCubit.get(context).deductFromCurrentReport(
          sells[index].quantity ?? 0, 
          sells[index].profit,
          sells[index].priceOfSell ?? 0,
        );

        emit(RefundSellsState());
        if(context.mounted){
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Refund Done"), backgroundColor: Colors.green,)
          );
          Navigator.of(context).pop();
        }
      }
      else{
        emit(FailRefundSellsState());
        if(context.mounted){
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Can't make the refund 😥"), backgroundColor: Colors.red,)
          );
        }
      }
    }
    catch(e){
      emit(FailRefundSellsState());
      if(context.mounted){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("$e"), backgroundColor: Colors.red,)
        );
      }
    }
    
  }

  void deductFromProfit(int value){
    totalProfit -= value;
    emit(ProfitChangedState());
  }

}
