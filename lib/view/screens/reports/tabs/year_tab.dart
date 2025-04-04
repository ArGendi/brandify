import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabe3/cubits/all_sells/all_sells_cubit.dart';
import 'package:tabe3/cubits/reports/reports_cubit.dart';
import 'package:tabe3/models/sell.dart';
import 'package:tabe3/view/screens/all_sells_screen.dart';
import 'package:tabe3/view/screens/products/products_screen.dart';
import 'package:tabe3/view/widgets/report_card.dart';

class YearTab extends StatefulWidget {
  const YearTab({super.key});

  @override
  State<YearTab> createState() => _YearTabState();
}

class _YearTabState extends State<YearTab> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    List<Sell> all = AllSellsCubit.get(context).sells;
    //ReportsCubit.get(context).setYearReport(all);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: BlocBuilder<ReportsCubit, ReportsState>(
        builder: (context, state) {
          return ListView(
            children: [
              GestureDetector(
                onTap: () {
                  if(ReportsCubit.get(context).threeMonths!.sells.isNotEmpty)
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => AllSellsScreen(
                                sells: ReportsCubit.get(context).threeMonths!.sells,
                              )));
                },
                child: ReportCard(
                  text: "Number of sells",
                  quantity: ReportsCubit.get(context).threeMonths?.noOfSells ?? 0,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              ReportCard(
                  text: "Total income",
                  quantity: ReportsCubit.get(context).threeMonths?.totalIncome ?? 0),
              SizedBox(
                height: 15,
              ),
              ReportCard(
                text: "Profit",
                quantity: ReportsCubit.get(context).threeMonths?.totalProfit ?? 0,
                color: (ReportsCubit.get(context).threeMonths?.totalProfit ?? 0) >= 0
                    ? Colors.green.shade600
                    : Colors.red.shade600,
              ),
            ],
          );
        },
      ),
    );
  }
}
