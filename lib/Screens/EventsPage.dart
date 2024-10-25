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
  var a = false;
  @override
  Widget build(BuildContext context) {
    List jsonData = jsonDecode(Global.localCache);
    var parseData =
        List.generate(jsonData.length, (i) => DayData.fromJson(jsonData[i]));
    a = !a;
    return Scaffold(
        appBar: AppBar(
          title: const Text('活動'),
          bottom: TabBar(
            controller: _tabBarController,
            tabs: [
              for (var i in jsonData)
                Tab(
                  text: DateFormat("EEEE", "zh_TW")
                      .format(DayData.fromJson(i).date),
                )
            ],
          ),
        ),
        body: TabBarView(controller: _tabBarController, children: [
          for (var i in parseData)
            ListView.builder(
                itemCount: i.hrDatas.length,
                itemBuilder: (context, index) {
                  return _eventPerHr(i.hrDatas[index], context, () {
                    setState(() {
                      print('a');
                    });
                  });
                }),
        ]));
  }

  @override
  void initState() {
    _tabBarController = TabController(length: 3, vsync: this);
    initializeDateFormatting(
        "zh_TW", null); //Must init language before format it
    super.initState();
  }
}

Widget _eventPerHr(HrData data, BuildContext context, setstate) {
  List<EventData> listData = [];
  for (var i in data.events) {
    listData.add(i);
  }
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
                var id = data.events[index].url.substring(6, 11);
                return Dismissible(
                  key: Key(data.events[index].name),
                  secondaryBackground: Container(
                    color: Colors.yellow[100],
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Icon(Global.cacheEventStatus[id]!.first
                          ? Icons.star
                          : Icons.star_border),
                    ),
                  ),
                  background: Container(
                    color: Colors.greenAccent[100],
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Icon(Global.cacheEventStatus[id]!.last
                          ? Icons.notifications
                          : Icons.notifications_active_outlined),
                    ),
                  ),
                  confirmDismiss: (v) async {
                    if (v == DismissDirection.endToStart) {
                      //Star
                      Global.setStar(id);
                      setstate();
                    } else if (v == DismissDirection.startToEnd) {
                      //Notify
                      Global.setNotify(id);
                      setstate();
                    }
                    print(Global.cacheEventStatus);
                    setstate();
                    return false;
                  },
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      ListTile(
                        leading: const SizedBox(),
                        minLeadingWidth: 1,
                        onTap: () {
                          Navigator.pushNamed(context, '/eventDetail',
                              arguments: data.events[index]);
                        },
                        title: Text(
                            data.events[index].name.split(RegExp(r"[/／]+"))[0]),
                        subtitle: data.events[index].name
                            .split(RegExp(r"[/／]+"))
                            .length >=
                            2
                            ? Text(data.events[index].name
                            .split(RegExp(r"[/／]+"))
                            .last
                            .trim())
                            : null,
                        //好懶
                        trailing: Text(
                          data.events[index].place
                              .replaceAll(' - ', '-')
                              .split(' ')[1]
                              .replaceAll('VIP', 'VIP Room'),
                        ),
                      ),
                      Positioned(
                        left: 0,
                        top: -4,
                        child: Card(
                          color: Colors.amber[600],
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(bottomRight: Radius.circular(4), bottomLeft: Radius.circular(4))
                          ),
                          child: Column(
                            children: [
                              if(Global.cacheEventStatus[listData[index].id].last||Global.cacheEventStatus[listData[index].id].first)
                                const SizedBox(height: 2),
                              if(Global.cacheEventStatus[listData[index].id].last)
                                const Icon(Icons.star,size: 16,color: Colors.yellow),
                              if(Global.cacheEventStatus[listData[index].id].first)
                                const Icon(Icons.notifications, size: 16, color: Colors.white),
                              if(Global.cacheEventStatus[listData[index].id].last||Global.cacheEventStatus[listData[index].id].first)
                                const SizedBox(height: 2),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                );
              },
              separatorBuilder: (context, index) => const Divider(height: 0),
              itemCount: data.events.length),
        )
      ],
    ),
  );
}
