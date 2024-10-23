import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fur_pass/DataFetcher.dart';
import 'package:fur_pass/Screens/MainPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Global {

  static ValueNotifier<int> totalLoading = ValueNotifier(-1);
  static ValueNotifier<int> currentLoading = ValueNotifier(-1);
  static ValueNotifier<String> messageLoading = ValueNotifier<String>('');

  static Function? onLoadingValueChange = () {
  };

  static set setTotalLoading(int i) {
    totalLoading.value = i;
    onLoadingValueChange!();
  }
  static set setCurrentLoading(int i) {
    currentLoading.value = i;
    onLoadingValueChange!();
  }
  static set setMessageLoading(String i) {
    messageLoading.value = i;
    onLoadingValueChange!();
  }


  static var btns = [
    BtnData(icon:Icons.event, title:"活動", navPath: "/events", arg: () {
      if(localCache.isEmpty) {
        if(sharedPreferences.getString("localCache") != null) {
          localCache = sharedPreferences.getString("localCache")!;
        } else {
          fetchData();
          return '正在加載資料... *請只點一次這個按鈕因為我不知道一直點cache會變什麼奇怪樣子 可以看上面的小鈴噹 完成會寫';
        }
        //Fetch Data
      }
      return true;
    }),
    BtnData(icon:Icons.qr_code, title:"我的QR code", navPath: "/webView"),
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
    setCurrentLoading = -1;
    setTotalLoading = -1;
    setMessageLoading = "正在抓取資料";
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