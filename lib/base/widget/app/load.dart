import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

import 'dart:convert';
import 'package:flutter/foundation.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';

// import 'package:appbase3/base/util/util.dart';

import '../../util/util.dart';
import '../../util/utilDB.dart';
import '../../util/utilHTTP.dart';

import '../../util/locali.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Load extends StatefulWidget{
  @override
  State createState() => LoadState();
}

class LoadState extends State<Load>{
  bool showLoading = true;

  @override
  void initState() {
    super.initState();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    setForegroundMessaging();
    start();
  }

  void start() {
    print_r('load start');
    Future.delayed(Duration.zero,() async {

      if(getConfig("net_check")){
        var n_check = await netCheck();
        if(n_check == 'none'){
          actionAlert(context, Strings.of(context).trans('internet_error'), () { exitApp(); } );
          return;
        }
      }

      if(getConfig("root_check")){
        var root_check = await rootJailCheck();
        if(root_check){
          actionAlert(context, Strings.of(context).trans('root_mess'), () { exitApp(); } );
          return;
        }
      }

      if(getConfig("config_call")){
        var res_config = await callAPI( getConfig("config_url"), null );
        print_r(res_config);
        db.insert({'k':'config_call_data', 'v': aesEncode( jsonEncode(res_config) ) });

        if(getConfig("app_store_version_check")){
          var check_version = await getDeviceVersion();
          if (defaultTargetPlatform == TargetPlatform.android){
            if(check_version != res_config['ANDROID_APP_VERSION']){
              actionAlert(context, Strings.of(context).trans('version_msg'), () { urlOpen(res_config['UPDATE_LINK_ANDROID']); exitApp(); } );
              return;
            }
          }
          else if (defaultTargetPlatform == TargetPlatform.iOS){
            if(check_version != res_config['IOS_APP_VERSION']){
              actionAlert(context, Strings.of(context).trans('version_msg'), () { urlOpen(res_config['UPDATE_LINK_IOS']); } );
              return;
            }
          }
        }
      }

      if(isMobile()){
        var code_check = await db.select("v", "k='app_code' order by id desc limit 1 ");
        if(!code_check.asMap().containsKey(0)){
          db.insert({'k':'app_code', 'v': aesEncode( creAppCode() ) });
        }

        var code_ftoken = await db.select("v", "k='fcm_token' order by id desc limit 1 ");
        if(!code_ftoken.asMap().containsKey(0)){
          await Firebase.initializeApp();
          final fcmToken = await FirebaseMessaging.instance.getToken();
          db.insert({'k':'fcm_token', 'v': aesEncode( fcmToken ) });
        }
      }

      Timer(Duration(seconds: 1), () {
        Navigator.pushNamedAndRemoveUntil(context, getConfig("first_screen"), (r) => false);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if(!showLoading){
      return Scaffold(
        body: Container(
          child: Center(
            child: Text("loading"),
          ),
        ),
      );
    }
    else{
      return Scaffold(
        body: Container(
          child: Center(
            child: SpinKitWave(
              color: HexColor("#87ceeb"),
              size: 50.0,
            ),
          ),
        ),
      );
    }
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  // print("Handling a background message: ${message.messageId}");
}

var notificationId = 0;
void setForegroundMessaging() async {
  await Firebase.initializeApp();
  final fcmToken = await FirebaseMessaging.instance.getToken();

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );


  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print_r('User granted permission');
  } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
    print_r('User granted provisional permission');
  } else {
    print_r('User declined or has not accepted permission');
  }

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true, // Required to display a heads up notification
    badge: true,
    sound: true,
  );

  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description: 'This channel is used for important notifications.', // description
    importance: Importance.max,
  );

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  const AndroidInitializationSettings initializationSettingsAndroid =  AndroidInitializationSettings('noti_icon');

  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);

  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    RemoteNotification? notification = message.notification;

    print_r('onMessage');

    if (notification != null) {
      if (defaultTargetPlatform == TargetPlatform.android){
        flutterLocalNotificationsPlugin.show(
          notificationId++,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription : channel.description,
            ),
          ),
        );
      }
    }
  });
}