part of 'all_sells_cubit.dart';

@immutable
sealed class AllSellsState {}

final class AllSellsInitial extends AllSellsState {}
final class NewSellsAddedState extends AllSellsState {}
class LoadingAllSellsState extends AllSellsState {}
class SuccessAllSellsState extends AllSellsState {}
class FailAllSellsState extends AllSellsState {}
