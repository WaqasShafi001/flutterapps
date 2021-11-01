import 'dart:convert';
import 'package:flutterapps/Helper/ConstantUtil.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  //Set/Get UserLoggedIn Status
  void setUserLoggedIn(bool loggedIn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', loggedIn);
    ConstantUtil.isLoggedIn = loggedIn;
  }

  Future<bool> isUserLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  //Set/Get UserLoggedIn Status
  void setAuthorizationKey(String authKey) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print('setAuthorizationKey');
    print('kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk $authKey');
    prefs.setString('authKey', authKey);
    prefs.setBool('isLoggedIn', true);
    ConstantUtil.isLoggedIn = true;
  }

  Future<String> getAuthorizationKey() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.get('authKey') as String;
  }

  void clearPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}
