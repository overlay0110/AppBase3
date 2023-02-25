import 'package:flutter/material.dart';

import 'dart:async';
import 'package:flutter/services.dart';

import '../../util/util.dart';

class NativeCall extends StatefulWidget{
  @override
  State createState() => NativeCallState();
}

class NativeCallState extends State<NativeCall>{

  static const nativecall = MethodChannel('appbase3.nativecall');
  String _batteryLevel = 'Unknown battery level.';

  @override
  void initState() {
    super.initState();
  }

  Future<void> _getBatteryLevel() async {
    print_r('_getBatteryLevel start');
    String batteryLevel;
    try {
      final int result = await nativecall.invokeMethod('getBatteryLevel');
      batteryLevel = 'Battery level at $result % .';
    } on PlatformException catch (e) {
      batteryLevel = "Failed to get battery level: '${e.message}'.";
    }

    print_r(batteryLevel);

    setState(() {
      _batteryLevel = batteryLevel;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('NativeCall Example'),),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: _getBatteryLevel,
            child: const Text('Get Battery Level'),
          ),
          Text(_batteryLevel),
        ],
      ),
    );
  }
}