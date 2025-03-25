import 'package:shared_preferences/shared_preferences.dart';

class Cache{
  static late SharedPreferences sharedPreferences;

  static Future<void> init() async{
    sharedPreferences = await SharedPreferences.getInstance();
  }

  static Future<void> setUserId(int value) async{
    await sharedPreferences.setInt("userId", value);
  }

  static int? getUserId(){
    return sharedPreferences.getInt("userId");
  }

  static Future<void> setTotal(int value) async{
    await sharedPreferences.setInt("total", value);
  }

  static int? getTotal(){
    return sharedPreferences.getInt("total");
  }

  static Future<void> setProfit(int value) async{
    await sharedPreferences.setInt("profit", value);
  }

  static int? getProfit(){
    return sharedPreferences.getInt("profit");
  }

  static Future<void> setMoney(double value) async{
    await sharedPreferences.setDouble("money", value);
  }

  static double? getMoney(){
    return sharedPreferences.getDouble("money");
  }

  static Future<void> setName(String value) async{
    await sharedPreferences.setString("name", value);
  }

  static String? getName(){
    return sharedPreferences.getString("name");
  }

  static Future<void> setPhone(String value) async{
    await sharedPreferences.setString("phone", value);
  }

  static String? getPhone(){
    return sharedPreferences.getString("phone");
  }

  static void clear(){
    sharedPreferences.clear();
  }

}