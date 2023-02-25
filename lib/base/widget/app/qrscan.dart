import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import 'dart:convert';

import '../../util/util.dart';

class QrScan extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text('qrscan')),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: FloatingActionButton(
          child: Icon(Icons.keyboard_arrow_left),
          backgroundColor: HexColor('#313131'),
          onPressed: () { Navigator.pop(context); },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      body : Container(
        color: Colors.black,
        padding: const EdgeInsets.only(top:200, bottom:150),
        child: Stack(
          alignment: Alignment.center,
          children: [
            MobileScanner(
              allowDuplicates: false,
              onDetect: (barcode, args) {
                if(barcode.rawValue != null){
                  final String code = barcode.rawValue!;
                  try{
                    var navi_args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

                    if(navi_args['call_type'] == 'bridge_call'){
                      navi_args['response']['code'] = 0;
                      navi_args['response']['msg'] = 'success';
                      navi_args['response']['result'] = code;

                      navi_args['jscall'].postMessage( jsonEncode(navi_args['response']) );
                      Navigator.pop(context);
                      return;
                    }
                  }
                  on FormatException catch(e){
                    Navigator.pop(context);
                    return;
                  }

                  toast('Barcode found! $code');
                  Navigator.pop(context);
                }
              }
            ),
            Positioned(
              child: Container(
                width: 250.0,
                height: 250.0,
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 2,
                    color: Colors.green,
                  ),
                ),
              )
            ),
          ],
        ),
      )
    );
  }
}

