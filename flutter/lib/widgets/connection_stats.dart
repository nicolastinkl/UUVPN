import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:sail/channels/Platform.dart';
import 'package:sail/constant/app_colors.dart';
import 'package:sail/model/themeCollection.dart';
import 'package:sail/models/app_model.dart';
import 'package:sail/models/server_model.dart';
import 'package:sail/models/user_model.dart';
import 'package:sail/utils/l10n.dart';
import 'package:sail/utils/navigator_util.dart';

class ConnectionStats extends StatefulWidget {
  const ConnectionStats({Key? key}) : super(key: key);

  @override
  ConnectionStatsState createState() => ConnectionStatsState();
}

class ConnectionStatsState extends State<ConnectionStats> {
  late UserModel _userModel;
  late AppModel _appModel;
  late ServerModel _serverModel;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _userModel = Provider.of<UserModel>(context);
    _appModel = Provider.of<AppModel>(context);
    _serverModel = Provider.of<ServerModel>(context);
  }

  String toDateString(DateTime date) {
    var duration = DateTime.now().difference(date);
    var microseconds = duration.inMicroseconds;
    var sign = (microseconds < 0) ? "-" : "";

    var hours = microseconds ~/ Duration.microsecondsPerHour;
    microseconds = microseconds.remainder(Duration.microsecondsPerHour);
    var hoursPadding = hours.abs() < 10 ? "0" : "";

    if (microseconds < 0) microseconds = -microseconds;

    var minutes = microseconds ~/ Duration.microsecondsPerMinute;
    microseconds = microseconds.remainder(Duration.microsecondsPerMinute);

    var minutesPadding = minutes < 10 ? "0" : "";

    var seconds = microseconds ~/ Duration.microsecondsPerSecond;
    microseconds = microseconds.remainder(Duration.microsecondsPerSecond);

    var secondsPadding = seconds < 10 ? "0" : "";

    return "$sign$hoursPadding${hours.abs()}:"
        "$minutesPadding$minutes:"
        "$secondsPadding$seconds";
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkTheme = Provider.of<ThemeCollection>(context).isDarkActive;
    Color colortheme = isDarkTheme ? Colors.white : Colors.black;
    //isDarkTheme ? Colors.white : Colors.black

    if (Platform.isAndroid || Platform.isMacOS) {
      return Column(
        children: [
          Padding(
            padding:
                EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(75)),
            child: TextButton(
                onPressed: () => _userModel.checkHasLogin(
                    context, () => NavigatorUtil.goServerList(context)),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Icon(Icons.map,
                      color: isDarkTheme ? Colors.white : Colors.black,
                      size: 20),
                  Text(context.l10n.clicktoselectanothernode,
                      style: TextStyle(
                          fontSize: 18,
                          color: isDarkTheme ? Colors.white : Colors.black)),
                  Icon(Icons.chevron_right,
                      color: isDarkTheme ? Colors.white : Colors.black,
                      size: 20)
                ])),
          ),
        ],
      );
    }

    return Column(
      children: [
        Text(toDateString(_appModel.connectedDate!),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 40,
              color: colortheme,
            )),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(75)),
          child: TextButton(
              onPressed: () => _userModel.checkHasLogin(
                  context, () => NavigatorUtil.goServerList(context)),
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(Icons.map,
                    color: isDarkTheme ? Colors.white : Colors.black, size: 20),
                // Text(context.l10n.clicktoselectanothernode,
                Text(" ${_serverModel.selectServerEntity?.name}",
                    style: TextStyle(
                        fontSize: 18,
                        color: isDarkTheme ? Colors.white : Colors.black)),
                Icon(Icons.chevron_right,
                    color: isDarkTheme ? Colors.white : Colors.black, size: 20)
              ])),
        ),
        /* Padding(
          padding: EdgeInsets.symmetric(
              horizontal: ScreenUtil().setWidth(75), vertical: 10),
          child: Row(
            children: [
              // Download Stats

              Row(children: [
                // Download Icon
                Container(
                  decoration: BoxDecoration(
                      boxShadow: const [
                        BoxShadow(
                            color: Color(0xffff0000),
                            blurRadius: 13,
                            spreadRadius: -2)
                      ],
                      color: const Color(0xffff0000),
                      borderRadius: BorderRadius.circular(13)),
                  padding: const EdgeInsets.all(5),
                  child: const Icon(
                    Icons.arrow_downward,
                    color: Colors.white,
                  ),
                ),

                // Labels
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "下行速度",
                        style: TextStyle(
                            color: AppColors.grayColor,
                            fontWeight: FontWeight.w500),
                      ),
                      RichText(
                        text: const TextSpan(
                            style: TextStyle(
                                color: AppColors.grayColor,
                                fontWeight: FontWeight.w900),
                            children: [
                              TextSpan(text: "75.9"),
                              TextSpan(
                                  text: " KB/s",
                                  style:
                                      TextStyle(fontWeight: FontWeight.normal)),
                            ]),
                      )
                    ],
                  ),
                )
              ]),

              Expanded(child: Container()),

              // Upload Stats
              Row(children: [
                // Upload Icon
                Container(
                  decoration: BoxDecoration(
                      boxShadow: const [
                        BoxShadow(
                            color: Color(0xff03a305),
                            blurRadius: 13,
                            spreadRadius: -2)
                      ],
                      color: const Color(0xff03a305),
                      borderRadius: BorderRadius.circular(13)),
                  padding: const EdgeInsets.all(5),
                  child: const Icon(
                    Icons.arrow_upward,
                    color: Colors.white,
                  ),
                ),

                // Labels
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "上行速度",
                        style: TextStyle(
                            color: AppColors.grayColor,
                            fontWeight: FontWeight.w500),
                      ),
                      RichText(
                        text: const TextSpan(
                            style: TextStyle(
                                color: AppColors.grayColor,
                                fontWeight: FontWeight.w900),
                            children: [
                              TextSpan(text: "29.6"),
                              TextSpan(
                                  text: " KB/s",
                                  style:
                                      TextStyle(fontWeight: FontWeight.normal)),
                            ]),
                      )
                    ],
                  ),
                )
              ]),
            ],
          ),
        )*/
      ],
    );
  }
}
