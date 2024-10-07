import 'package:flutter/material.dart';

class Global {
  static var btns = [
    BtnData(Icons.event, "活動", ""),
    BtnData(Icons.qr_code, "我的QR code", ""),
    BtnData(Icons.newspaper_rounded, "公告", ""),
    BtnData(Icons.map_outlined, "會場地圖", ""),
  ];



  static Future init() async{

  }
}

class BtnData{
  final IconData icon;
  final String title;
  final String navPath;
  BtnData(this.icon, this.title, this.navPath);
}