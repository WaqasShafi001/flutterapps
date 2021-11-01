import 'package:flutter/material.dart';
import 'package:flutterapps/Helper/ConstantUtil.dart';
import 'package:flutterapps/Helper/SharedPrefs.dart';
import 'package:flutterapps/Screens/LoginScreen.dart';
import 'package:flutterapps/Screens/TabContainer.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'dart:io' show Platform;
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

void main() async {
  print(SharedPrefs());
  WidgetsFlutterBinding.ensureInitialized();

  ConstantUtil.isLoggedIn = await SharedPrefs().isUserLoggedIn();
  if (Platform.isAndroid) {
    InAppPurchaseAndroidPlatformAddition.enablePendingPurchases();
  }
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      builder: EasyLoading.init(),
      home: ConstantUtil.isLoggedIn == false ? LoginScreen() : TabContainer(),
    );
  }
}
