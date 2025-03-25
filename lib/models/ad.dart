import 'package:intl/intl.dart';
import 'package:tabe3/enum.dart';

class Ad{
  int? id;
  int? cost;
  SocialMediaPlatform? platform;
  DateTime? date;

  Ad({this.id, this.cost, this.date, this.platform});
  Ad.fromJson(Map<dynamic, dynamic> json){
    cost = json["cost"];
    platform = toPlatform(json["platform"]);
    date = DateTime.parse(json["date"]);
  }

  Map<String, dynamic> toJson(){
    return {
      "cost": cost,
      "platform": platform?.name ?? "other",
      "date": DateFormat('yyyy-MM-dd HH:mm:ss').format(date!),
    };
  }

  SocialMediaPlatform toPlatform(String value){
    switch(value){
      case "facebook": return SocialMediaPlatform.facebook;
      case "instagram": return SocialMediaPlatform.instagram;
      case "tiktok": return SocialMediaPlatform.tiktok;
      default: return SocialMediaPlatform.other;
    }
  }
}