import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabe3/cubits/add_product/add_product_cubit.dart';
import 'package:tabe3/cubits/one_product_sells/one_product_sells_cubit.dart';
import 'package:tabe3/cubits/products/products_cubit.dart';
import 'package:tabe3/cubits/sell/sell_cubit.dart';
import 'package:tabe3/models/product.dart';
import 'package:tabe3/view/screens/one_product_sells_screen.dart';
import 'package:tabe3/view/screens/products/add_product_screen.dart';
import 'package:tabe3/view/screens/sell_screen.dart';
import 'package:tabe3/view/widgets/custom_button.dart';
import 'package:tabe3/view/widgets/custom_texfield.dart';

class ProductDetails extends StatefulWidget {
  final Product product;
  const ProductDetails({super.key, required this.product});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  int totalQuantity = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    totalQuantity = widget.product.getNumberOfAllItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  Stack(
                    children: [
                      widget.product.image != null
                          ? Image.file(
                            File(widget.product.image!),
                            // width: MediaQuery.of(context).size.width,
                            // height: MediaQuery.of(context).size.height * 0.75,
                            fit: BoxFit.cover,
                          ) : Image.asset(
                              width: double.infinity,
                              height: 380,
                              "assets/images/default.png",
                              fit: BoxFit.cover,
                            ),
                      Positioned(
                        top: 20,
                        left: 20,
                        child: IconButton(
                          onPressed: (){
                            Navigator.pop(context);
                          }, 
                          icon: Icon(
                            Icons.arrow_back_ios,
                            size: 22,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      //if(FirebaseAuth.instance.currentUser!.email! == "jee@ag.com")
                      Positioned(
                        top: 20,
                        right: 20,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            GestureDetector(
                              onTap: () {
                                showDeleteAlertDialog(context);
                              },
                              child: CircleAvatar(
                                radius: 20,
                                backgroundColor: Colors.red,
                                child: Icon(
                                  Icons.delete,
                                  size: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(width: 10,),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => BlocProvider(
                                              create: (context) =>
                                                  AddProductCubit(),
                                              child: AddProductScreen(
                                                product: widget.product,
                                              ),
                                            )));
                              },
                              child: CircleAvatar(
                                radius: 20,
                                backgroundColor: Colors.white,
                                child: Icon(
                                  Icons.edit,
                                  size: 16,
                                ),
                              ),
                            ),
                            
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // if(widget.product.code != null)
                        // Text(
                        //   "Code: ${widget.product.code}",
                        //   textAlign: TextAlign.center,
                        //   style: TextStyle(
                        //     fontSize: 11,
                        //   ),
                        // ),
                        Row(
                          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                widget.product.name.toString(),
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Text(
                              "${widget.product.price} LE",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                "$totalQuantity total items",
                                style: TextStyle(
                                  fontSize: 13,
                                  //fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Text(
                              "${widget.product.price! * totalQuantity} LE",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 13,
                                // fontWeight: FontWeight.bold,
                                // color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                        Divider(
                          height: 40,
                          color: Colors.grey.shade300,
                          indent: 20,
                          endIndent: 20,
                        ),
                        Text(
                          "Available sizes",
                          style: TextStyle(
                              //fontWeight: FontWeight.bold,
                              ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        for (var value in widget.product.sizes)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Container(
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.grey.shade400),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      value.name.toString(),
                                      style: TextStyle(),
                                    ),
                                    Text(
                                      value.quantity.toString(),
                                      style: TextStyle(),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        SizedBox(
                          height: 30,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: double.infinity,
                  height: 1,
                  color: Colors.grey.shade300,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        CustomButton(
                          text: "Sell it now",
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => BlocProvider(
                                    create: (context) => SellCubit(),
                                    child: SellScreen(product: widget.product),
                                  )));
                          },
                        ),
                        CustomButton(
                          text: "Refund",
                          bgColor: Colors.red.shade900,
                          onPressed: () {
                            Navigator.push(
                              context, MaterialPageRoute(
                                builder: (_) => OneProductSellsScreen(product: widget.product,)
                              ));
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  showDeleteAlertDialog(BuildContext context) {

    // set up the button
    Widget okButton = TextButton(
      child: Text("Delete", style: TextStyle(color: Colors.red),),
      onPressed: () { 
        ProductsCubit.get(context).deleteProduct(widget.product, context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Delete the product 😢"),
      content: Text("Are you sure you want to delete ${widget.product.name} ??"),
      actions: [
        okButton,
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
