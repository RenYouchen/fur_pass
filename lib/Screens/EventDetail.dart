import 'package:flutter/material.dart';
import 'package:fur_pass/DataFetcher.dart';
import 'package:intl/intl.dart';

class EventDetail extends StatefulWidget {
  const EventDetail({super.key});

  @override
  State<EventDetail> createState() => _EventDetailState();
}

class _EventDetailState extends State<EventDetail> {
  @override
  Widget build(BuildContext context) {
    var data = ModalRoute.of(context)!.settings.arguments as EventData;
    print(data);
    return Scaffold(
      appBar: AppBar(
        leading: Card(
          clipBehavior: Clip.antiAlias,
          shadowColor: Colors.transparent,
          color: Colors.transparent,
          child: InkWell(
            onTap: () => Navigator.pop(context),
            child: const Row(
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.arrow_back_ios_new),
                ),
                Text("返回")
              ],
            ),
          ),
        ),
        leadingWidth: 96,
        actions: [
          IconButton(onPressed: (){}, icon: const Icon(Icons.star_border))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(padding: const EdgeInsets.all(8.0), child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(data.name.split(RegExp(r"[/／]+"))[0],
                        style: const TextStyle(fontSize: 28)),
                    if (data.name.split(RegExp(r"[/／]+")).length >= 2)
                      Text(data.name.split(RegExp(r"[/／]+")).last.trim(), style: TextStyle(fontSize: 22, color: Colors.grey[700])),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              if(data.eventType.isNotEmpty)
                TileDescribe(data: data.eventType, icon: Icons.flag, describe: '類型'),
              TimeDescribe(startTime: data.startTime, endTime: data.endTime),
              TileDescribe(data: data.place, icon: Icons.pin_drop, describe: '地點'),
              if(data.languages.isNotEmpty)
                TileDescribe(data: data.languages, icon: Icons.language, describe: '語言'),
              if(data.describe.isNotEmpty)
                EventDescribe(describe: data.describe)
            ],
          ),
        ),
      ),
    );
  }
}

class TileDescribe extends StatelessWidget {
  final data;
  final IconData icon;
  final String describe;
  const TileDescribe({super.key, required this.data, required this.icon, required this.describe});

  @override
  Widget build(BuildContext context) {
    return Card(
        clipBehavior: Clip.antiAlias,
        child: ListTile(
          dense: true,
          leading: Icon(icon),
          title: Text(describe, style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.grey[700])),
          subtitle: Text(data.runtimeType == List ? data.join(', ') : data, style: Theme.of(context).textTheme.titleMedium),
        )
    );
  }
}

class TimeDescribe extends StatelessWidget {
  final DateTime startTime;
  final DateTime endTime;
  final DateFormat timeFormatter = DateFormat('hh:mm');
  TimeDescribe({super.key, required this.startTime, required this.endTime});

  @override
  Widget build(BuildContext context) {
    return Card(
        clipBehavior: Clip.antiAlias,
        child: ListTile(
          dense: true,
          leading: const Icon(Icons.access_time),
          title: Text(DateFormat('yyyy/M/d').format(startTime), style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.grey[700])),
          subtitle: Text('${timeFormatter.format(startTime)} ~ ${timeFormatter.format(endTime)} · ${endTime.difference(startTime).inMinutes} 分鐘', style: Theme.of(context).textTheme.titleMedium),
        )
    );
  }
}


class EventDescribe extends StatelessWidget {
  final String describe;
  const EventDescribe({super.key, required this.describe});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("介紹", style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey[700])),
        ),
        Card(
          color: Colors.amber[100],
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: ListTile(
              title:Text(describe, style: Theme.of(context).textTheme.bodyLarge),
            ),
          ),
        ),
      ],
    );
  }
}
