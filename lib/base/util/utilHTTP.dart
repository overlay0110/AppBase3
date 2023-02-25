import 'config.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';

import 'dart:convert';

import 'util.dart';

Future<String> netCheck() async {
  var res = await (Connectivity().checkConnectivity());
  if (res == ConnectivityResult.mobile) {
    return 'mobile';
  }
  else if (res == ConnectivityResult.wifi) {
    return 'wifi';
  }
  else if (res == ConnectivityResult.bluetooth) {
    return 'bluetooth';
  }
  else if (res == ConnectivityResult.ethernet) {
    return 'ethernet';
  }
  else if (res == ConnectivityResult.vpn) {
    return 'vpn';
  }

  return 'none';
}

// file upload add
dynamic callAPI(getUrl, para, [method = "POST", getHead = null]) async{
  String json = "";
  var url;
  var urlp;
  var response;

  if(method == "GET"){
    getUrl = getUrl.replaceAll("http://", "");
    getUrl = getUrl.replaceAll("https://", "");
    urlp = getUrl.split('/');
    url = Uri.https(urlp[0], urlp[1], para);
    response = await http.get(url, headers: getHead);
  }
  else{
    url = Uri.parse(getUrl);
    response = await http.post(url, body: para, headers: getHead);
  }

  print_r(response.body);

  json = response.body;

  return jsonDecode(json);
}
