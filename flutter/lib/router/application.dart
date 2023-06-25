import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sail/utils/l10n.dart';

class Application {
  static FluroRouter? router;
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey();
  static showMsg(context, msg) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text(context.l10n.alertsss),
            content: Column(
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                Align(
                  child: Text(
                    msg,
                    style: TextStyle(fontSize: 18),
                  ),
                  alignment: Alignment(0, 0),
                ),
              ],
            ),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text(
                  context.l10n.sure,
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () {
                  //print("确定");
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }
}
