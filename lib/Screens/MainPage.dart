import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fur_pass/Global.dart';
import 'package:intl/intl.dart';

import '../DataFetcher.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    // Global.onLoadingValueChange = () {
    //   setState(() {
    //   });
    // };
    return Scaffold(
      appBar: _appBar(context),
      body: _body(context, () => setState(() => {})),
    );
  }
}

AppBar _appBar(context) => AppBar(
      title: const Text("Infurnity 2024"),
      actions: [
        IconButton(
            onPressed: () => Global.fetchData(), //TODO add dialog
            // onPressed: () => Global.checkEventStatus(),
            icon: const Icon(Icons.refresh)),
        IconButton(
            onPressed: () async {
              showModalBottomSheet(
                context: context,
                builder: (context) => ValueListenableBuilder(
                  valueListenable: Global.messageLoading,
                  builder: (BuildContext context, String value, Widget? child) {
                    return SafeArea(
                      child: ListTile(
                          title: value.isNotEmpty ? Text(value) : null,
                          subtitle: ValueListenableBuilder(
                            valueListenable: Global.totalLoading,
                            builder: (_, valueT, __) {
                              return ValueListenableBuilder(
                                  valueListenable: Global.currentLoading,
                                  builder: (_, valueC, __) {
                                    print(
                                        '$valueC $valueT : ${valueC / valueT}');
                                    return LinearProgressIndicator(
                                      value: valueC / valueT,
                                    );
                                  });
                            },
                          )),
                    );
                  },
                ),
              );
              // print(Global.sharedPreferences);
            },
            icon: const Icon(Icons.notifications))
      ],
    );

Column _body(context, setstate) {
  List<EventData> listData = [];
  var time = DateTime(2024, 10, 25, 23);
  if (Global.localCache.isNotEmpty) {
    List jsonData = jsonDecode(Global.localCache);
    var parseData =
        List.generate(jsonData.length, (i) => DayData.fromJson(jsonData[i]));
    for (var i in parseData) {
      for (var j in i.hrDatas) {
        for (var k in j.events) {
          if (Global.cacheEventStatus[k.id].first ||
              Global.cacheEventStatus[k.id].last) {
            listData.add(k);
          }
        }
      }
    }
    
  }
  return Column(
    children: [
      SizedBox(
        height: MediaQuery.of(context).size.height * 0.2,
        child: const Padding(
          padding: EdgeInsets.fromLTRB(64, 32, 64, 64),
          child: Placeholder(),
          // child: SvgPicture.asset("assets/infurnity-seven-logo-dark.svg"),
        ),
      ),
      GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4),
          itemCount: Global.btns.length,
          itemBuilder: (context, index) {
            return _btn(Global.btns[index], context, setstate);
          }),
      if (listData.isNotEmpty)
        Expanded(
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: listData.length,
              itemBuilder: (context, index) {
                
                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Card(
                        clipBehavior: Clip.antiAlias,
                        color: time.isBefore(listData[index].endTime)?Colors.orange[100] : Colors.grey[300],
                        child: ListTile(
                          onTap: () {
                            Navigator.pushNamed(context, '/eventDetail',
                                arguments: listData[index]);
                          },
                          title: Text(
                              listData[index].name.split(RegExp(r"[/／]+"))[0]),
                          subtitle: listData[index]
                                      .name
                                      .split(RegExp(r"[/／]+"))
                                      .length >=
                                  2
                              ? Text(listData[index]
                                  .name
                                  .split(RegExp(r"[/／]+"))
                                  .last
                                  .trim())
                              : null,
                          //好懶
                          trailing: Text(
                            listData[index]
                                .place
                                .replaceAll(' - ', '-')
                                .split(' ')[1]
                                .replaceAll('VIP', 'VIP Room'),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 16,
                        top: -8,
                        child: Card(
                          color: time.isBefore(listData[index].endTime)?Colors.amber[800]: Colors.grey[400],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(2)
                          ),
                          child: Row(
                            children: [
                              if(Global.cacheEventStatus[listData[index].id].last)
                              const Icon(Icons.star,size: 16,color: Colors.yellow),
                              if(Global.cacheEventStatus[listData[index].id].first)
                              const Icon(Icons.notifications, size: 16, color: Colors.white),
                              if(time.isAfter(listData[index].endTime))
                                Text(" 結束時間: ${DateFormat("MM/dd hh:mm").format(listData[index].endTime)}")
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                );
              }),
        ),
      if (listData.isEmpty) 
        Expanded(child: Center(child: Text('到活動列表中左右滑動活動來添加吧!', style: Theme.of(context).textTheme.bodyLarge)))
    ],
  );
}

Widget _btn(BtnData data, context, setstate) {
  double size = 80;
  return Column(
    children: [
      Expanded(
        child: SizedBox(
          width: size,
          height: size,
          child: ElevatedButton(
              onPressed: () async {
                if (data.arg != null && data.arg.runtimeType == String) {
                  Navigator.pushNamed(context, data.navPath,
                      arguments: data.arg);
                } else if (data.arg != null && data.arg() != true) {
                  String rtData = data.arg();
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(rtData)));
                } else {
                  try {
                    print(Global.localCache);
                    await Navigator.pushNamed(context, data.navPath);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('\'${data.title}\' 還沒完成><')));
                  }
                }
                setstate();
              },
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25))),
              child: Icon(data.icon, size: 32)),
        ),
      ),
      const SizedBox(height: 12),
      Text(data.title)
    ],
  );
}
