import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fur_pass/DataFetcher.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Global {
  static var btns = [
    BtnData(Icons.event, "活動", "/events"),
    BtnData(Icons.qr_code, "我的QR code", ""),
    BtnData(Icons.newspaper_rounded, "公告", ""),
    BtnData(Icons.map_outlined, "會場地圖", ""),
  ];

  static String localCache = "";

  static late SharedPreferences sharedPreferences;

  static Future init() async{
    WidgetsFlutterBinding.ensureInitialized();
    sharedPreferences = await SharedPreferences.getInstance();

    if(sharedPreferences.getString("localCache") == null) {
      await fetchData();
    } else {
      localCache = sharedPreferences.getString("localCache")!;
    }
    print(localCache);
    print('done init');
  }

  static Future fetchData() async {
    print("fetching data");
    var data = await getJsonData();
    localCache = data;
    sharedPreferences.setString("localCache", data);
  }
}

class BtnData{
  final IconData icon;
  final String title;
  final String navPath;
  BtnData(this.icon, this.title, this.navPath);
}