import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MessageUtil {
  static toast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  static alert(String msg, BuildContext context, {Function? callback}) {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return Material(
          color: Colors.transparent,
          child: CupertinoAlertDialog(
              title: Text("提示"),
              content: Text(msg),
              actions: <Widget>[
                CupertinoButton(
                    child: Text("确定"),
                    onPressed: () {
                      Navigator.pop(context);
                      callback!();
                    }),
              ]),
        );
      },
    );
  }

  static snack(String msg, BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      action: SnackBarAction(
        label: "关闭",
        onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
      ),
    ));
  }
}
