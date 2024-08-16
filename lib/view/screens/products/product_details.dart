import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabe3/cubits/add_product/add_product_cubit.dart';
import 'package:tabe3/cubits/sell/sell_cubit.dart';
import 'package:tabe3/models/product.dart';
import 'package:tabe3/view/screens/products/add_product_screen.dart';
import 'package:tabe3/view/screens/sell_screen.dart';
import 'package:tabe3/view/widgets/custom_button.dart';
import 'package:tabe3/view/widgets/custom_texfield.dart';

class ProductDetails extends StatelessWidget {
  final Product product;
  const ProductDetails({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                Stack(
                  children: [
                    product.image != null
                        ? CachedNetworkImage(
                          imageUrl: product.image!,
                          placeholder: (context, url) => Container(
                            width: double.infinity,
                            height: 380,
                            color: Colors.grey.shade400,
                          ),
                        ) : Image.asset(
                            width: double.infinity,
                            height: 380,
                            "assets/images/deafult.jpeg",
                            fit: BoxFit.cover,
                          ),
                    Positioned(
                      top: 20,
                      left: 20,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.arrow_back_ios,
                            size: 16,
                          ),
                        ),
                      ),
                    ),
                    if(FirebaseAuth.instance.currentUser!.email! == "jee@ag.com")
                    Positioned(
                      top: 20,
                      right: 20,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => BlocProvider(
                                        create: (context) =>
                                            AddProductCubit(),
                                        child: AddProductScreen(
                                          product: product,
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
                      Row(
                        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              product.name.toString(),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Text(
                            "${product.price} LE",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
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
                      for (var value in product.sizes)
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
                  padding: const EdgeInsets.all(16.0),
                  child: CustomButton(
                    text: "Sell it now",
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => BlocProvider(
                                    create: (context) => SellCubit(),
                                    child: SellScreen(product: product),
                                  )));
                    },
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
