import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:tabe3/enum.dart';
import 'package:tabe3/models/firebase/firestore_services.dart';
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
    emit(NewSellsAddedState());
  }

  void getSells() async{
    if(sells.isNotEmpty) return;

    //emit(LoadingAllSellsState());
    var res = await FirestoreServices.getSells();
    if(res.status == Status.success){
      sells = res.data;
      for(var one in sells){
        total += one.priceOfSell!;
        totalProfit += one.profit;
      }
      emit(SuccessAllSellsState());
    }
    else{
      //emit(FailProductsState());
    }
  }

}
