import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:tabe3/models/product.dart';
import 'package:tabe3/models/sell.dart';

part 'one_product_sells_state.dart';

class OneProductSellsCubit extends Cubit<OneProductSellsState> {
  List<Sell> sells = [];

  OneProductSellsCubit() : super(OneProductSellsInitial());
  static OneProductSellsCubit get(BuildContext context) => BlocProvider.of(context);

  void getAllSellsOfProduct(List<Sell> allSells, Product product){
    sells = allSells.where((e) => e.product?.id == product.id).toList();
    emit(OneProductSellsChangedState());
  }
}
