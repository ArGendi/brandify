import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:tabe3/constants.dart';
import 'package:tabe3/cubits/ads/ads_cubit.dart';
import 'package:tabe3/models/ad.dart';
import 'package:tabe3/view/screens/ads_screen.dart';

class AllAdsScreen extends StatefulWidget {
  const AllAdsScreen({super.key});

  @override
  State<AllAdsScreen> createState() => _AllAdsScreenState();
}

class _AllAdsScreenState extends State<AllAdsScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    AdsCubit.get(context).getAllAds();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("All Ads"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: BlocBuilder<AdsCubit, AdsState>(
          builder: (context, state) {
            return Visibility(
              visible: AdsCubit.get(context).ads.isNotEmpty,
              replacement: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Lottie.asset(
                      "assets/animations/request.json",
                      width: 300,
                    ),
                    //SizedBox(height: 20,),
                    Text("No Ads yet")
                  ],
                ),
              ),
              child: ListView.separated(
                shrinkWrap: true,
                itemBuilder: (context, i) {
                  return GestureDetector(
                    onTap: (){
                      showDetailsAlertDialog(context, AdsCubit.get(context).ads[i]);
                    },
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AdsCubit.get(context).getAdColor(i),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                        child: Row(
                          children: [
                            AdsCubit.get(context).getAdIcon(i),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Text(
                                AdsCubit.get(context).ads[i].platform?.name ??
                                    "null",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Text(
                                "${DateFormat('yyyy-MM-dd').format(AdsCubit.get(context).ads[i].date!)}",
                                style: TextStyle(
                                  color: Colors.white,
                                  //fontSize: 12
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "${AdsCubit.get(context).ads[i].cost} LE",
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, i) => SizedBox(
                  height: 10,
                ),
                itemCount: AdsCubit.get(context).ads.length,
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AdsScreen())
          );
        },
        label: Text("New Ad"),
        icon: Icon(Icons.add),
      ),
    );
  }

  showDetailsAlertDialog(BuildContext context, Ad ad) {
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

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Ad information"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Platform: ${ad.platform?.name}"),
          Text("Cost: ${ad.cost}"),
          Text("Date: ${ad.date.toString().split(" ").first}"),
        ],
      ),
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
