import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fur_pass/DataFetcher.dart';
import 'package:fur_pass/Screens/MainPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Global {

  static int totalLoading = -1;
  static int currentLoading = -1;
  static String messageLoading = '';


  static Function? onLoadingValueChange = () {
  };

  set setTotalLoading(int i) {
    totalLoading = i;
    onLoadingValueChange!();
  }
  set setCurrentLoading(int i) {
    currentLoading = i;
    onLoadingValueChange!();
  }
  static set setMessageLoading(String i) {
    messageLoading = i;
    onLoadingValueChange!();
  }


  static var btns = [
    BtnData(icon:Icons.event, title:"活動", navPath: "/events", arg: () {
      if(localCache.isEmpty) {
        //Fetch Data
        fetchData();
        return '正在加載資料... *請只點一次這個按鈕因為我不知道一直點cache會變什麼奇怪樣子 可以看上面的小鈴噹 完成會寫';
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
    setMessageLoading = "完成";
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