import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:tabe3/models/report.dart';
import 'package:tabe3/models/sell.dart';

part 'reports_state.dart';

class ReportsCubit extends Cubit<ReportsState> {
   Report? today;
   Report? week;
   Report? month;
   Report? year;

  ReportsCubit() : super(ReportsInitial());
  static ReportsCubit get(BuildContext context) => BlocProvider.of(context);

  void setTodayReport(List<Sell> sells){
    List<Sell> todaySells = sells.where((e) => e.date!.difference(DateTime.now()).inDays == 0).toList();
    int totalIncome = 0;
    int totalProfit = 0;
    for(var sell in todaySells){
      totalIncome += sell.priceOfSell!;
      totalProfit += sell.profit;
    }
    today = Report(
      noOfSells: todaySells.length,
      totalIncome: totalIncome,
      totalProfit: totalProfit,
      sells: todaySells,
    );
    emit(GetReportState());
  }

  void setWeekReport(List<Sell> sells){
    List<Sell> weekSells = sells.where((e) => DateTime.now().difference(e.date!).inDays <= 7).toList();
    int totalIncome = 0;
    int totalProfit = 0;
    for(var sell in weekSells){
      totalIncome += sell.priceOfSell!;
      totalProfit += sell.profit;
    }
    week = Report(
      noOfSells: weekSells.length,
      totalIncome: totalIncome,
      totalProfit: totalProfit,
      sells: weekSells,
    );
    emit(GetReportState());
  }

  void setMonthReport(List<Sell> sells){
    List<Sell> monthSells = sells.where((e) => DateTime.now().difference(e.date!).inDays <= 30).toList();
    int totalIncome = 0;
    int totalProfit = 0;
    for(var sell in monthSells){
      totalIncome += sell.priceOfSell!;
      totalProfit += sell.profit;
    }
    month = Report(
      noOfSells: monthSells.length,
      totalIncome: totalIncome,
      totalProfit: totalProfit,
      sells: monthSells,
    );
    emit(GetReportState());
  }

  void setYearReport(List<Sell> sells){
    List<Sell> yearSells = sells.where((e) => DateTime.now().difference(e.date!).inDays <= 365).toList();
    int totalIncome = 0;
    int totalProfit = 0;
    for(var sell in yearSells){
      totalIncome += sell.priceOfSell!;
      totalProfit += sell.profit;
    }
    year = Report(
      noOfSells: yearSells.length,
      totalIncome: totalIncome,
      totalProfit: totalProfit,
      sells: yearSells,
    );
    emit(GetReportState());
  }
}
