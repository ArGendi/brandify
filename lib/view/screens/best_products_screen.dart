import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:tabe3/cubits/best_products/best_products_cubit.dart';
import 'package:tabe3/cubits/products/products_cubit.dart';
import 'package:tabe3/models/sell.dart';
import 'package:tabe3/view/screens/products/product_details.dart';
import 'package:tabe3/view/widgets/product_card.dart';

class BestProductsScreen extends StatefulWidget {
  final List<Sell> sells; 
  const BestProductsScreen({super.key, required this.sells});

  @override
  State<BestProductsScreen> createState() => _BestProductsScreenState();
}

class _BestProductsScreenState extends State<BestProductsScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BestProductsCubit.get(context).getMostSoldProducts(widget.sells);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Top 10 Products"),
        backgroundColor: Colors.green.shade900,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: BlocBuilder<BestProductsCubit, BestProductsState>(
          builder: (context, state) {
            return Visibility(
              visible: BestProductsCubit.get(context).bestProducts.isNotEmpty,
              replacement: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Lottie.asset(
                      "assets/animations/request.json",
                      width: 300,
                    ),
                    //SizedBox(height: 20,),
                    Text("No sells yet")
                  ],
                ),
              ),
              child: ListView.separated(
                shrinkWrap: true,
                separatorBuilder: (context, index) => SizedBox(height: 10,),
                itemBuilder: (_, i) {
                  return InkWell(
                    borderRadius: BorderRadius.circular(50),
                    onTap: () {
                      // Navigator.push(context, 
                      // MaterialPageRoute(builder: (_) => ProductDetails(
                      //   product: BestProductsCubit.get(context).bestProducts[i]
                      // )));
                    },
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundImage: BestProductsCubit.get(context).bestProducts[i].image != null
                              ? FileImage(
                                  File(BestProductsCubit.get(context).bestProducts[i].image!),
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
                                BestProductsCubit.get(context).bestProducts[i].name.toString(),
                                style: TextStyle(),
                              ),
                              if(BestProductsCubit.get(context).bestProducts[i].noOfSells >= 100)
                              Text(
                                "Suggest you to raise sell price by ${BestProductsCubit.get(context).getIncreasePercent(i)}%",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "${BestProductsCubit.get(context).bestProducts[i].noOfSells}",
                          style: TextStyle(
                            color: Colors.green.shade700,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ],
                    ),
                  );
                },
                itemCount: BestProductsCubit.get(context)
                    .bestProducts
                    .length,
              ),
            );
          },
        ),
      ),
    );
  }
}