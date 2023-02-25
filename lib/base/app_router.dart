import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter/services.dart';

import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';

import 'util/locali.dart';
import 'util/util.dart';

import 'widget/app/load.dart';
import 'widget/app/main.dart';
import 'widget/app/qrscan.dart';
import 'widget/app/webview.dart';
import 'widget/app/google_map.dart';

import 'provider/count_provider.dart';
import 'widget/base/counter_test.dart';
import 'widget/base/ful_widget.dart';
import 'widget/base/less_widget.dart';
import 'widget/base/native_call.dart';

import 'widget/test/test.dart';
import 'widget/test/ani_menu.dart';
import 'widget/test/animation.dart';
import 'widget/test/ani_test2.dart';
import 'widget/test/ani_test3.dart';
import 'widget/test/ani_test4.dart';
import 'widget/test/ani_test5.dart';
import 'widget/test/ani_test6.dart';
import 'widget/test/ani_test_scroll.dart';

final router_app = {
  'load': (context) => Load(),
  'main': (context) => Main(),
  'qrscan': (context) => QrScan(),
  'webview': (context) => CwebView(),
  'google_map': (context) => googleMap(),
};

final router_base = {
  'counter': (context) => ChangeNotifierProvider(create: (_) => CountProvider(), child: Counter(), ),
  'widget_l': (context) => LessWidget(),
  'widget_f': (context) => FulWidget(),
  'native_call': (context) => NativeCall(),
};

final router_test = {
  'test': (context) => Test(),
  'ani_menu': (context) => aniMenus(),
  'test_animation': (context) => AnimationTest(),
  'ani_test2': (context) => AniTest2(),
  'ani_test3': (context) => StaggerDemo(),
  'ani_test4': (context) => RadialExpansionDemo(),
  'ani_test5': (context) => AnimatedContainerApp(),
  'ani_test6': (context) => AniTest6(),
  'ani_test_scroll': (context) => AnimateOnScrollFlutter(),
};

class AppRouter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero,() async {
      await FlutterStatusbarcolor.setStatusBarColor(HexColor(getConfig('status_bar_color')));
      await FlutterStatusbarcolor.setStatusBarWhiteForeground(getConfig('status_bar_style') == 'light-content' ? true : false);
    });

    return MaterialApp(
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          systemOverlayStyle: getConfig('status_bar_style') == 'light-content' ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
        ),
      ),
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        LocaliDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('en'),
        Locale('ko'),
      ],
      initialRoute : 'load',
      routes: {
        ...router_app,
        ...router_base,
        ...router_test,
      },
    );
  }
}