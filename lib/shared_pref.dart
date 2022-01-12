import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper{

  static  SharedPreferences sharedPref;

  static init()async
  {
    sharedPref = await SharedPreferences.getInstance();
  }
  
  
  static Future<bool> putBoolean({
  @required String key,
  @required bool value,
}) async
  {
    return await sharedPref.setBool(key, value);
  }

  static dynamic getData({
  @required String key,
})
  {
    return sharedPref.get(key);
  }

  static Future<bool> saveData ({
  @required String key,
  @required dynamic value,
}) async
  {
    if(value is String) return await sharedPref.setString(key, value);
    if(value is int) return await sharedPref.setInt(key, value);
    if(value is bool) return await sharedPref.setBool(key, value);
    return await sharedPref.setDouble(key, value);
  }


  // clears a single data but Clear is form clearing the whole sharedPref
  static Future<bool> removeData({
    @required String key
}) async
  {
    return await sharedPref.remove(key);
  }
}

