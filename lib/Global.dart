import 'package:flutter/material.dart';
import 'package:fur_pass/DataFetcher.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Global {
  static var btns = [
    BtnData(Icons.event, "活動", ""),
    BtnData(Icons.qr_code, "我的QR code", ""),
    BtnData(Icons.newspaper_rounded, "公告", ""),
    BtnData(Icons.map_outlined, "會場地圖", ""),
  ];

  static const String localCache = "localCache";

  static late SharedPreferences sharedPreferences;

  static Future init() async{
    WidgetsFlutterBinding.ensureInitialized();
    sharedPreferences = await SharedPreferences.getInstance();

    if(sharedPreferences.getString(localCache) == null) {
      fetchData();
    }
  }

  static Future fetchData() async {
    sharedPreferences.setString(localCache, await getJsonData());
  }
}

class BtnData{
  final IconData icon;
  final String title;
  final String navPath;
  BtnData(this.icon, this.title, this.navPath);
}