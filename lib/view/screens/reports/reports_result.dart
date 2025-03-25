import 'dart:io';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabe3/constants.dart';
import 'package:tabe3/cubits/all_sells/all_sells_cubit.dart';
import 'package:tabe3/cubits/pie_chart/pie_chart_cubit.dart';
import 'package:tabe3/cubits/reports/reports_cubit.dart';
import 'package:tabe3/models/report.dart';
import 'package:tabe3/models/sell.dart';
import 'package:tabe3/view/screens/all_sells_screen.dart';
import 'package:tabe3/view/screens/best_products_screen.dart';
import 'package:tabe3/view/screens/pie_chart_screen.dart';
import 'package:tabe3/view/widgets/custom_button.dart';
import 'package:tabe3/view/widgets/report_card.dart';
import 'package:tabe3/view/widgets/sell_info.dart';

class ReportsResult extends StatefulWidget {
  final String title;
  //final Report report;
  const ReportsResult({super.key, this.title = "Report"});

  @override
  State<ReportsResult> createState() => _ReportsResultState();
}

class _ReportsResultState extends State<ReportsResult> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    PieChartCubit.get(context)
        .buildPieChart(ReportsCubit.get(context).currentReport?.sells ?? []);
  }

  @override
  Widget build(BuildContext context) {
    var current = ReportsCubit.get(context).currentReport;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.purple.shade800,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            BlocBuilder<ReportsCubit, ReportsState>(
              builder: (context, state) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ReportCard(
                      text: "Number of sells",
                      quantity: current!.noOfSells,
                    ),
                    Divider(),
                    ReportCard(
                        text: "Total income", quantity: current.totalIncome),
                    Divider(),
                    ReportCard(
                      text: "Profit",
                      quantity: current.totalProfit,
                      color: current.totalProfit >= 0
                          ? Colors.green.shade600
                          : Colors.red.shade600,
                    ),
                  ],
                );
              },
            ),
            Divider(),
            SizedBox(
              height: 15,
            ),
            Text("Bought by place"),
            BlocBuilder<PieChartCubit, PieChartState>(
              builder: (context, state) {
                return Visibility(
                  visible: PieChartCubit.get(context).data.isNotEmpty,
                  replacement: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: 15,
                        ),
                        Icon(
                          Icons.bar_chart,
                          size: 30,
                        ),
                        Text("No data to show")
                      ],
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 170,
                        child: PieChart(
                          PieChartData(
                            sectionsSpace: 4,
                            centerSpaceRadius: 30,
                            sections: _buildSections(context),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          for (var data in PieChartCubit.get(context).data)
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  width: 16,
                                  height: 16,
                                  color: data.color,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${data.name}',
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
            Divider(
              height: 40,
            ),
            // CustomButton(
            //   text: "Show highest products",
            //   onPressed: (){
            //     Navigator.push(context, MaterialPageRoute(
            //       builder: (_) => BestProductsScreen(sells: current?.sells ?? [])
            //     ));
            //   },
            // ),
            SizedBox(height: 20,),
            BlocBuilder<AllSellsCubit, AllSellsState>(
              builder: (context, state) {
                return ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, i) {
                    return InkWell(
                      borderRadius: BorderRadius.circular(50),
                      onTap: () {
                        showDetailsAlertDialog(context, current.sells[i]);
                      },
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 28,
                            backgroundImage: current
                                        .sells[i].product!.image !=
                                    null
                                ? FileImage(
                                    File(current.sells[i].product!.image!),
                                  )
                                : AssetImage("assets/images/default.png"),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "(${current.sells[i].quantity}) ${current.sells[i].product!.name}",
                                  style: TextStyle(
                                      decoration:
                                          current.sells[i].isRefunded
                                              ? TextDecoration.lineThrough
                                              : null),
                                ),
                                Text(
                                  current.sells[i].priceOfSell.toString(),
                                  style: TextStyle(
                                      decoration:
                                          current.sells[i].isRefunded
                                              ? TextDecoration.lineThrough
                                              : null),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          !current.sells[i].isRefunded
                              ? Text(
                                  current.sells[i].profit >= 0
                                      ? "+${current.sells[i].profit}"
                                      : "-${current.sells[i].profit}",
                                  style: TextStyle(
                                    color: current.sells[i].profit >= 0
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                                )
                              : Text(
                                  "Refunded",
                                  style: TextStyle(
                                    color: Colors.red,
                                  ),
                                ),
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (context, i) => SizedBox(
                    height: 15,
                  ),
                  itemCount: current!.sells.length,
                );
              },
            )
          ],
        ),
      ),
    );
  }

  showDetailsAlertDialog(BuildContext context, Sell sell) {
    // set up the button
    Widget okButton = TextButton(
      child: Text(
        "Done",
        style: TextStyle(color: mainColor),
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    Widget refundButton = TextButton(
      child: Text(
        "Refund",
        style: TextStyle(color: Colors.red),
      ),
      onPressed: () {
        AllSellsCubit.get(context).refund(context, sell);
        ReportsCubit.get(context).markRefundSell(sell);
        PieChartCubit.get(context).buildPieChart(
            ReportsCubit.get(context).currentReport?.sells ?? []);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      title: Text("Sell information"),
      content: SellInfo(sell: sell),
      actions: [
        okButton,
        if (!sell.isRefunded)
          BlocBuilder<AllSellsCubit, AllSellsState>(
            builder: (context, state) {
              if (state is LoadingRefundSellsState) {
                return Center(
                  child: CircularProgressIndicator(
                    color: Colors.red,
                  ),
                );
              } else
                return refundButton;
            },
          ),
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  List<PieChartSectionData> _buildSections(BuildContext context) {
    return PieChartCubit.get(context).data.map((data) {
      final double percentage =
          (data.value / PieChartCubit.get(context).totalValue) * 100;
      return PieChartSectionData(
        color: data.color,
        value: data.value.toDouble(),
        title: '${percentage.toStringAsFixed(0)}%',
        radius: 40,
        titleStyle: const TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }
}
