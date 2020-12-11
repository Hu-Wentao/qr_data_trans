import 'dart:async';

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

/// 输入文本 - 一次展示最长80字符
TextEditingController ctrl =
    TextEditingController.fromValue(TextEditingValue(text: ''));

StreamController<String> stm = StreamController<String>();

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('文本转二维码'),
          actions: [
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
                stm.add(ctrl.text);
              },
            )
          ],
        ),
        body: Row(
          children: [
            InputTextView(),
            VerticalDivider(),
            QrGenView(),
          ],
        ),
      ),
    );
  }
}

/// 输入文本
class InputTextView extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Expanded(
      child: TextField(
          controller: ctrl,
          maxLines: 100,
          maxLength: 1000,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
          )));
}

class QrGenView extends StatelessWidget {
  @override
  Widget build(BuildContext context) => StreamBuilder<String>(
      stream: stm.stream,
      builder: (c, snap) {
        var txt = snap.data ?? '';
        List<String> list = [];
        int num = (txt.length ~/ 80) + 1;
        // print(num);
        for (int i = 0; i < num; i++) {
          var start = i * 80;
          var end = (start + 80) > txt.length ? txt.length : (start + 80);
          print('$start|$end');
          list.add(txt.substring(start, end));
        }
        return Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: list
                  .map(
                    (e) => Padding(
                        padding: EdgeInsets.all(8), child: QrImage(data: e)),
                  )
                  .toList(),
            ),
          ),
        );
      });
}
