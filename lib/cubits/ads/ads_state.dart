part of 'ads_cubit.dart';

@immutable
sealed class AdsState {}

final class AdsInitial extends AdsState {}
final class AdsChangedState extends AdsState {}
