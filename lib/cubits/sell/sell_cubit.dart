import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:meta/meta.dart';
import 'package:tabe3/constants.dart';
import 'package:tabe3/cubits/all_sells/all_sells_cubit.dart';
import 'package:tabe3/cubits/products/products_cubit.dart';
import 'package:tabe3/cubits/sides/sides_cubit.dart';
import 'package:tabe3/enum.dart';
import 'package:tabe3/models/firebase/firestore_services.dart';
import 'package:tabe3/models/product.dart';
import 'package:tabe3/models/sell.dart';
import 'package:tabe3/models/sell_side.dart';
import 'package:tabe3/models/side.dart';
import 'package:tabe3/models/size.dart';
part 'sell_state.dart';

class SellCubit extends Cubit<SellState> {
  List<SellSide> sides = [];
  bool onePercent = false;
  ProductSize? selectedSize;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  int? price;
  int quantity = 1;
  int? extra;
  SellPlace? place;

  SellCubit() : super(SellInitial());
  static SellCubit get(BuildContext context) => BlocProvider.of(context);

  // void selectSides(Side side){
  //   if(!selected.contains(side)){
  //     selected.add(side);
  //   }
  //   else{
  //     selected.remove(side);
  //   }
  //   emit(NewState());
  // }

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
      if(selectedSize != null || product.sizes.length == 1){
        if(selectedSize == null) selectedSize = product.sizes.first;

        double totalExpenses = extra?.toDouble() ?? 0;
        for(var item in sides){
          totalExpenses += item.side!.price! * (item.usedQuantity ?? 0);
        }
        int profit = price! - (quantity * product.price! + totalExpenses.toInt());
        Sell temp = Sell(
          product: product,
          date: DateTime.now(),
          quantity: quantity,
          size: selectedSize,
          priceOfSell: price!,
          profit: profit,
          extraExpenses: extra ?? 0,
          sideExpenses: sides.where((e) => (e.usedQuantity ?? 0) > 0).toList(),
          place: place ?? SellPlace.other
        );

        emit(LoadingSellState());
        int id = await Hive.box(sellsTable).add(temp.toJson());
        temp.id = id;
        // add in sell list
        AllSellsCubit.get(context).add(temp);
        // -1 for sold size
        ProductsCubit.get(context).sellSize(product, selectedSize!, quantity);
        // -1 from selected sides
        SidesCubit.get(context).subtract(sides);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              profit >=0 ? "+$profit 💸" : "-$profit 💳",
            ), 
            backgroundColor: profit >=0 ? Colors.green : mainColor,
          )
        );
        emit(SuccessSellState());
        Navigator.of(context)..pop()..pop();
      }
      else{
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Choose a size"), backgroundColor: Colors.red,)
        );
      }
    }
  }

  bool checkSelectedSize(BuildContext context){
    if(selectedSize == null){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Choose a size first"),)
      );
      return false;
    }
    return true;
  }

  void incQuantity(BuildContext context){
    if(!checkSelectedSize(context)) return;

    if(quantity < (selectedSize!.quantity ?? 1)){
      quantity++;
      emit(QuantityChangedSellState());
    }
  }

  void decQuantity(BuildContext context){
    if(!checkSelectedSize(context)) return;

    if(quantity > 1){
      quantity--;
      emit(QuantityChangedSellState());
    }
  }

  void incSideUsedQuantity(int i){
    if((sides[i].usedQuantity ?? 0) < (sides[i].side!.quantity ?? 1)){
      sides[i].usedQuantity = (sides[i].usedQuantity ?? 0) + 1;
      emit(QuantityChangedSellState());
    }
  }

  void decSideUsedQuantity(int i){
    if((sides[i].usedQuantity ?? 0) > 0){
      sides[i].usedQuantity = (sides[i].usedQuantity ?? 0) - 1;
      emit(QuantityChangedSellState());
    }
  }

  void setPlace(SellPlace value){
    place = value;
    emit(NewState());
  }
}
