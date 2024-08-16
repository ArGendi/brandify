import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:tabe3/constants.dart';
import 'package:tabe3/enum.dart';
import 'package:tabe3/models/firebase/firestore_services.dart';
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
      var res = await FirestoreServices.add(sidesTable, temp.toJson());
      if(res.status == Status.success){
        sides.add(temp);
        emit(AddSidesState());
        return true;
      }
      else{
        emit(FailOneSideState());
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Try again later"), backgroundColor: Colors.red,)
        );
        return false;
      }
    }
    return false;
  }

  void getAllSides() async{
    if(sides.isNotEmpty) return;
    
    emit(LoadingSidesState());
    var res = await FirestoreServices.getSides();
    if(res.status == Status.success){
      sides = res.data;
      emit(SuccessSidesState());
    }
    else{
      emit(FailSidesState());
    }
  }

  void remove(int i){
    sides.removeAt(i);
    emit(RemoveSidesState());
  }

  void subtract(List<Side> values){
    for(var value in values){
      int i = sides.indexOf(value);
      if(i != -1){
        sides[i].quantity = sides[i].quantity! - 1;
        FirestoreServices.update(sidesTable, sides[i].id!, sides[i].toJson());
      }
    }
    emit(SubtractSidesState());
  }
}
