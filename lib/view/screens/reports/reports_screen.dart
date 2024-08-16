import 'package:flutter/material.dart';
import 'package:tabe3/constants.dart';
import 'package:tabe3/view/screens/reports/tabs/day_tab.dart';
import 'package:tabe3/view/screens/reports/tabs/month_tab.dart';
import 'package:tabe3/view/screens/reports/tabs/week_tab.dart';
import 'package:tabe3/view/screens/reports/tabs/year_tab.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Reports"),
          backgroundColor: Colors.deepPurple.shade700,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: TabBar(
                indicatorColor: Colors.deepPurple.shade700,
                indicatorPadding: EdgeInsets.symmetric(horizontal: 20),
                indicatorWeight: 1,
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.white,
                labelStyle: TextStyle(color: Colors.deepPurple.shade700, fontSize: 14),
                tabs: [
                  Tab(text: "Toady", height: 30,),
                  Tab(text: "Week", height: 30,),
                  Tab(text: "Month", height: 30,),
                  Tab(text: "Year", height: 30,),
                ],
              ),
            ), // 
            Expanded(
              child: TabBarView(
                children: [
                  DayTab(),
                  WeekTab(),
                  MonthTab(),
                  YearTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}