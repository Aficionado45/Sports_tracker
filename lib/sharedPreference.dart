import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions{
  //defining key to store
  static String sharedPreferenceUserLoggedInKey = "ISLOGGEDIN";
  static String sharedPreferenceAdminAuthKey = "AuthValid";
  static String sharedPreferenceUserUIDKey = "USERUIDKEY";


  // saving data

  static Future<bool> saveUserLoggedInSharedPreference(
      bool isUserLoggedIn) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setBool(sharedPreferenceUserLoggedInKey, isUserLoggedIn);
  }
  static Future<bool> saveUserUIDSharedPreference(
      String userUid) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(sharedPreferenceUserUIDKey, userUid);
  }
  static Future<bool> saveAdminAuthSharedPreference(
      bool keyValid) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setBool(sharedPreferenceAdminAuthKey, keyValid);
  }
  //getting data
  static Future<bool> getUserLoggedInSharedPreference() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(sharedPreferenceUserLoggedInKey);
  }
  static Future<bool> getAdminAuthSharedPreference() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return  prefs.getBool(sharedPreferenceAdminAuthKey);
  }
  static Future<String> getUserUIDSharedPreference() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return  prefs.getString(sharedPreferenceUserUIDKey);
  }


}