import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:tabe3/cubits/products/products_cubit.dart';
import 'package:tabe3/models/product.dart';
import 'package:tabe3/view/screens/products/product_details.dart';


class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        ProductsCubit.get(context).filteredProducts 
              = ProductsCubit.get(context).products;
        Navigator.push(context, MaterialPageRoute(builder: (_) => ProductDetails(product: product,)));
      },
      child: Container(
          width: 120,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(15),
            image: DecorationImage(
              fit: BoxFit.cover,
              image: product.image != null ? NetworkImage(product.image!) : AssetImage("assets/images/deafult.jpeg"),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Align(
              alignment: Alignment.bottomRight,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      child: Text(
                        "${product.price} LE",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
    );
  }
}