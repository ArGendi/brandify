import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:tabe3/cubits/best_worst/best_worst_cubit.dart';
import 'package:tabe3/view/widgets/product_card.dart';

class BestWorstScreen extends StatelessWidget {
  const BestWorstScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("الأكثر مبيعاً"),
        backgroundColor: Colors.blue.shade900,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: BlocBuilder<BestWorstCubit, BestWorstState>(
            builder: (context, state) {
              return Visibility(
                visible: BestWorstCubit.get(context).nearToEnd.isNotEmpty,
                replacement: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Lottie.asset(
                        "assets/animations/request.json",
                        width: 300,
                      ),
                      //SizedBox(height: 20,),
                      Text("مفيش اي منتجات")
                    ],
                  ),
                ),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate:
                      SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 15,
                          crossAxisSpacing: 15,
                          childAspectRatio: 0.75),
                  itemBuilder: (_, i) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: SizedBox(
                            width: double.infinity,
                            child: ProductCard(
                                product: BestWorstCubit.get(context)
                                    .nearToEnd[i]),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                "عدد المبيعات",
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(fontSize: 13),
                              ),
                            ),
                            SizedBox( width: 10,),
                            Text(
                              BestWorstCubit.get(context).nearToEnd[i]
                                    .noOfSales.toString(),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                  itemCount: BestWorstCubit.get(context)
                      .nearToEnd
                      .length,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}