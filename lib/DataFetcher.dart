import 'dart:convert';

import 'package:html/dom.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart';
import 'package:intl/intl.dart';
import 'dart:developer';

const target = "http://localhost:8000/";
// var target = "https://infurnity2024.sched.com/list/simple/?iframe=no";


void main() async{
  // var target = "http://localhost:8000/a.html";
  var url = Uri.parse("${target}a.html");
  var get = await http.get(url);
  var doc = parse(utf8.decode(get.bodyBytes));
  var extractedData = doc.getElementsByClassName("sched-container-anchor"); //每天的資料 -index
  // extractedData.forEach((i) {
  //   print(i.id);
  //   print(i.nextElementSibling!.text.trim());
  // });
  // print(extractedData.length);
  await fetchDay(doc.getElementsByClassName('list-simple')[0]);
}

Future<void> fetchDay(Element listData) async{
  var days = listData.getElementsByClassName("sched-container-header");
  for(var i in days) {
    var date = i.previousElementSibling!.id;
    var pointer = i;
    while(pointer.className!="sched-container-bottom") {
      if(pointer.localName == "h3") { //Time
        print(pointer.text.trim());
        await _fetchHr(pointer, date);
        print("");
      }
      pointer = pointer.nextElementSibling!;
    }
  }
}

Future<void> _fetchHr(Element hrData, String date) async{
  var time = DateFormat("yyyy-MM-dd h:mma Z").parse("$date ${hrData.text.replaceAll("CST", "+0800").toUpperCase().trim()}");
  // print(time);
  var events = hrData.nextElementSibling!.getElementsByClassName("name");
  // print(events.length);

  for(var i in events) {
    var name = i.nodes[0].text!.trim();
    var place = i.getElementsByClassName("vs")[0].text.trim();
    var path = i.attributes['href']!.trim();
    print("Title: $name $place");
    await _getDetail(path, date);
    // print("mkdir -p ${path.substring(0,12)};curl https://infurnity2024.sched.com/$path > ./$path");
  }

  // var name = hrData.nextElementSibling!.getElementsByClassName("name")[0].nodes[0].text!.trim();
  // var place = hrData.nextElementSibling!.getElementsByClassName("vs")[0].text.trim();
  // var path = hrData.nextElementSibling!.getElementsByClassName("name")[0].attributes['href']!.trim();
  // // print("$name $place");
}

Future<void> _getDetail(String path, String date) async{
  var get = await http.get(Uri.parse("$target/$path"));
  var doc = parse(utf8.decode(get.bodyBytes));
  //呃呃呃呃呃呃 下面這個是大便
  var endTime = DateFormat("yyyy-MM-dd h:mma Z").parse("$date ${doc.getElementsByClassName("list-single__date").first.text.trim().substring(doc.getElementsByClassName("list-single__date").first.text.trim().length - 10).replaceAll("CST", "+0800").toUpperCase()}");
  var describe = "";

  print(endTime);

  //sched-event-type
  var rawEventType = doc.getElementsByClassName('sched-event-type')[0];
  var eventType = [];
  var languages = [];

  for(var i in rawEventType.children) {
    if(i.localName == 'a') {
      eventType.add(i.text.trim());
    }
    if(i.localName == 'ul') {
      for(var j in i.children.first.children) {
        if(j.localName == 'a') {
          languages.add(j.text.trim());
        }
      }
    }
  }

  if(doc.getElementsByClassName("tip-description").isNotEmpty) {
    //很奇怪我認為很毒瘤很不應該的寫法 把東西轉成文字之後replace"<br>"成換行 再轉換成doc
    //但東西出來了應該就沒問題uwu
    var rawDescribe = parse(doc.getElementsByClassName("tip-description")[0].outerHtml.replaceAll('<br>', '\n<br>')).getElementsByClassName("tip-description")[0];
    // print(rawDescribe.text.trim());
    describe = rawDescribe.text.trim();
    //TODO 這邊可以再縮減 去掉if直接丟上去
  }
  // print("$describe\n$eventType\n$languages");

  return;
}

class DayData {

}

class EventData {
  DateTime startTime;
  DateTime endTime;

  String name;
  String place;
  String url;

  String describe;
  List<String> eventType;
  List<String> languages;

  EventData({required this.startTime, required this.endTime, required this.name, required this.place, required this.url, required this.describe, required this.eventType, required this.languages});

  /***
   * Name
   * Place
   * Url
   *
   * Time
   * --StartTime
   * --EndTime
   *
   * Describe --nullable
   *
   * EventType --nullable
   * --Type
   * --Languages
   * ***/
}


//sched-container-anchor -> 日期開始
//H3 -> 時間(CST)
//sched-container-bottom -> 日期結束