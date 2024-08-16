part of 'best_worst_cubit.dart';

@immutable
sealed class BestWorstState {}

final class BestWorstInitial extends BestWorstState {}
final class SetNearToEndState extends BestWorstState {}
