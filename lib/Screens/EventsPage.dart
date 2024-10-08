import 'dart:convert';

import 'package:flutter/material.dart';

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

    return Scaffold(
      appBar: _appBar,
      body: Column(
        children: List.generate(jsonData[0]['hrDatas'].length, (i) =>
          ListTile(
            title: Text(jsonData[0]['hrDatas'][i]['events'][0]['name']),
            onTap: (){},
          )
        ),
      ),
    );
  }
}

AppBar _appBar = AppBar(
  title: const Text("活動"),
);