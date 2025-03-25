import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:meta/meta.dart';
import 'package:tabe3/constants.dart';
import 'package:tabe3/enum.dart';
import 'package:tabe3/models/firebase/firestore_services.dart';
import 'package:tabe3/models/sell_side.dart';
import 'package:tabe3/models/side.dart';

part 'sides_state.dart';

class SidesCubit extends Cubit<SidesState> {
  List<Side> sides = [];
  String? name;
  int? price;
  int? quantity;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  SidesCubit() : super(SidesInitial());
  static SidesCubit get(BuildContext context) => BlocProvider.of(context);

  Future<bool> onAddSide(BuildContext context) async{
    bool valid = formKey.currentState?.validate() ?? false;
    if(valid){
      formKey.currentState?.save();
      Side temp = Side(name: name, price: price, quantity: quantity);
      emit(LoadingOneSideState());
      int id = await Hive.box(sidesTable).add(temp.toJson());
      temp.id = id;
      sides.add(temp);
      emit(AddSidesState());
      return true;
    }
    return false;
  }

  Future<List<Side>> SidesFromDB() async{
    List<Side> SidesFromDB = [];
    var sidesBox = Hive.box(sidesTable);
    var keys = sidesBox.keys.toList();
    for(var key in keys){
      Side temp = Side.fromJson(sidesBox.get(key));
      temp.id = key;
      SidesFromDB.add(temp);
    }
    return SidesFromDB;
  }

  void getAllSides() async{
    if(sides.isNotEmpty) return;
    
    emit(LoadingSidesState());
    sides = await SidesFromDB();
    emit(SuccessSidesState());
  }

  void remove(int i){
    Hive.box(sidesTable).delete(sides[i].id);
    sides.removeAt(i);
    emit(RemoveSidesState());
  }

  void subtract(List<SellSide> values){
    for(var value in values){
      if(value.side == null) continue;
      int i = sides.indexOf(value.side!);
      if(i != -1){
        sides[i].quantity = sides[i].quantity! - (value.usedQuantity ?? 0);
        Hive.box(sidesTable).put(sides[i].id, sides[i].toJson());
      }
    }
    emit(SubtractSidesState());
  }

  void refundSide(List<SellSide> values){
    try{
      for(var value in values){
        int i = sides.indexOf(value.side!);
        if(i != -1){
          sides[i].quantity = sides[i].quantity! + (value.usedQuantity ?? 0);
          bool exist = Hive.box(sidesTable).containsKey(sides[i].id);
          if(exist){
            Hive.box(sidesTable).put(sides[i].id, sides[i].toJson());
          }
          else{
            Hive.box(sidesTable).add(sides[i].toJson());
          }
          emit(AddSidesState());
        }
        else{
          Side temp = value.side!;
          temp.quantity = value.usedQuantity;
          sides.add(temp);
          Hive.box(sidesTable).add(temp.toJson());
        }
      }
    }
    catch(e){
      log(e.toString());
    }
  }
}
