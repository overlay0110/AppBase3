import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'dart:convert';

import '../../util/util.dart';
import '../../util/utilHTTP.dart';
import '../../util/utilDB.dart';

import '../../util/locali.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class Main extends StatelessWidget {
  DateTime? currentTime;
  Future<bool> _onBack(BuildContext context) async {
    DateTime now = DateTime.now();
    if (currentTime == null || now.difference(currentTime!) > const Duration(seconds: 2)) {
      currentTime = now;
      toast( Strings.of(context).trans('finish_mess') );
      return false;
    }
    exitApp();
    return false;
  }

  @override
  Widget build(BuildContext context) {
    print_r( getConfig('status_bar_color') );
    //dataCall();

    return Scaffold(
        // appBar: AppBar(title: Text('main')),
        body: WillPopScope(
        child: bodyButtoms(),
        onWillPop: () => _onBack(context),
      ),
    );
  }
}

class bodyButtoms extends StatelessWidget{

  void call(BuildContext context) async {
    print_r('call start');

  }

  void call2() async {
    var token_check = await db.select("v", "k='fcm_token' order by id desc limit 1 ");
    var app_ftoken = '';

    if(token_check.asMap().containsKey(0)){
      app_ftoken = aesDecode(token_check[0]['v']);
      print_r("ftoken : ${app_ftoken}");
    }

    Clipboard.setData(ClipboardData(text: app_ftoken ));
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child:SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 20,
                  // color: Colors.amberAccent,
                ),
                // Container(
                //   height: getStatusBarHeight(context),
                //   // color: Colors.amberAccent,
                // ),
                // SizedBox(height: 20.0,),
                ElevatedButton(
                  child: Text( Strings.of(context).trans('trans_test') ),
                  onPressed: () => { call(context) },
                ),
                SizedBox(height: 20.0,),
                ElevatedButton(
                  child: Text( 'Copy FCM Token' ),
                  onPressed: () => { call2() },
                ),
                SizedBox(height: 20.0,),
                ElevatedButton(
                  child: Text( 'Dialog or Alert' ),
                  onPressed: () => { customAlert(context, "test!!!!") },
                ),
                SizedBox(height: 20.0,),
                ElevatedButton(
                  child: Text( 'Toast' ),
                  onPressed: () => { toast("test toast!!!!") },
                ),
                SizedBox(height: 20.0,),
                ElevatedButton(
                  child: Text( '공유 기능' ),
                  onPressed: () => { share("https://www.nvaer.com") },
                ),
                SizedBox(height: 20.0,),
                ElevatedButton(
                  child: Text('QR 스캐너'),
                  onPressed: () {
                    // Navigator.pop(context);
                    Navigator.pushNamed(context, 'qrscan');
                  },
                ),
                SizedBox(height: 20.0,),
                ElevatedButton(
                  child: Text('지문 인식'),
                  onPressed: () async {
                    var res = await callLocalAuth();
                    print_r(res);
                  },
                ),
                SizedBox(height: 20.0,),
                ElevatedButton(
                  child: Text('위치값 불러오기'),
                  onPressed: () async {
                    var res = await getLocation();
                    print_r(res);
                    if(res['code'] == '0'){
                      toast("위도 : ${res['result']['latitude']}, 경도 : ${res['result']['longitude']}");
                    }
                    else{
                      toast("Fail : ${res['code']}");
                    }
                  },
                ),
                SizedBox(height: 20.0,),
                ElevatedButton(
                  child: Text('Google Map'),
                  onPressed: () {
                    // Navigator.pop(context);
                    Navigator.pushNamed(context, 'google_map');
                  },
                ),
                SizedBox(height: 20.0,),
                ElevatedButton(
                  child: Text('NFC id Read'),
                  onPressed: () async {
                    // Navigator.pop(context);
                    var res = await getNfcId(context);
                    print_r(res);
                    toast(res);
                  },
                ),
                SizedBox(height: 20.0,),
                ElevatedButton(
                  child: Text('dart or light check'),
                  onPressed: () async {
                    // Navigator.pop(context);
                    var res = getThemeMode(context);
                    toast(res);
                  },
                ),
                SizedBox(height: 20.0,),
                ElevatedButton(
                  child: Text('Device Size'),
                  onPressed: () async {
                    // Navigator.pop(context);
                    var res = getDeviceSize(context);
                    toast("${res}");
                  },
                ),
                SizedBox(height: 20.0,),
                ElevatedButton(
                  child: Text('webview'),
                  onPressed: () {
                    // Navigator.pop(context);
                    Navigator.pushNamed(context, 'webview');
                  },
                ),
                SizedBox(height: 20.0,),
                ElevatedButton(
                  child: Text('native_call'),
                  onPressed: () {
                    // Navigator.pop(context);
                    Navigator.pushNamed(context, 'native_call');
                  },
                ),
                SizedBox(height: 20.0,),
                ElevatedButton(
                  child: Text('test_animations'),
                  onPressed: () {
                    // Navigator.pop(context);
                    Navigator.pushNamed(context, 'ani_menu');
                  },
                ),
                SizedBox(height: 20.0,),
                ElevatedButton(
                  child: Text('provider'),
                  onPressed: () {
                    // Navigator.pop(context);
                    Navigator.pushNamed(context, 'counter');
                  },
                ),
                SizedBox(height: 20.0,),
                ElevatedButton(
                  child: Text('widget_l'),
                  onPressed: () {
                    // Navigator.pop(context);
                    Navigator.pushNamed(context, 'widget_l');
                  },
                ),
                SizedBox(height: 20.0,),
                ElevatedButton(
                  child: Text('widget_f'),
                  onPressed: () {
                    // Navigator.pop(context);
                    Navigator.pushNamed(context, 'widget_f');
                  },
                ),
                SizedBox(height: 20.0,),
                ElevatedButton(
                  child: Text('test'),
                  onPressed: () {
                    // Navigator.pop(context);
                    Navigator.pushNamed(context, 'test');
                  },
                ),
                SizedBox(height: 20.0,),
                Image.asset('assets/images/test.png'),
                // Image.network('https://www.google.com/images/branding/googlelogo/2x/googlelogo_light_color_92x30dp.png'),
              ],
            ),
          )
        )
    );
  }
}

