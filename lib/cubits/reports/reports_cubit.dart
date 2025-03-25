import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:tabe3/models/report.dart';
import 'package:tabe3/models/sell.dart';
import 'package:tabe3/view/screens/reports/reports_result.dart';

part 'reports_state.dart';

class ReportsCubit extends Cubit<ReportsState> {
   Report? today;
   Report? week;
   Report? month;
   Report? threeMonths;
   DateTime? fromDate;
   DateTime? toDate;
   Report? currentReport;

  ReportsCubit() : super(ReportsInitial());
  static ReportsCubit get(BuildContext context) => BlocProvider.of(context);

  void setTodayReport(List<Sell> sells){
    List<Sell> todaySells = sells.where((e) => e.date!.difference(DateTime.now()).inDays == 0).toList();
    List<Sell> unRefundedSells = todaySells.where((e) => e.isRefunded == false).toList(); 
    int totalIncome = 0;
    int totalProfit = 0;
    int totalNumberOfSells = 0;

    for(var sell in unRefundedSells){
      if(!sell.isRefunded){
        totalIncome += sell.priceOfSell!;
        totalProfit += sell.profit;
        totalNumberOfSells += sell.quantity ?? 0;
      }
    }
    todaySells.sort((a,b) => b.date!.compareTo(a.date!));
    today = Report(
      noOfSells: totalNumberOfSells,
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
    int totalNumberOfSells = 0;

    for(var sell in weekSells){
      if(!sell.isRefunded){
        totalIncome += sell.priceOfSell!;
        totalProfit += sell.profit;
        totalNumberOfSells += sell.quantity ?? 0;
      }
    }
    weekSells.sort((a,b) => b.date!.compareTo(a.date!));
    week = Report(
      noOfSells: totalNumberOfSells,
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
    int totalNumberOfSells = 0;

    for(var sell in monthSells){
      if(!sell.isRefunded){
        totalIncome += sell.priceOfSell!;
        totalProfit += sell.profit;
        totalNumberOfSells += sell.quantity ?? 0;
      }
    }
    monthSells.sort((a,b) => b.date!.compareTo(a.date!));
    month = Report(
      noOfSells: totalNumberOfSells,
      totalIncome: totalIncome,
      totalProfit: totalProfit,
      sells: monthSells,
    );
    emit(GetReportState());
  }

  void setThreeMonthsReport(List<Sell> sells){
    List<Sell> threeMonthsells = sells.where((e) => DateTime.now().difference(e.date!).inDays <= 90).toList();
    int totalIncome = 0;
    int totalProfit = 0;
    int totalNumberOfSells = 0;
    
    for(var sell in threeMonthsells){
      if(!sell.isRefunded){
        totalIncome += sell.priceOfSell!;
        totalProfit += sell.profit;
        totalNumberOfSells += sell.quantity ?? 0;
      }
    }
    threeMonthsells.sort((a,b) => b.date!.compareTo(a.date!));
    threeMonths = Report(
      noOfSells: totalNumberOfSells,
      totalIncome: totalIncome,
      totalProfit: totalProfit,
      sells: threeMonthsells,
    );
    emit(GetReportState());
  }

  Report setFromToReport(List<Sell> sells){
    List<Sell> temp = sells.where((e) => isBetweenInclusive(e.date!, fromDate!, toDate!)).toList();
    int totalIncome = 0;
    int totalProfit = 0;
    int totalNumberOfSells = 0;
    for(var sell in temp){
      if(!sell.isRefunded){
        totalIncome += sell.priceOfSell!;
        totalProfit += sell.profit;
        totalNumberOfSells += sell.quantity ?? 0;
      }
    }
    temp.sort((a,b) => b.date!.compareTo(a.date!));
    return Report(
      noOfSells: totalNumberOfSells,
      totalIncome: totalIncome,
      totalProfit: totalProfit,
      sells: temp,
    );
  }

  bool isBetweenInclusive(DateTime target, DateTime start, DateTime end) {
    DateTime startOfDay = DateTime(start.year, start.month, start.day, 0, 0, 0);
    DateTime endOfDay = DateTime(end.year, end.month, end.day, 23, 59, 59, 999);
    return (target.isAfter(startOfDay) || target.isAtSameMomentAs(startOfDay)) &&
          (target.isBefore(endOfDay) || target.isAtSameMomentAs(endOfDay));
  }

  void setFromDate(DateTime value){
    fromDate = value;
    emit(GetReportState());
  }

  void setToDate(DateTime value){
    toDate = value;
    emit(GetReportState());
  }

  String getFromDate(){
    return "${fromDate?.day}/${fromDate?.month}/${fromDate?.year}";
  }

  String getToDate(){
    return "${toDate?.day}/${toDate?.month}/${toDate?.year}";
  }

  void onGetResults(BuildContext context, List<Sell> sells){
    if(fromDate != null && toDate != null){
      currentReport = setFromToReport(sells);
      Navigator.push(context, MaterialPageRoute(builder: (_) => ReportsResult()));
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Select date from and to first"))
      );
    }
  }

  void deductFromCurrentReport(int quantity, int profit, int totalIncome){
    currentReport?.noOfSells -= quantity;
    currentReport?.totalProfit -= profit;
    currentReport?.totalIncome -= totalIncome;

    currentReport != today ? today?.totalProfit -= profit : null;
    currentReport != week ? week?.totalProfit -= profit : null;
    currentReport != month ? month?.totalProfit -= profit : null;
    currentReport != threeMonths ? threeMonths?.totalProfit -= profit : null;
    emit(GetReportState());
  }

  void markRefundSell(Sell value){
    int i = currentReport?.sells.indexOf(value) ?? -1;
    if(i != -1){
      currentReport?.sells[i].isRefunded = true;
      emit(SellRemovedFromReportState());
    }
  }
}
