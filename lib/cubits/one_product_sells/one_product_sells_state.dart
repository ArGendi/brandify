part of 'one_product_sells_cubit.dart';

@immutable
sealed class OneProductSellsState {}

final class OneProductSellsInitial extends OneProductSellsState {}
final class OneProductSellsChangedState extends OneProductSellsState {}
