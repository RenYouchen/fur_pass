import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fur_pass/Global.dart';
import 'package:fur_pass/Screens/Loading.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    Global.onLoadingValueChange = () {
      setState(() {
      });
    };
    return Scaffold(
      appBar: _appBar(context),
      body: _body(context),
    );
  }

}

AppBar _appBar(context) => AppBar(
      title: const Text("Infurnity 2024"),
      actions: [
        IconButton(
            onPressed: () async {
              /*TODO modife this*/
              showModalBottomSheet(
                context: context,
                builder: (context) => SafeArea(
                  child: ListTile(
                    title: Global.messageLoading.isNotEmpty?Text(Global.messageLoading):null,
                    subtitle: LinearProgressIndicator(
                      value: (Global.currentLoading == -1 || Global.totalLoading == -1) ? null
                          : Global.currentLoading/Global.totalLoading,
                    ),
                  ),
                ),
              );
              // print(Global.sharedPreferences);
            },
            icon: const Icon(Icons.notifications))
      ],
    );

Column _body(context) => Column(
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
              return _btn(Global.btns[index], context);
            }),
      ],
    );

Widget _btn(BtnData data, context) {
  double size = 80;
  return Column(
    children: [
      Expanded(
        child: SizedBox(
          width: size,
          height: size,
          child: ElevatedButton(
              onPressed: () {
                if(data.arg!=null && data.arg() != true) {
                  String rtData = data.arg();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(rtData)));
                } else {
                  try {
                    Navigator.pushNamed(context, data.navPath);
                  } catch (e) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text('\'${data.title}\' 還沒完成><')));
                  }

                }
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
