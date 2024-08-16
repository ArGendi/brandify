import 'package:tabe3/models/sell.dart';

class Report{
  int noOfSells = 0;
  int totalIncome = 0;
  int totalProfit = 0;
  List<Sell> sells = [];

  Report({this.noOfSells = 0, this.totalIncome = 0, this.totalProfit = 0, this.sells = const []});
}