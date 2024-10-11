import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fur_pass/DataFetcher.dart';
import 'package:intl/intl.dart';

import '../Global.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  @override
  Widget build(BuildContext context) {
    var jsonData = jsonDecode(Global.localCache);
    var dayOne = DayData.fromJson(jsonData[0]);
    // for(var z in jsonData) {
    //   var d = DayData.fromJson(z);
    //   d.hrDatas.forEach((i) => i.events.forEach((j) => print(j.place)));
    // }


    return Scaffold(
        appBar: _appBar,
        body: ListView.builder(
            itemCount: dayOne.hrDatas.length,
            itemBuilder: (context, index) {
              return _eventPerHr(dayOne.hrDatas[index],context);
            }));
  }
}

Widget _eventPerHr(HrData data, BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
          child: Text(DateFormat("hh:mm a Z").format(data.time),
              style: const TextStyle(fontSize: 18)),
        ),
        Card(
          clipBehavior: Clip.antiAlias,
          child: ListView.separated(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), itemBuilder: (context, index) =>
              ListTile(
                onTap: () {},
                title: Text(data.events[index].name.split(RegExp(r"[/／]+"))[0]),
                subtitle: data.events[index].name.split(RegExp(r"[/／]+")).length >= 2
                    ? Text(data.events[index].name.split(RegExp(r"[/／]+")).last)
                    : null,
                trailing: Text(data.events[index].place.replaceAll(' - ', '-').split(' ')[1]),
              ), separatorBuilder: (context, index) => const Divider(), itemCount: data.events.length),
        ),
      ],
    ),
  );
}

AppBar _appBar = AppBar(
  title: const Text("活動"),
);
