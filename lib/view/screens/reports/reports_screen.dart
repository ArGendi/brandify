import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabe3/constants.dart';
import 'package:tabe3/cubits/all_sells/all_sells_cubit.dart';
import 'package:tabe3/cubits/reports/reports_cubit.dart';
import 'package:tabe3/cubits/sell/sell_cubit.dart';
import 'package:tabe3/models/sell.dart';
import 'package:tabe3/view/screens/reports/reports_result.dart';
import 'package:tabe3/view/screens/reports/tabs/day_tab.dart';
import 'package:tabe3/view/screens/reports/tabs/month_tab.dart';
import 'package:tabe3/view/screens/reports/tabs/week_tab.dart';
import 'package:tabe3/view/screens/reports/tabs/year_tab.dart';
import 'package:tabe3/view/widgets/custom_button.dart';
import 'package:tabe3/view/widgets/report_wide_card.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    List<Sell> all = AllSellsCubit.get(context).sells;
    ReportsCubit.get(context).setTodayReport(all);
    ReportsCubit.get(context).setWeekReport(all);
    ReportsCubit.get(context).setMonthReport(all);
    ReportsCubit.get(context).setThreeMonthsReport(all);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Reports"),
        backgroundColor: Colors.deepPurple.shade800,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      if (ReportsCubit.get(context).today != null) {
                        ReportsCubit.get(context).currentReport =
                            ReportsCubit.get(context).today;
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => ReportsResult()));
                      }
                    },
                    child: BlocBuilder<ReportsCubit, ReportsState>(
                      builder: (context, state) {
                        return ReportWideCard(
                          text:
                              "Today\n+${ReportsCubit.get(context).today?.totalProfit}",
                          color: mainColor,
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      if (ReportsCubit.get(context).week != null) {
                        ReportsCubit.get(context).currentReport =
                            ReportsCubit.get(context).week;
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => ReportsResult()));
                      }
                    },
                    child: BlocBuilder<ReportsCubit, ReportsState>(
                      builder: (context, state) {
                        return ReportWideCard(
                          text:
                              "7 days\n+${ReportsCubit.get(context).week?.totalProfit}",
                          color: Colors.deepPurple.shade600,
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      if (ReportsCubit.get(context).month != null) {
                        ReportsCubit.get(context).currentReport =
                            ReportsCubit.get(context).month;
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => ReportsResult()));
                      }
                    },
                    child: BlocBuilder<ReportsCubit, ReportsState>(
                      builder: (context, state) {
                        return ReportWideCard(
                          text:
                              "This month\n+${ReportsCubit.get(context).month?.totalProfit}",
                          color: Colors.deepPurple.shade800,
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: GestureDetector(
                  onTap: () {
                    if (ReportsCubit.get(context).threeMonths != null) {
                      ReportsCubit.get(context).currentReport =
                          ReportsCubit.get(context).threeMonths;
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => ReportsResult()));
                    }
                  },
                  child: BlocBuilder<ReportsCubit, ReportsState>(
                    builder: (context, state) {
                      return ReportWideCard(
                        text:
                            "3 months\n+${ReportsCubit.get(context).threeMonths?.totalProfit}",
                        color: Colors.deepPurple.shade900,
                      );
                    },
                  ),
                )),
              ],
            ),
            SizedBox(
              height: 25,
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 1,
                    color: Colors.grey.shade300,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Text("Choose between"),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Container(
                    height: 1,
                    color: Colors.grey.shade300,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            BlocBuilder<ReportsCubit, ReportsState>(
              builder: (context, state) {
                return CustomButton(
                  text: ReportsCubit.get(context).fromDate == null
                      ? "From date"
                      : ReportsCubit.get(context).getFromDate(),
                  onPressed: () async {
                    var date = await showDatePicker(
                      context: context,
                      firstDate: DateTime(2025),
                      lastDate: DateTime.now(),
                    );
                    if (date != null) {
                      ReportsCubit.get(context).setFromDate(date);
                    }
                  },
                  bgColor: Colors.grey.shade600,
                );
              },
            ),
            SizedBox(
              height: 5,
            ),
            BlocBuilder<ReportsCubit, ReportsState>(
              builder: (context, state) {
                return CustomButton(
                  text: ReportsCubit.get(context).toDate == null
                      ? "To date"
                      : ReportsCubit.get(context).getToDate(),
                  onPressed: () async {
                    if (ReportsCubit.get(context).fromDate == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Select from date first")));
                      return;
                    }
                    var date = await showDatePicker(
                      context: context,
                      firstDate:
                          ReportsCubit.get(context).fromDate ?? DateTime(2025),
                      lastDate: DateTime.now(),
                    );
                    if (date != null) {
                      ReportsCubit.get(context).setToDate(date);
                    }
                  },
                  bgColor: Colors.grey.shade600,
                );
              },
            ),
            SizedBox(
              height: 5,
            ),
            CustomButton(
              text: "Get Results 🔥",
              onPressed: () {
                ReportsCubit.get(context).onGetResults(
                  context,
                  AllSellsCubit.get(context).sells,
                );
              },
              //bgColor: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
