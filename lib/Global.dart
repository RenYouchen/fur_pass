import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fur_pass/DataFetcher.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Global {
  static var btns = [
    BtnData(icon:Icons.event, title:"活動", navPath: "/events", arg: () {
      if(localCache.isEmpty) {
        //Fetch Data
        return '正在加載資料...';
      }
      return true;
    }),
    BtnData(icon:Icons.qr_code, title:"我的QR code", navPath: ""),
    BtnData(icon:Icons.newspaper_rounded, title:"公告", navPath: ""),
    BtnData(icon:Icons.map_outlined, title:"會場地圖", navPath: ""),
  ];

  static String localCache = "";

  static late SharedPreferences sharedPreferences;

  static Future init() async{
    WidgetsFlutterBinding.ensureInitialized();
    sharedPreferences = await SharedPreferences.getInstance();
    //TODO Change This
    // if(sharedPreferences.getString("localCache") == null) {
    //   await fetchData();
    // } else {
    //   localCache = sharedPreferences.getString("localCache")!;
    // }
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
  var arg;

  BtnData({required this.icon, required this.title, required this.navPath, this.arg});
}