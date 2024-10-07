import 'dart:convert';

import 'package:html/dom.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart';
import 'package:intl/intl.dart';

const target = "http://localhost:8000/a.html";
// var target = "https://infurnity2024.sched.com/list/simple/?iframe=no";


void main() async{
  // var target = "http://localhost:8000/a.html";
  var url = Uri.parse(target);
  var get = await http.get(url);
  var doc = parse(utf8.decode(get.bodyBytes));
  var extractedData = doc.getElementsByClassName("sched-container-anchor"); //每天的資料 -index
  // extractedData.forEach((i) {
  //   print(i.id);
  //   print(i.nextElementSibling!.text.trim());
  // });
  // print(extractedData.length);
  fetchDay(doc.getElementsByClassName('list-simple')[0]);
}

void fetchDay(Element listData) {
  var days = listData.getElementsByClassName("sched-container-header");
  for(var i in days) {
    var date = i.previousElementSibling!.id;
    var pointer = i;
    while(pointer.className!="sched-container-bottom") {
      if(pointer.localName == "h3") { //Time
        // print(pointer.text);
        _fetchHr(pointer, date);
      }
      pointer = pointer.nextElementSibling!;
    }
  }
}

void _fetchHr(Element hrData, String date) {
  var time = DateFormat("yyyy-MM-dd h:mma Z").parse("$date ${hrData.text.replaceAll("CST", "+0800").toUpperCase().trim()}");
  // print(time);
  var events = hrData.nextElementSibling!.getElementsByClassName("name");
  // print(events.length);

  for(var i in events) {
    var name = i.nodes[0].text!.trim();
    var place = i.getElementsByClassName("vs")[0].text.trim();
    var path = i.attributes['href']!.trim();
    print("$name $place $path");
    // print("mkdir -p ${path.substring(0,12)};curl https://infurnity2024.sched.com/$path > ./$path");

  }

  // var name = hrData.nextElementSibling!.getElementsByClassName("name")[0].nodes[0].text!.trim();
  // var place = hrData.nextElementSibling!.getElementsByClassName("vs")[0].text.trim();
  // var path = hrData.nextElementSibling!.getElementsByClassName("name")[0].attributes['href']!.trim();
  // // print("$name $place");
}

void _getDetail(String path) async{
  var get = await http.get(Uri.parse("$target/$path"));
  var doc = parse(utf8.decode(get.bodyBytes));

}

class DayData {

}

class EventData {
  DateTime time;

  String name;
  String place;
  String url;

  EventData({required this.time, required this.name, required this.place, required this.url});

  /***
   * Name
   * Place
   * Url
   *
   * Time
   * --StartTime
   * --EndTime
   * Type
   * Describe
   * ***/
}


//sched-container-anchor -> 日期開始
//H3 -> 時間(CST)
//sched-container-bottom -> 日期結束