import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fur_pass/Global.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _body(context),
    );
  }
}

AppBar _appBar() => 
    AppBar(
      title: const Text("Infurnity 2024"),
      actions: [
        IconButton(onPressed: (){/*TODO add setting*/}, icon: const Icon(Icons.settings))
      ],
    );



Column _body(context) =>
    Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height*0.2,
          child: const Padding(
            padding: EdgeInsets.fromLTRB(
              64,32,64,64
            ),
            child: Placeholder(),
            // child: SvgPicture.asset("assets/infurnity-seven-logo-dark.svg"),
          ),
        ),
        Expanded(
          child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
              itemCount: Global.btns.length,
              itemBuilder: (context, index) {
                return _btn(Global.btns[index], context);
              }
          ),
        )
      ],
    );

Widget _btn(BtnData data,context) {
  double size = 80;
  return Column(
    children: [
      SizedBox(
        width: size,
        height: size,
        child: ElevatedButton(
            onPressed: (){
              Navigator.pushNamed(context, data.navPath);
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25)
              )
            ),
            child: Icon(data.icon, size: 32)
        ),
      ),
      const SizedBox(height: 12),
      Expanded(child: Text(data.title))
    ],
  );
}
