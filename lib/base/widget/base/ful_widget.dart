import 'package:flutter/material.dart';

class FulWidget extends StatefulWidget{
  @override
  State createState() => FulWidgetState();
}

class FulWidgetState extends State<FulWidget>{
  int cnt = 0;
  late String showText;

  @override
  void initState() {
    super.initState();
    showText = 'off';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('StatefulWidget Example'),),
      body: Column(
        children: [
          Text('test1'),
          Text(showText),
          ElevatedButton(
            child: Text('button $cnt'),
            onPressed: _onClick,
          ),
        ],
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