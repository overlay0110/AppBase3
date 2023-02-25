import 'package:flutter/material.dart';

class LessWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('StatelessWidget Example')),
        body : Center(
          child: Text('less_widget.dart'),
        )
    );
  }
}

/*
ElevatedButton(
          child: Text('back'),
          onPressed: () {
            // Named route를 사용하여 두 번째 화면으로 전환합니다.
            Navigator.pop(context);
            // Navigator.pushNamed(context, 'main');
          },
        )


*/