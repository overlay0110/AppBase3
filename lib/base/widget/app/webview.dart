import 'package:flutter/material.dart';

import 'package:flutter/services.dart';

import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:flutter/foundation.dart';

import 'dart:convert';

import '../../util/util.dart';
import '../../util/utilDB.dart';

import '../../util/locali.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';

class CwebView extends StatefulWidget{
  @override
  State createState() => CwebViewState();
}

class CwebViewState extends State<CwebView>{

  final GlobalKey webViewKey = GlobalKey();

  InAppWebViewController? webViewController;
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        useShouldOverrideUrlLoading: true,
        mediaPlaybackRequiresUserGesture: false,
      ),
      android: AndroidInAppWebViewOptions(
        useHybridComposition: true,
      ),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
      )
  );

  late PullToRefreshController pullToRefreshController;
  String url = "";
  double progress = 0;
  final urlController = TextEditingController();

  String url_set = 'https://inappwebview.dev/';
  String currentUrl = '';
  bool showLoading = true;
  bool showError = false;

  var _jsCall = null;

  DateTime? currentTime;
  var call_config;
  var backMode = '1';

  @override
  void initState() {
    super.initState();

    pullToRefreshController = PullToRefreshController(
      options: PullToRefreshOptions(
        color: Colors.blue,
      ),
      onRefresh: () async {
        // webViewController?.reload();
        // if (Platform.isAndroid) {
        //   webViewController?.reload();
        // } else if (Platform.isIOS) {
        //   webViewController?.loadUrl(
        //       urlRequest: URLRequest(url: await webViewController?.getUrl()));
        // }
        if (defaultTargetPlatform == TargetPlatform.android){
          webViewController?.reload();
        }
        else if (defaultTargetPlatform == TargetPlatform.iOS){
          webViewController?.loadUrl( urlRequest: URLRequest(url: await webViewController?.getUrl()) );
        }


      },
    );

    start();
  }

  void start(){
    print_r('webview2 start()');
    Future.delayed(Duration.zero,() async {

      var code_check = await db.select("v", "k='app_code' order by id desc limit 1 ");
      var app_code = '';

      if(code_check.asMap().containsKey(0)){
        app_code = aesDecode(code_check[0]['v']);
      }

      var datas = await db.select("v", "k='config_call_data' order by id desc limit 1 ");
      if(datas.asMap().containsKey(0)){
        var data = jsonDecode( aesDecode(datas[0]['v']) );
        print_r(data);
        print_r(data['WEBVIEW_URL']);

        print_r(app_code);

        url_set = "${data['WEBVIEW_URL']}&c=${app_code}&l=${Strings.of(context).getLanCode()}&at=appbase3";
        currentUrl = url_set;

        call_config=data;
      }

      setState(() {
        showLoading = false;
      });
    });
  }

  String _postHTML(getUrl, para, [method = "POST"]) {
    String tag = '';
    tag += '<html><body onload="document.f.submit();"><form id="f" name="f" method="post" action="${getUrl}">';
    // tag += '<input type="hidden" name="PARAMETER2" value="VALUE2" />';
    if(para != null){
      para.forEach((key, value) {
        tag += '<input type="hidden" name="${key}" value="${value}" />';
      });
    }
    tag += '</form></body></html>';
    return tag;
  }

  dynamic _onBack(BuildContext context) async {
    var check_pages = [];
    if(call_config != null){
      check_pages=call_config['EXITAPP_PAGES'];
    }

    if(call_config == null){
      Navigator.pop(context);
      return true;
    }

    if(backMode == '1'){
      if( listSearch(currentUrl, check_pages) ){
        DateTime now = DateTime.now();
        if (currentTime == null || now.difference(currentTime!) > const Duration(seconds: 2)) {
          currentTime = now;
          toast( Strings.of(context).trans('finish_mess') );
          return false;
        }
        exitApp();
        return false;
      }
      else{
        webViewController?.goBack();
        return false;
      }
    }
    else if(backMode == '2'){
      var response = {
        'code' : 0,
        'type' : 'onBack',
        'msg' : 'success',
        'result' : [],
      };
      _jsCall.postMessage( jsonEncode(response) );
    }
    else if(backMode == '3'){
      DateTime now = DateTime.now();
      if (currentTime == null || now.difference(currentTime!) > const Duration(seconds: 2)) {
        currentTime = now;
        toast( Strings.of(context).trans('finish_mess') );
        return false;
      }
      exitApp();
      return false;
    }
    else if(backMode == '4'){
      webViewController?.goBack();
      return false;
    }

  }

  @override
  void dispose() {
    super.dispose();
  }

  void webViewBridge(message, sourceOrigin, isMainFrame, replyProxy, context) async {
    if(_jsCall == null){
      _jsCall=replyProxy;
    }

    print_r("request : ${message}");
    var request;
    var response = {
      'code' : 100,
      'type' : '',
      'msg' : 'Fail',
      'result' : [],
    };

    try {
      request = jsonDecode(message!);
      print_r(request);
    } on FormatException catch (e) {
      print_r('message jsonDecode error : ${e.message}');
      return;
    }

    response['type'] = request['type'];

    if(request['type'] == 'appAlert'){
      if(request['value'] != null){
        customAlert(context, request['value']);
      }

      response['code']=0;
      response['msg']='success';
    }

    if(request['type'] == 'alert'){
      if(request['value'] != null){
        customAlert(context, request['value']);
      }

      response['code']=0;
      response['msg']='success';
    }

    if(request['type'] == 'toast'){
      if(request['value'] != null){
        toast(request['value']);
      }

      response['code']=0;
      response['msg']='success';
    }

    if(request['type'] == 'exitApp'){
      response['code']=0;
      response['msg']='success';
      exitApp();
    }

    if(request['type'] == 'openAppBrowser'){
      if(request['value'] != null){
        urlOpen(request['value']);
      }

      response['code']=0;
      response['msg']='success';
    }

    if(request['type'] == 'share'){
      if(request['value'] != null){
        share(request['value']);
      }

      response['code']=0;
      response['msg']='success';
    }

    if(request['type'] == 'copy'){
      if(request['value'] != null){
        Clipboard.setData(ClipboardData(text: request['value'] ));
      }

      response['code']=0;
      response['msg']='success';
    }

    if(request['type'] == 'QRscan'){
      Navigator.pushNamed(context, 'qrscan', arguments: { "call_type" : "bridge_call", "response" : response, "jscall" : replyProxy} );
      return;
    }

    if(request['type'] == 'nfcReadId'){
      var res = await getNfcId(context);

      response['code']=0;
      response['msg']='success';
      response['result']=res;
    }

    if(request['type'] == 'fingerprint'){
      var res = await callLocalAuth();

      response['code']=res['code'];
      response['msg']=res['msg'];

      if(res['result'] != null){
        response['result']=res['result'];
      }
    }

    if(request['type'] == 'getLocation'){
      var res = await getLocation();

      response['code']=res['code'];
      response['msg']=res['msg'];

      if(res['result'] != null){
        response['result']=res['result'];
      }
    }

    if(request['type'] == 'getThemeMode'){
      var res = getThemeMode(context);

      response['code']=0;
      response['msg']='success';
      response['result']=res;
    }

    if(request['type'] == 'getLanCode'){
      var res = Strings.of(context).getLanCode();

      response['code']=0;
      response['msg']='success';
      response['result']=res;
    }

    if(request['type'] == 'backMode'){
      if(request['value'] != null){
        backMode = request['value'];
      }

      response['code']=0;
      response['msg']='success';
    }

    print_r("response : ${response}");

    replyProxy.postMessage( jsonEncode(response) );
  }


  @override
  Widget build(BuildContext context) {
    if(showError){
      return Scaffold(
        appBar: call_config == null ? AppBar(title: Text("Official InAppWebView website")) : null,
        body: WillPopScope(
          onWillPop: () => _onBack(context),
          child: Center(
            child: SafeArea(
              child: Container(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error, size: 120, color: Colors.red,),
                    SizedBox(height: 20.0,),
                    Text("Error", style: TextStyle(fontSize: 18, fontWeight:FontWeight.bold),),
                    SizedBox(height: 20.0,),
                    Container(
                      padding: EdgeInsets.fromLTRB(60, 0, 60, 0),
                      child: Text(
                        "A problem occurred while communicating with the server.",
                        style: TextStyle(fontSize: 15),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

    if(showLoading){
      // return Scaffold(
      //   body: Container(
      //     child: Center(
      //         child: Text("loading...")
      //     ),
      //   ),
      // );

      return Scaffold(
        appBar: call_config == null ? AppBar(title: Text("Official InAppWebView website")) : null,
        body: WillPopScope(
          onWillPop: () => _onBack(context),
          child: Container(
            child: Center(
              child: SpinKitWave(
                color: HexColor("#87ceeb"),
                size: 50.0,
              ),
            ),
          ),
        ),
      );
    }
    return Scaffold(
        appBar: call_config == null ? AppBar(title: Text("Official InAppWebView website")) : null,
        body: WillPopScope(
          onWillPop: () => _onBack(context),
          child: SafeArea(
              child: Column(children: <Widget>[
                call_config == null
                ? TextField(
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search)
                  ),
                  controller: urlController,
                  keyboardType: TextInputType.url,
                  onSubmitted: (value) {
                    var url = Uri.parse(value);
                    if (url.scheme.isEmpty) {
                      url = Uri.parse("https://www.google.com/search?q=" + value);
                    }
                    webViewController?.loadUrl(
                        urlRequest: URLRequest(url: url));
                  },
                )
                : Container(),
                Expanded(
                  child: Stack(
                    children: [
                      InAppWebView(
                        key: webViewKey,
                        // initialUrlRequest: URLRequest(url: Uri.dataFromString(_postHTML(url_set, {'test1' : 'sdafjkasdlfjas'}), mimeType: 'text/html') ),
                        initialOptions: options,
                        pullToRefreshController: pullToRefreshController,
                        onWebViewCreated: (controller) async {
                          webViewController = controller;

                          if ( (defaultTargetPlatform == TargetPlatform.iOS) || await AndroidWebViewFeature.isFeatureSupported(AndroidWebViewFeature.WEB_MESSAGE_LISTENER)) {
                            await controller.addWebMessageListener(WebMessageListener(
                              jsObjectName: "AppBase3",
                              onPostMessage: (message, sourceOrigin, isMainFrame, replyProxy) { webViewBridge(message, sourceOrigin, isMainFrame, replyProxy, context); },
                            ));
                          }
                          await controller.loadUrl(urlRequest: URLRequest(url: Uri.dataFromString(_postHTML(url_set, {'test1' : 'sdafjkasdlfjas'}), mimeType: 'text/html') ) );
                        },
                        onLoadStart: (controller, url) async {
                          print_r('onLoadStart');
                          currentUrl = url.toString();
                          setState(() {
                            this.url = url.toString();
                            urlController.text = this.url;
                          });
                        },
                        androidOnPermissionRequest: (controller, origin, resources) async {
                          return PermissionRequestResponse(
                              resources: resources,
                              action: PermissionRequestResponseAction.GRANT);
                        },
                        shouldOverrideUrlLoading: (controller, navigationAction) async {
                          var uri = navigationAction.request.url!;

                          if (![ "http", "https", "file", "chrome",
                            "data", "javascript", "about"].contains(uri.scheme)) {
                            if (await canLaunch(url)) {
                              // Launch the App
                              await launch(
                                url,
                              );
                              // and cancel the request
                              return NavigationActionPolicy.CANCEL;
                            }
                          }

                          return NavigationActionPolicy.ALLOW;
                        },
                        onLoadStop: (controller, url) async {
                          pullToRefreshController.endRefreshing();
                          setState(() {
                            this.url = url.toString();
                            urlController.text = this.url;
                          });
                        },
                        onLoadError: (controller, url, code, message) {
                          print_r('onLoadError');
                          pullToRefreshController.endRefreshing();
                          setState(() {
                            showError=true;
                          });
                        },
                        onLoadHttpError: (controller, url, code, message){
                          print_r('onLoadHttpError');
                          setState(() {
                            showError=true;
                          });
                        },
                        onProgressChanged: (controller, progress) {
                          if (progress == 100) {
                            pullToRefreshController.endRefreshing();
                          }
                          setState(() {
                            this.progress = progress / 100;
                            urlController.text = this.url;
                          });
                        },
                        onUpdateVisitedHistory: (controller, url, androidIsReload) {
                          print_r("onUpdateVisitedHistory ${url.toString()}");
                          currentUrl = url.toString();
                          setState(() {
                            this.url = url.toString();
                            urlController.text = this.url;
                          });
                        },
                        onConsoleMessage: (controller, consoleMessage) {
                          print_r("js console.log : ${consoleMessage}");
                        },
                      ),
                      Container(),
                      // progress < 1.0
                      //     ? LinearProgressIndicator(value: progress)
                      //     : Container(),
                    ],
                  ),
                ),
                call_config == null
                ? ButtonBar(
                  alignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ElevatedButton(
                      child: Icon(Icons.arrow_back),
                      onPressed: () {
                        webViewController?.goBack();
                      },
                    ),
                    ElevatedButton(
                      child: Icon(Icons.arrow_forward),
                      onPressed: () {
                        webViewController?.goForward();
                      },
                    ),
                    ElevatedButton(
                      child: Icon(Icons.refresh),
                      onPressed: () {
                        webViewController?.reload();
                      },
                    ),
                    ElevatedButton(
                      child: Text("Test"),
                      onPressed: () {
                        webViewController?.loadUrl(urlRequest: URLRequest(url: Uri.parse("...URL.../?p=native_call") ));
                      },
                    ),
                  ],

                )
                : Container(),
              ])),
        )
    );
  }
}