import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:tabe3/models/product.dart';

part 'best_worst_state.dart';

class BestWorstCubit extends Cubit<BestWorstState> {
  List<Product> nearToEnd = [];

  BestWorstCubit() : super(BestWorstInitial());
  static BestWorstCubit get(BuildContext context) => BlocProvider.of(context);

  void setNearToEnd(List<Product> list){
    
    emit(SetNearToEndState());
  }
}
