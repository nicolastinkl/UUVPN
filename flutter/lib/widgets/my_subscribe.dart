import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sail/constant/app_colors.dart';
import 'package:sail/entity/user_subscribe_entity.dart';
import 'package:sail/model/themeCollection.dart';
import 'package:sail/models/app_model.dart';
import 'package:sail/models/user_model.dart';
import 'package:sail/router/application.dart';
import 'package:sail/routes/OnceNotice.dart';
import 'package:sail/utils/l10n.dart';
import 'package:sail/utils/navigator_util.dart';
import 'package:sail/utils/transfer_util.dart';

class MySubscribe extends StatefulWidget {
  const MySubscribe(
      {Key? key,
      required this.isLogin,
      required this.isOn,
      required this.userSubscribeEntity})
      : super(key: key);

  final bool isLogin;
  final bool isOn;
  final UserSubscribeEntity? userSubscribeEntity;

  @override
  MySubscribeState createState() => MySubscribeState();
}

class MySubscribeState extends State<MySubscribe> {
  late AppModel _appModel;
  late UserModel _userModel;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _appModel = Provider.of<AppModel>(context);
    _userModel = Provider.of<UserModel>(context);
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkTheme = Provider.of<ThemeCollection>(context).isDarkActive;
    //,color:  isDarkTheme ? Colors.white : Colors.black,
    //widget.isOn
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.only(left: ScreenUtil().setWidth(75)),
          child: Text(
            context.l10n.yidingyue,
            style: TextStyle(
                fontSize: ScreenUtil().setSp(32),
                color: isDarkTheme ? Colors.grey[400] : AppColors.grayColor,
                fontWeight: FontWeight.w500),
          ),
        ),
        SizedBox(height: ScreenUtil().setWidth(30)),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.only(bottom: ScreenUtil().setWidth(10)),
          child: _contentWidget(),
        )
      ],
    );
  }

  Widget _contentWidget() {
    // print(widget.userSubscribeEntity?.plan.toJson().toString());
    if (widget.userSubscribeEntity?.plan == null) {
      return _emptyWidget();
    }

    // if (widget.userSubscribeEntity!.expiredAt * 1000 <
    //     DateTime.now().millisecondsSinceEpoch) {
    //   return _timeOutWidget();
    // }

    return _buildConnections();
  }

  Widget _emptyWidget() {
    bool isDarkTheme = Provider.of<ThemeCollection>(context).isDarkActive;

    return Container(
      width: ScreenUtil().setWidth(1080),
      height: ScreenUtil().setWidth(200),
      padding: EdgeInsets.symmetric(
          horizontal: ScreenUtil().setWidth(75),
          vertical: ScreenUtil().setWidth(0)),
      child: Material(
        elevation: widget.isOn ? 3 : 0,
        borderRadius: BorderRadius.circular(ScreenUtil().setWidth(30)),
        color: isDarkTheme
            ? AppColors.darkSurfaceColor
            : const Color.fromARGB(255, 196, 194, 194),
        child: Container(
          alignment: Alignment.center,
          child: Text(
            !widget.isLogin
                ? context.l10n.qingxiandenglu
                : context.l10n.qingxiandingyuetaocan,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: ScreenUtil().setWidth(40),
                color: isDarkTheme ? Colors.white : Colors.black),
          ),
        ),
      ),
    );
  }

  Widget _timeOutWidget() {
    return Container(
      width: ScreenUtil().setWidth(1080),
      height: ScreenUtil().setWidth(200),
      padding: EdgeInsets.symmetric(
          horizontal: ScreenUtil().setWidth(75),
          vertical: ScreenUtil().setWidth(0)),
      child: Material(
        elevation: widget.isOn ? 3 : 0,
        borderRadius: BorderRadius.circular(ScreenUtil().setWidth(30)),
        color: widget.isOn ? Colors.white : AppColors.darkSurfaceColor,
        child: Container(
          alignment: Alignment.center,
          child: Text(
            context.l10n.taocanguoqichongxindingyue,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: ScreenUtil().setWidth(40),
                color: widget.isOn ? Colors.black : Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildConnections() {
    bool isDarkTheme = Provider.of<ThemeCollection>(context).isDarkActive;
    return Container(
        width: ScreenUtil().setWidth(1080),
        height: ScreenUtil().setWidth(240),
        padding: EdgeInsets.symmetric(
            horizontal: ScreenUtil().setWidth(75),
            vertical: ScreenUtil().setWidth(0)),
        child: Material(
          elevation: widget.isOn ? 3 : 0,
          borderRadius: BorderRadius.circular(ScreenUtil().setWidth(30)),
          color: isDarkTheme
              ? AppColors.whiteColor.withAlpha(20)
              : Colors.grey[200],
          child: Container(
            padding: EdgeInsets.symmetric(
                vertical: ScreenUtil().setWidth(30),
                horizontal: ScreenUtil().setWidth(40)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.userSubscribeEntity!.plan?.name ?? "",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: ScreenUtil().setSp(35),
                              color:
                                  !isDarkTheme ? Colors.black : Colors.white),
                        ),
                        Padding(
                            padding: EdgeInsets.only(
                                left: ScreenUtil().setWidth(15))),
                        Text(
                          widget.userSubscribeEntity?.expiredAt != 0
                              ? '${DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.fromMillisecondsSinceEpoch(widget.userSubscribeEntity!.expiredAt * 1000))} ${context.l10n.guoqi}'
                              : context.l10n.chagnqiyouxiao,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: ScreenUtil().setSp(35),
                              color:
                                  !isDarkTheme ? Colors.black : Colors.white),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: ScreenUtil().setWidth(480),
                          padding: EdgeInsets.only(
                              bottom: ScreenUtil().setWidth(15)),
                          child: LinearProgressIndicator(
                            backgroundColor:
                                !isDarkTheme ? Colors.grey[400] : Colors.white,
                            valueColor:
                                AlwaysStoppedAnimation(Colors.green[600]),
                            value: double.parse(((widget
                                                .userSubscribeEntity!.u ??
                                            0 + widget.userSubscribeEntity!.d ??
                                            0) /
                                        widget.userSubscribeEntity!
                                            .transferEnable ??
                                    1)
                                .toStringAsFixed(2)),
                          ),
                        ),
                        Text(
                          '${context.l10n.yiyong} ${TransferUtil().toHumanReadable(widget.userSubscribeEntity!.u + widget.userSubscribeEntity!.d)} / ${context.l10n.zongji} ${TransferUtil().toHumanReadable(widget.userSubscribeEntity!.transferEnable)}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: ScreenUtil().setSp(26),
                              color:
                                  !isDarkTheme ? Colors.black : Colors.white),
                        )
                      ],
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    /*Container(
                      width: ScreenUtil().setWidth(160),
                      height: ScreenUtil().setWidth(90),
                      margin: EdgeInsets.only(right: ScreenUtil().setWidth(10)),
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.green[700],
                          disabledForegroundColor: Colors.black,
                          disabledBackgroundColor: Colors.grey,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                        ),
                        onPressed: () {
                          _userModel.checkHasLogin(
                              context,
                              () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (builder) => const OnceNotice()))

                              /*Fluttertoast.showToast(
                                  msg: context.l10n.qingxuanzefuwqjiedian,
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 2,
                                  textColor: Colors.white,
                                  fontSize: 14.0)*/
                              //NavigatorUtil.goPlan(context)
                              );
                          //_appModel.getTunnelLog();
                        },
                        child: Text(
                          context.l10n.renew,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: ScreenUtil().setSp(36)),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: ScreenUtil().setWidth(160),
                      height: ScreenUtil().setWidth(90),
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.green[700],
                          disabledForegroundColor: Colors.black,
                          disabledBackgroundColor: Colors.grey,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                        ),
                        onPressed: () {
                          _appModel.getTunnelConfiguration();
                        },
                        child: Text(
                          '重置',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: ScreenUtil().setSp(36)),
                        ),
                      ),
                    )*/
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
