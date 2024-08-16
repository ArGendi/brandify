import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:tabe3/constants.dart';
import 'package:tabe3/cubits/all_sells/all_sells_cubit.dart';
import 'package:tabe3/cubits/products/products_cubit.dart';
import 'package:tabe3/cubits/sides/sides_cubit.dart';
import 'package:tabe3/enum.dart';
import 'package:tabe3/models/firebase/firestore_services.dart';
import 'package:tabe3/models/product.dart';
import 'package:tabe3/models/sell.dart';
import 'package:tabe3/models/side.dart';
import 'package:tabe3/models/size.dart';

part 'sell_state.dart';

class SellCubit extends Cubit<SellState> {
  List<Side> selected = [];
  bool onePercent = false;
  ProductSize? selectedSize;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  int? price;
  int? extra;

  SellCubit() : super(SellInitial());
  static SellCubit get(BuildContext context) => BlocProvider.of(context);

  void selectSides(Side side){
    if(!selected.contains(side)){
      selected.add(side);
    }
    else{
      selected.remove(side);
    }
    emit(NewState());
  }

  void selectSize(ProductSize size){
    selectedSize = size;
    emit(NewState());
  }

  void checkOnePercent(){
    onePercent = !onePercent;
    emit(NewState());
  }
  

  Future<void> onDone(BuildContext context, Product product) async{
    bool valid = formKey.currentState?.validate() ?? false;
    if(valid){
      formKey.currentState?.save();
      if(selectedSize != null){
        double totalExpenses = extra?.toDouble() ?? 0;
        if(onePercent){
          double one = price! * 0.01;
          totalExpenses += one;
        }
        for(var side in selected){
          totalExpenses += side.price!;
        }
        Sell temp = Sell(
          product: product,
          date: DateTime.now(),
          quantity: 1,
          priceOfSell: price,
          profit: price! - (product.price! + totalExpenses.toInt()),
        );
        emit(LoadingSellState());
        var res = await FirestoreServices.add(sellsTable, temp.toJson());
        if(res.status == Status.success){
          // add in sell list
          AllSellsCubit.get(context).add(temp);
          // -1 for sold size
          ProductsCubit.get(context).sellSize(product, selectedSize!);
          // -1 from selected sides
          SidesCubit.get(context).subtract(selected);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Wlaaaa3 😉"))
          );
          emit(SuccessSellState());
          Navigator.of(context)..pop()..pop();
        }
        else{
          emit(FailSellState());
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("try again later"), backgroundColor: Colors.red,)
          );
        }
      }
      else{
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Choose a size"), backgroundColor: Colors.red,)
        );
      }
    }
  }

  // void incQuantity(Product p){
  //   if(quantity < p.)
  //   quantity++;
  // }
}
