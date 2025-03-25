import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:meta/meta.dart';
import 'package:tabe3/constants.dart';
import 'package:tabe3/cubits/all_sells/all_sells_cubit.dart';
import 'package:tabe3/enum.dart';
import 'package:tabe3/models/ad.dart';

part 'ads_state.dart';

class AdsCubit extends Cubit<AdsState> {
  int cost = 0;
  SocialMediaPlatform? selectedPlatform;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  DateTime date = DateTime.now();
  List<Ad> ads = [];

  AdsCubit() : super(AdsInitial());
  static AdsCubit get(BuildContext context) => BlocProvider.of(context);

  void onAdd(BuildContext context) async{
    bool valid = formKey.currentState?.validate() ?? false;
    if(valid){
      formKey.currentState?.save();
      if(selectedPlatform != null){
        Ad newAd = Ad(cost: cost, platform: selectedPlatform, date: date);
        int id = await Hive.box(adsTable).add(newAd.toJson());
        newAd.id = id;
        ads.add(newAd);
        formKey.currentState?.reset();
        emit(AdsChangedState());
        AllSellsCubit.get(context).deductFromProfit(newAd.cost ?? 0);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Added successfuly"), backgroundColor: Colors.green.shade700,)
        );
        Navigator.pop(context);
      }
      else{
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Choose a platform"))
        );
      }
    }
  }

  int getAllAds(){
    if(ads.isNotEmpty) return 0;
    try{
      int totalCost = 0;
      var adsBox = Hive.box(adsTable);
      var keys = adsBox.keys.toList();
      for(var key in keys){
        Ad temp = Ad.fromJson(adsBox.get(key));
        temp.id = key;
        ads.add(temp);
        totalCost += temp.cost ?? 0;
      }
      emit(AdsChangedState());
      return totalCost;
    }
    catch(e){
      print(e);
      return 0;
    }
  }

  void setPlatform(SocialMediaPlatform value){
    selectedPlatform = value;
    emit(AdsChangedState());
  }

  String getDate(){
    return "${date.day}/${date.month}/${date.year}";
  }

  void setDate(DateTime value){
    date = value;
    emit(AdsChangedState());
  }

  Color getAdColor(int index){
    switch(ads[index].platform){
      case SocialMediaPlatform.facebook: return Colors.blue.shade700;
      case SocialMediaPlatform.instagram: return Colors.red.shade700;
      case SocialMediaPlatform.tiktok: return Colors.black;
      default: return mainColor;
    }
  }

  Widget getAdIcon(int index){
    switch(ads[index].platform){
      case SocialMediaPlatform.facebook: return FaIcon(FontAwesomeIcons.facebook, color: Colors.white,);
      case SocialMediaPlatform.instagram: return FaIcon(FontAwesomeIcons.instagram, color: Colors.white,);
      case SocialMediaPlatform.tiktok: return FaIcon(FontAwesomeIcons.tiktok, color: Colors.white,);
      default: return Text(
        "Other",
        style: TextStyle(
          color: Colors.white,
        ),
      );
    }
  }
}
