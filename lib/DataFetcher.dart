import 'dart:convert';

import 'package:html/dom.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart';
import 'package:intl/intl.dart';

const target = "http://localhost:8000/";
// var target = "https://infurnity2024.sched.com/list/simple/?iframe=no";

void main() async{
  var data = await getData();
  var json = jsonEncode(data);
  List jsonData = jsonDecode(json);
  var a = DayData.fromJson(jsonData[0]);
}

Future<String> getJsonData() async {
  return jsonEncode(await getData());
}

Future<List<DayData>> getData() async{
  var url = Uri.parse("${target}a.html");
  var get = await http.get(url);
  var doc = parse(utf8.decode(get.bodyBytes));
  return await _fetchDays(doc.getElementsByClassName('list-simple')[0]);
}

Future<List<DayData>> _fetchDays(Element listData) async{
  var days = listData.getElementsByClassName("sched-container-header");
  List<DayData> data = [];
  for(var i in days) {
    var date = i.previousElementSibling!.id;
    var pointer = i;
    List<HrData> dayHrData = [];
    while(pointer.className!="sched-container-bottom") {
      if(pointer.localName == "h3") { //Time
        var a = await _fetchHr(pointer, date);
        dayHrData.add(a);
      }
      pointer = pointer.nextElementSibling!;
    }
    data.add(DayData(date: dayHrData.first.time, hrDatas: dayHrData));
  }
  return data;
}

Future<HrData> _fetchHr(Element hrData, String date) async{
  var time = DateFormat("yyyy-MM-dd h:mma Z").parse("$date ${hrData.text.replaceAll("CST", "+0800").toUpperCase().trim()}");
  var events = hrData.nextElementSibling!.getElementsByClassName("name");
  List<EventData> data = [];
  for(var i in events) {
    var name = i.nodes[0].text!.trim();
    var place = i.getElementsByClassName("vs")[0].text.trim();
    var path = i.attributes['href']!.trim();
    // print("Title: $name $place");
    var _data = await _getDetail(path, date);
    
    var eventData = EventData(startTime: time, endTime: _data[0], name: name, place: place, url: path, describe: _data[1], eventType: _data[2], languages: _data[3]);
    data.add(eventData);
    // print("mkdir -p ${path.substring(0,12)};curl https://infurnity2024.sched.com/$path > ./$path");
  }
  return HrData(time: time, events: data);
  // var name = hrData.nextElementSibling!.getElementsByClassName("name")[0].nodes[0].text!.trim();
  // var place = hrData.nextElementSibling!.getElementsByClassName("vs")[0].text.trim();
  // var path = hrData.nextElementSibling!.getElementsByClassName("name")[0].attributes['href']!.trim();
  // // print("$name $place");
}

Future<List> _getDetail(String path, String date) async{
  var get = await http.get(Uri.parse("$target/$path"));
  var doc = parse(utf8.decode(get.bodyBytes));
  //呃呃呃呃呃呃 下面這個是大便
  var endTime = DateFormat("yyyy-MM-dd h:mma Z").parse("$date ${doc.getElementsByClassName("list-single__date").first.text.trim().substring(doc.getElementsByClassName("list-single__date").first.text.trim().length - 10).replaceAll("CST", "+0800").toUpperCase()}");
  var describe = "";

  // print(endTime);

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

  return [endTime, describe, eventType, languages];
}

class DayData {
  DateTime date;
  List<HrData> hrDatas;
  DayData({required this.date, required this.hrDatas});
  DayData.fromJson(Map<String, dynamic> json) :
    date = DateTime.parse(json['date']),
    hrDatas = List.generate(json['hrDatas'].length, (i) => 
      HrData.fromJson(json['hrDatas'][i])
  );

  @override
  String toString() {
    return 'DayData{date: $date, hrDatas: $hrDatas}';
  }
  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'hrDatas': hrDatas.map((hr) => hr.toJson()).toList(),
    };
  }


}

class HrData {
  DateTime time;
  List<EventData> events;
  HrData({required this.time, required this.events});
  HrData.fromJson(Map<String, dynamic> json) :
      time = DateTime.parse(json['time']),
      events = List.generate(json['events'].length, (i) =>
        EventData.fromJson(json['events'][i])
      );

  @override
  String toString() {
    return 'HrData{time: $time, events: $events}';
  }

  Map<String, dynamic> toJson() {
    return {
      'time': time.toIso8601String(),
      'events': events.map((event) => event.toJson()).toList(),
    };
  }
}

class EventData {
  DateTime startTime;
  DateTime endTime;

  String name;
  String place;
  String url;

  String describe;
  List<dynamic> eventType;
  List<dynamic> languages;

  EventData({required this.startTime, required this.endTime, required this.name, required this.place, required this.url, required this.describe, required this.eventType, required this.languages});

  @override
  String toString() {
    return 'EventData{\nstartTime: $startTime, endTime: $endTime, name: $name\nplace: $place, describe: $describe\neventType: $eventType\nlanguages: $languages\n}';
  }

  EventData.fromJson(Map<String, dynamic> json)
      : startTime = DateTime.parse(json['startTime']),
        endTime = DateTime.parse(json['endTime']),
        name = json['name'],
        place = json['place'],
        url = json['url'],
        describe = json['describe'],
        eventType = List<dynamic>.from(json['eventType']),
        languages = List<dynamic>.from(json['languages']);

  Map<String, dynamic> toJson() {
    return {
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'name': name,
      'place': place,
      'url': url,
      'describe': describe,
      'eventType': eventType,
      'languages': languages,
    };
  }

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