import 'config.dart';
import 'package:flutter/foundation.dart';
import 'dart:math';

import 'package:flutter_root_jailbreak/flutter_root_jailbreak.dart';

import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter_share/flutter_share.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/services.dart';

import 'package:local_auth/local_auth.dart';
import 'package:local_auth/error_codes.dart' as auth_error;

import 'package:geolocator/geolocator.dart';

import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';

import 'package:package_info_plus/package_info_plus.dart';

import 'package:url_launcher/url_launcher.dart';

import 'package:flutter_exit_app/flutter_exit_app.dart';

dynamic getConfig(String key){
  return config[key];
}

void print_r(Object? object){
  var debug = getConfig("debug");
  if(debug){
    print(object);
  }
}

Future<bool> rootJailCheck() async {
  bool result = false;
  if (defaultTargetPlatform == TargetPlatform.android){
    result = await FlutterRootJailbreak.isRooted;
  }
  else if (defaultTargetPlatform == TargetPlatform.iOS){
    result = await FlutterRootJailbreak.isJailBroken;
  }

  return result;
}

dynamic isMobile(){
  if (defaultTargetPlatform == TargetPlatform.android){
    return true;
  }
  else if (defaultTargetPlatform == TargetPlatform.iOS){
    return true;
  }
  return false;
}

dynamic hashSHA256(value){
  // var result = hashSHA256("fjksdjaflkas");
  return sha256.convert( utf8.encode(value) );
}

String aesEncode(value, [keyVal="", ivValue="#@%^&*()_+=-"]){
  final keyUtf8 = utf8.encode(keyVal);
  final ivUtf8 = utf8.encode(ivValue);
  final key = sha256.convert(keyUtf8).toString().substring(0, 32);
  final iv = sha256.convert(ivUtf8).toString().substring(0, 16);
  var set_iv = encrypt.IV.fromUtf8(iv);

  final encode = encrypt.Encrypter(encrypt.AES(encrypt.Key.fromUtf8(key), mode: encrypt.AESMode.cbc));

  return encode.encrypt(value, iv: set_iv).base64;
}

String aesDecode(value, [keyVal="", ivValue="#@%^&*()_+=-"]){
  final keyUtf8 = utf8.encode(keyVal);
  final ivUtf8 = utf8.encode(ivValue);
  final key = sha256.convert(keyUtf8).toString().substring(0, 32);
  final iv = sha256.convert(ivUtf8).toString().substring(0, 16);
  var set_iv = encrypt.IV.fromUtf8(iv);

  final decode = encrypt.Encrypter(encrypt.AES(encrypt.Key.fromUtf8(key), mode: encrypt.AESMode.cbc));

  return decode.decrypt64(value, iv: set_iv);
}

/*
* PHP FUNCTIONS *
function mobileEncrypt($value, $secret_key='', $secret_iv='#@%^&*()_+=-'){
    $key = substr(hash('sha256', $secret_key), 0, 32);
    $iv = substr(hash('sha256', $secret_iv), 0, 16);
		return openssl_encrypt($value, 'AES-256-CBC', $key, 0, $iv);
}
function mobileDecrypt($value, $secret_key='', $secret_iv='#@%^&*()_+=-'){
    $key = substr(hash('sha256', $secret_key), 0, 32);
    $iv = substr(hash('sha256', $secret_iv), 0, 16);
		return openssl_decrypt($value, 'AES-256-CBC', $key, 0, $iv);
}
*/

Future<void> share(value) async {
  await FlutterShare.share(title:'SHARE', text : value);
  // await FlutterShare.share(
  //     title: 'Example share',
  //     text: 'Example share text',
  //     linkUrl: 'https://flutter.dev/',
  //     chooserTitle: 'Example Chooser Title'
  // );
}

void toast(value){
  Fluttertoast.showToast(
    msg: value,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
  );
}

void customAlert(context, [msg = "Default message"]){
  if(defaultTargetPlatform == TargetPlatform.iOS){
    showDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            // title: Text('Cupertino Alert Dialog'),
            content: Text(msg),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('OK')),
            ],
          );
        });
  }
  else{
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            // title: Text('Material Alert Dialog'),
            content: Text(msg),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('OK')),
            ],
          );
        });
  }
}

void actionAlert(context, [msg = "Default message", action]){
  if(defaultTargetPlatform == TargetPlatform.iOS) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return CupertinoAlertDialog(
            // title: Text('Cupertino Alert Dialog'),
            content: Text(msg),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    action();
                    Navigator.pop(context);
                  },
                  child: Text('OK')),
            ],
          );
    });
  }
  else{
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            // title: Text('Material Alert Dialog'),
            content: Text(msg),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    action();
                    Navigator.pop(context);
                  },
                  child: Text('OK')),
            ],
          );
        }
    );
  }
}

void actionAlert2(context, [msg = "Default message", action]){
  if(defaultTargetPlatform == TargetPlatform.iOS) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return CupertinoAlertDialog(
            // title: Text('Cupertino Alert Dialog'),
            content: Text(msg),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('CANCEL'),
              ),
              TextButton(
                  onPressed: () {
                    action();
                    Navigator.pop(context);
                  },
                  child: Text('OK')),
            ],
          );
        });
  }
  else{
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            // title: Text('Material Alert Dialog'),
            content: Text(msg),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('CANCEL'),
              ),
              TextButton(
                  onPressed: () {
                    action();
                    Navigator.pop(context);
                  },
                  child: Text('OK')),
            ],
          );
        }
    );
  }
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}

dynamic callLocalAuth([showMsg = "Please authenticate to show account balance"]) async {
  final LocalAuthentication auth = LocalAuthentication();

  bool isBioSupported=await auth.isDeviceSupported();
  print_r(isBioSupported);
  if ( !isBioSupported ) {
    return { "code" : "999", "msg" : "This device does not support biometric recognition."};
  }

  final List<BiometricType> availableBiometrics = await auth.getAvailableBiometrics();
  print_r(availableBiometrics);
  // if ( !availableBiometrics.contains(BiometricType.fingerprint) ) {
  //   return { "code" : "999", "msg" : "This device does not support biometric recognition."};
  // }

  try {
    final bool didAuthenticate = await auth.authenticate(
        localizedReason: showMsg,
        options: const AuthenticationOptions(useErrorDialogs: false)
    );

    if(!didAuthenticate){
      return { "code" : "103", "msg" : "etc_error", "result" : didAuthenticate};
    }

    return { "code" : "0", "msg" : "Success", "result" : didAuthenticate};
  } on PlatformException catch (e) {
    if (e.code == auth_error.notAvailable) {
      return { "code" : "100", "msg" : "notAvailable", "result" : e.code};
    } else if (e.code == auth_error.notEnrolled) {
      return { "code" : "101", "msg" : "notEnrolled", "result" : e.code};
    } else {
      return { "code" : "102", "msg" : "etc_error", "result" : e.code};
    }
  }
}

dynamic getLocation() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return { "code" : "100", "msg" : "Location services are not enabled don't continue"};
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return { "code" : "101", "msg" : "Permissions are denied, next time you could try"};
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return { "code" : "102", "msg" : "Permissions are denied forever, handle appropriately."};
  }

  Position getPosition = await Geolocator.getCurrentPosition();
  var result = getPosition.toJson();

  return { "code" : "0", "msg" : "success", "result" : result};
}

dynamic getNfcId(context, [msg = "Scan your tag"]) async {
  final theme = Theme.of(context);
  var bsControl;
  bool closeCheck = false;

  var availability = await FlutterNfcKit.nfcAvailability;
  print_r(availability);
  if (availability != NFCAvailability.available) {
    return { "code" : "100", "msg" : "Available"};
  }

  if (defaultTargetPlatform == TargetPlatform.android){
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        context: context,
        builder: (context) {
          bsControl = context;
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child:Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 12.0,),
                  child: Container(
                    height: 5.0,
                    decoration: BoxDecoration(
                      color: theme.dividerColor,
                      borderRadius: const BorderRadius.all(Radius.circular(2.5)),
                    ),
                  ),
                  width: 60,
                ),
                Container(height: 60,),
                Icon(Icons.tap_and_play, size: 60,),
                SizedBox(height: 20.0,),
                Text(msg),
                Container(height: 60,),
              ],
            ),
          );
        }
    ).whenComplete(() {
      if(!closeCheck){
        closeNfc();
      }
    });
  }

  // timeout only works on Android, while the latter two messages are only for iOS
  var tag = await FlutterNfcKit.poll(timeout: Duration(seconds: 10), iosMultipleTagMessage: msg, iosAlertMessage: msg);

  if(bsControl != null){
    closeCheck=true;
    Navigator.pop(bsControl);
  }

  if (defaultTargetPlatform == TargetPlatform.iOS){
    closeNfc();
  }

  return tag.id;
}

void closeNfc() async {
  await FlutterNfcKit.finish();
}

dynamic getThemeMode(context){
  // Brightness.dark, Brightness.light
  var check = MediaQuery.of(context).platformBrightness;
  if(check == Brightness.dark){
    return 'dark';
  }
  else{
    return 'light';
  }
}

dynamic getDeviceSize(context){
  return {
    "width" : MediaQuery.of(context).size.width.toStringAsFixed(1),
    "height" : MediaQuery.of(context).size.height.toStringAsFixed(1),
    "devicePixelRatio" : MediaQuery.of(context).devicePixelRatio.toStringAsFixed(1),
  };
}

dynamic getDeviceVersion() async {
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  print_r(packageInfo);
  return packageInfo.version;
}

void urlOpen(url){
  launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
}

void exitApp(){
  if (defaultTargetPlatform == TargetPlatform.android){
    // FlutterExitApp.exitApp();
    SystemNavigator.pop();
  }
  else if (defaultTargetPlatform == TargetPlatform.iOS){
    FlutterExitApp.exitApp(iosForceExit: true);
  }
}

int randomRange(int min, int max){
  final _random = new Random();
  return min + _random.nextInt(max - min);
}

String creAppCode(){
  return 'APP_${randomRange(10, 99)}_${DateTime.now().microsecondsSinceEpoch}';
}

dynamic getStatusBarHeight(context){
  return MediaQuery.of(context).padding.top;
}

dynamic listSearch(base, list){
  for(var i=0;i<list.length;i++){
    if(base.indexOf(list[i]) != -1){
      return true;
    }
  }
  return false;
}

dynamic qrBaseUrl(){
  return 'https://chart.googleapis.com/chart?chs=200x200&chld=M|0&cht=qr&chl=';
}
