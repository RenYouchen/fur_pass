import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fur_pass/DataFetcher.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import '../Global.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabBarController;

  @override
  Widget build(BuildContext context) {
    List jsonData = jsonDecode(Global.localCache);
    var parseData = List.generate(jsonData.length, (i) => DayData.fromJson(jsonData[i]));
    return Scaffold(
        appBar: AppBar(
          title: const Text("活動"),
          bottom: TabBar(
            controller: _tabBarController,
            tabs: [
              for (var i in jsonData)
                Tab(
                  text: DateFormat("EEEE", "zh_TW").format(DayData.fromJson(i).date),
                )
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabBarController,
            children: [
              for(var i in parseData)
          ListView.builder(
              itemCount: i.hrDatas.length,
              itemBuilder: (context, index) {
                return _eventPerHr(i.hrDatas[index], context);
              }),
        ]));
  }

  @override
  void initState() {
    _tabBarController = TabController(length: 3, vsync: this);
    initializeDateFormatting("zh_TW", null);  //Must init language before format it
    super.initState();
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
          child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {
                    Navigator.pushNamed(context, '/eventDetail', arguments: data.events[index]);
                  }, //TODO eventdetail
                  title:
                      Text(data.events[index].name.split(RegExp(r"[/／]+"))[0]),
                  subtitle: data.events[index].name
                              .split(RegExp(r"[/／]+"))
                              .length >=
                          2
                      ? Text(
                          data.events[index].name.split(RegExp(r"[/／]+")).last)
                      : null,
                  //好懶
                  trailing: Text(data.events[index].place
                      .replaceAll(' - ', '-')
                      .split(' ')[1]
                      .replaceAll('VIP', 'VIP Room')),
                );
              },
              separatorBuilder: (context, index) => const Divider(height: 0),
              itemCount: data.events.length),
        ),
      ],
    ),
  );
}
