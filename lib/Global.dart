import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fur_pass/DataFetcher.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Global {

  //MARK: - Loading Status
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
          print(localCache);
        } else {
          fetchData();
          return '正在加載資料... *請只點一次這個按鈕因為我不知道一直點cache會變什麼奇怪樣子 可以看上面的小鈴噹 完成會寫';
        }
        //Fetch Data
      }
      return true;
    }),
    BtnData(icon:Icons.qr_code, title:"我的QR code", navPath: "/webView", arg: "https://my.infurnity.com/dashboard/"),
    BtnData(icon:Icons.home/**/, title:"活動主頁", navPath: "/webView", arg: "https://www.infurnity.com/"),
    BtnData(icon:Icons.map_outlined, title:"會場地圖", navPath: "/webView", arg: "https://infurnity2024.sched.com/info?iframe=no"),
  ];

  static String localCache = "";
  static Map<String,dynamic> cacheEventStatus = {};

  static late SharedPreferences sharedPreferences;

  static Future init() async{
    WidgetsFlutterBinding.ensureInitialized();
    sharedPreferences = await SharedPreferences.getInstance();
    //TODO Change This
    if(sharedPreferences.getString("eventStatus") == null) {
      await sharedPreferences.setString("eventStatus", jsonEncode({}));
    } else {
      cacheEventStatus = jsonDecode(sharedPreferences.getString("eventStatus")!);
    }
    if(sharedPreferences.getString("localCache") != null) {
      localCache = sharedPreferences.getString("localCache")!;
      checkEventStatus();
      print(localCache);
    }

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
    checkEventStatus();
  }

  static Future checkEventStatus() async {
    List jsonData = jsonDecode(localCache);
    var parseData = List.generate(jsonData.length, (i) => DayData.fromJson(jsonData[i]));
    for(var i in parseData) {
      for(var j in i.hrDatas) {
        for(var k in j.events) {
          if(!cacheEventStatus.containsKey(k.url.substring(6,11))) {
            cacheEventStatus[k.url.substring(6,11)] = [false, false];
          }
        }
      }
    }
    print(cacheEventStatus);
    await saveEventStatus();
  }

  static Future setNotify(String id) async {
    Global.cacheEventStatus[id]!.first = !Global.cacheEventStatus[id]!.first;
    saveEventStatus();
  }
  static Future setStar(String id) async {
    Global.cacheEventStatus[id]!.last = !Global.cacheEventStatus[id]!.last;
    saveEventStatus();
  }

  static Future saveEventStatus() async{
      await sharedPreferences.setString('eventStatus', jsonEncode(cacheEventStatus));
  }
}

class BtnData{
  final IconData icon;
  final String title;
  final String navPath;
  var arg;

  BtnData({required this.icon, required this.title, required this.navPath, this.arg});
}