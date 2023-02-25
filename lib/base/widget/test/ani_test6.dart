import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AniTest6 extends StatefulWidget{
  @override
  State createState() => AniTest6State();
}

class AniTest6State extends State<AniTest6>{

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('StatefulWidget Example'),),
      body: Column(
        children: [
          // Lottie.asset('assets/LottieLogo1.json'),

          // Load a Lottie file from a remote url
          Lottie.network('https://raw.githubusercontent.com/xvrh/lottie-flutter/master/example/assets/Mobilo/A.json')
        ],
      ),
    );
  }

  void _onClick(){
    //print('_onClick');
    // setState(() {
    // });
  }
}