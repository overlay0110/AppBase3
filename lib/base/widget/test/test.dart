import 'package:flutter/material.dart';
import '../../util/util.dart';

import 'dart:async';

import 'package:flutter/services.dart';


class Test extends StatefulWidget{
  @override
  State createState() => TestState();
}

class TestState extends State<Test>{
  int cnt = 0;
  late String showText;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Test Example'),),
      body: Center(
        child: Column( mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '글시체 : 평창평화체',
              style: TextStyle(fontFamily: 'PyeongChangPeace', fontWeight: FontWeight.w700),
            )
          ],
        ),
      ),
    );
  }

  void _onClick(){
    //print('_onClick');
    setState(() {
      cnt++;
      if(showText == 'off'){
        showText = 'on';
      }
      else{
        showText = 'off';
      }
    });
  }
}