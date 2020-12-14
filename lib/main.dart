import 'dart:async';

import 'package:filepicker_windows/filepicker_windows.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:qr_flutter/qr_flutter.dart';

/// 输入文本 - 一次展示最长80字符
TextEditingController ctrl =
    TextEditingController.fromValue(TextEditingValue(text: ''));

var pgCtrl = PageController(
  initialPage: 0,
  viewportFraction: 1,
);

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
          leading: Builder(
            builder: (c) => IconButton(
              icon: Icon(Icons.photo),
              onPressed: () {
                var f = OpenFilePicker().getFile();

                // FileDialog();
                // showDialog(context: c, builder: (c) => FileDialog());
              },
            ),
          ),
          title: Text('文本 | 二维码'),
          actions: [
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
                stm.add(ctrl.text);
              },
            ),
            IconButton(
              icon: Icon(Icons.arrow_left_rounded),
              onPressed: () {
                var tar = pgCtrl.page.toInt() - 1;
                if (tar >= 0) pgCtrl.jumpToPage(tar);
              },
            ),
            IconButton(
              icon: Icon(Icons.arrow_right_rounded),
              onPressed: () {
                var tar = pgCtrl.page.toInt() + 1;
                pgCtrl.jumpToPage(tar);
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
          maxLines: 200,
          maxLength: 2000,
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
          // print('$start|$end');
          list.add(txt.substring(start, end));
        }
        var _count = 1;
        return Expanded(
          child: PageView(
            scrollDirection: Axis.horizontal,
            controller: pgCtrl,
            physics: BouncingScrollPhysics(),
            pageSnapping: true,
            children: list
                .map((e) => Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: [
                        QrImage(data: e),
                        Text('${_count++} / ${list.length}'),
                      ],
                    )))
                .toList(),
          ),
        );
      });
}
