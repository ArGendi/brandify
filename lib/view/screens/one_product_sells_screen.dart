import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:tabe3/constants.dart';
import 'package:tabe3/cubits/all_sells/all_sells_cubit.dart';
import 'package:tabe3/cubits/one_product_sells/one_product_sells_cubit.dart';
import 'package:tabe3/cubits/sell/sell_cubit.dart';
import 'package:tabe3/models/product.dart';
import 'package:tabe3/models/sell.dart';
import 'package:tabe3/view/widgets/sell_info.dart';

class OneProductSellsScreen extends StatefulWidget {
  final Product product;
  const OneProductSellsScreen({super.key, required this.product});

  @override
  State<OneProductSellsScreen> createState() => _OneProductSellsScreenState();
}

class _OneProductSellsScreenState extends State<OneProductSellsScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    OneProductSellsCubit.get(context).getAllSellsOfProduct(
      AllSellsCubit.get(context).sells, 
      widget.product,
    );
  }

  @override
  Widget build(BuildContext context) {
    var sells = OneProductSellsCubit.get(context).sells;
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.product.name} sells"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView.separated(
          itemBuilder: (context, i){
            return InkWell(
              borderRadius: BorderRadius.circular(50),
              onTap: () {
                showDetailsAlertDialog(context, sells[i]);
              },
              child: BlocBuilder<OneProductSellsCubit, OneProductSellsState>(
                builder: (context, state) {
                  return Row(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundImage:
                            sells[i].product!.image != null
                                ? FileImage(
                                    File(sells[i].product!.image!),
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
                              "(${sells[i].quantity}) ${sells[i].product!.name}",
                              style: TextStyle(
                                  decoration: sells[i].isRefunded
                                      ? TextDecoration.lineThrough
                                      : null),
                            ),
                            Text(
                              sells[i].priceOfSell.toString(),
                              style: TextStyle(
                                  decoration: sells[i].isRefunded
                                      ? TextDecoration.lineThrough
                                      : null),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Text(
                          "${DateFormat('yyyy-MM-dd').format(sells[i].date!)}",
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      !sells[i].isRefunded
                          ? Text(
                              sells[i].profit >= 0
                                  ? "+${sells[i].profit}"
                                  : "-${sells[i].profit}",
                              style: TextStyle(
                                color: sells[i].profit >= 0
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
                  );
                },
              ),
            );
          }, 
          separatorBuilder: (context, i) => SizedBox(height: 10,), 
          itemCount: OneProductSellsCubit.get(context).sells.length,
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
        //AllSellsCubit.get(context).refund(context, sell);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10)
      ),
      title: Text("Sell information"),
      content: SellInfo(sell: sell),
      actions: [
        okButton,
        if(!sell.isRefunded)
        BlocBuilder<OneProductSellsCubit, OneProductSellsState>(
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
}