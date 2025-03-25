import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabe3/constants.dart';
import 'package:tabe3/cubits/ads/ads_cubit.dart';
import 'package:tabe3/cubits/all_sells/all_sells_cubit.dart';
import 'package:tabe3/cubits/products/products_cubit.dart';
import 'package:tabe3/cubits/sell/sell_cubit.dart';
import 'package:tabe3/cubits/sides/sides_cubit.dart';
import 'package:tabe3/view/screens/ads_screen.dart';
import 'package:tabe3/view/screens/all_ads_screen.dart';
import 'package:tabe3/view/screens/best_products_screen.dart';
import 'package:tabe3/view/screens/calculate_percent_screen.dart';
import 'package:tabe3/view/screens/auth/login_screen.dart';
import 'package:tabe3/view/screens/lowest_products_screen.dart';
import 'package:tabe3/view/screens/products/products_screen.dart';
import 'package:tabe3/view/screens/reports/reports_screen.dart';
import 'package:tabe3/view/screens/sides_screen.dart';
import 'package:tabe3/view/widgets/package_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    int adsCost = AdsCubit.get(context).getAllAds();
    AllSellsCubit.get(context).getSells(ads: adsCost);
    ProductsCubit.get(context).getProducts();
    SidesCubit.get(context).getAllSides();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // leading: IconButton(
        //   onPressed: () {
        //     FirebaseAuth.instance.signOut();
        //     Navigator.pushAndRemoveUntil(
        //       context, 
        //       MaterialPageRoute(builder: (_) => LoginScreen()), 
        //       (route) => false,
        //     );
        //   },
        //   icon: Icon(Icons.exit_to_app),
        // ),
        title: Text("Brandify"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => CalculatePercentScreen()));
            },
            icon: Icon(Icons.percent),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        child: ListView(
          children: [
            PackageCard(
              text: "My Prodcuts",
              image: "assets/images/products.jpg",
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => ProductsScreen()));
              },
              bgColor: mainColor,
            ),
            SizedBox(
              height: 10,
            ),
            PackageCard(
              text: "Side expenses",
              image: "assets/images/coins.jpg",
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => SidesScreen()));
              },
              bgColor: mainColor,
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  child: PackageCard(
                    text: "Reports",
                    image: "assets/images/analysis.jpg",
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => ReportsScreen()));
                    },
                    bgColor: mainColor,
                  ),
                ),
                SizedBox(width: 10,),
                Expanded(
                  child: PackageCard(
                    text: "Ads",
                    image: "assets/images/analysis.jpg",
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => AllAdsScreen()));
                    },
                    bgColor: mainColor,
                  ),
                ),
              ],
            ),
            // SizedBox(
            //   height: 10,
            // ),
            // Row(
            //   children: [
            //     Expanded(
            //       child: PackageCard(
            //         text: "Best",
            //         image: "assets/images/b_w.jpg",
            //         onTap: () {
            //           Navigator.push(context,
            //               MaterialPageRoute(builder: (_) => BestProductsScreen()));
            //         },
            //         bgColor: mainColor,
            //       ),
            //     ),
            //     SizedBox(
            //       width: 10,
            //     ),
            //     Expanded(
            //       child: PackageCard(
            //         text: "Lowest",
            //         image: "assets/images/b_w.jpg",
            //         onTap: () {
            //           Navigator.push(context,
            //             MaterialPageRoute(builder: (_) => lowestProductsScreen()));
            //         },
            //         bgColor: mainColor,
            //       ),
            //     ),
            //   ],
            // ),
            // SizedBox(
            //   height: 10,
            // ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              height: 2,
              color: Colors.grey.shade200,
            ),
            //SizedBox(height: 15,),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Text(
                        "Total",
                        style: TextStyle(),
                      ),
                      BlocBuilder<AllSellsCubit, AllSellsState>(
                        builder: (context, state) {
                          return Text(
                            AllSellsCubit.get(context).total.toString(),
                            style: TextStyle(
                              //color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  Container(
                    width: 1,
                    height: 35,
                    color: Colors.grey.shade300,
                  ),
                  Column(
                    children: [
                      Text(
                        "Profit",
                        style: TextStyle(),
                      ),
                      BlocBuilder<AllSellsCubit, AllSellsState>(
                        builder: (context, state) {
                          return Text(
                            AllSellsCubit.get(context).totalProfit.toString(),
                            style: TextStyle(
                              color: AllSellsCubit.get(context).totalProfit >= 0? 
                                Colors.green : Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
