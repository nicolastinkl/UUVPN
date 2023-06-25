import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:sail/constant/app_colors.dart';
import 'package:sail/constant/app_strings.dart';
import 'package:sail/models/app_model.dart';
import 'package:sail/models/user_model.dart';
import 'package:sail/models/user_subscribe_model.dart';
import 'package:sail/utils/l10n.dart';
import 'package:sail/utils/navigator_util.dart';

class LogoBar extends StatelessWidget {
  const LogoBar({
    Key? key,
    required this.isOn,
  }) : super(key: key);

  final bool isOn;

  void onLogoutTap(context, _userModel) {
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
                    context.l10n.wanttoexit,
                    style: TextStyle(fontSize: 18),
                  ),
                  alignment: Alignment(0, 0),
                ),
              ],
            ),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text(context.l10n.cancelss),
                onPressed: () {
                  Navigator.pop(context);
                  //print("取消");
                },
              ),
              CupertinoDialogAction(
                child: Text(
                  context.l10n.exitout,
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () {
                  //print("确定");
                  _userModel.logout();
                  NavigatorUtil.goLogin(context);
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    AppModel appModel = Provider.of<AppModel>(context);
    UserModel userModel = Provider.of<UserModel>(context);
    UserSubscribeModel userSubscribeModel =
        Provider.of<UserSubscribeModel>(context);

    return Container(
      margin: EdgeInsets.only(top: ScreenUtil().setWidth(60)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            AppStrings.appName,
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: ScreenUtil().setSp(60),
              color: isOn ? AppColors.whiteColor : Colors.white,
            ),
          ),
          Row(
            children: [
              // Material(
              //   color: isOn ? const Color(0x66000000) : AppColors.darkSurfaceColor,
              //   borderRadius: BorderRadius.circular(ScreenUtil().setWidth(30)),
              //   child: InkWell(
              //     borderRadius: BorderRadius.circular(ScreenUtil().setWidth(30)),
              //     onTap: () => NavigatorUtil.goToCrisp(context),
              //     child: Container(
              //       padding: EdgeInsets.symmetric(
              //           vertical: ScreenUtil().setWidth(10), horizontal: ScreenUtil().setWidth(30)),
              //       child: Text(
              //         "客服",
              //         style:
              //         TextStyle(fontSize: ScreenUtil().setSp(36), color: Colors.white, fontWeight: FontWeight.w500),
              //       ),
              //     ),
              //   ),
              // ),
              // Padding(padding: EdgeInsets.only(left: ScreenUtil().setWidth(15))),
              Material(
                color:
                    isOn ? const Color(0x66000000) : AppColors.darkSurfaceColor,
                borderRadius: BorderRadius.circular(ScreenUtil().setWidth(30)),
                child: InkWell(
                  borderRadius:
                      BorderRadius.circular(ScreenUtil().setWidth(30)),
                  onTap: () => appModel.jumpToPage(3),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        vertical: ScreenUtil().setWidth(10),
                        horizontal: ScreenUtil().setWidth(30)),
                    child: Text(
                      userSubscribeModel?.userSubscribeEntity?.email ??
                          context.l10n.welcome,
                      style: TextStyle(
                          fontSize: ScreenUtil().setSp(36),
                          color: Colors.white,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
              userModel.isLogin
                  ? Padding(
                      padding: EdgeInsets.only(left: ScreenUtil().setWidth(15)))
                  : Container(),
              userModel.isLogin
                  ? Material(
                      color: isOn
                          ? const Color(0x66000000)
                          : AppColors.darkSurfaceColor,
                      borderRadius:
                          BorderRadius.circular(ScreenUtil().setWidth(30)),
                      child: InkWell(
                        borderRadius:
                            BorderRadius.circular(ScreenUtil().setWidth(30)),
                        onTap: () {
                          onLogoutTap(context, userModel);
                          // userModel.logout();
                          // NavigatorUtil.goLogin(context);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: ScreenUtil().setWidth(10),
                              horizontal: ScreenUtil().setWidth(30)),
                          child: Text(
                            context.l10n.logout,
                            style: TextStyle(
                                fontSize: ScreenUtil().setSp(36),
                                color: Colors.white,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    )
                  : Container(),
            ],
          )
        ],
      ),
    );
  }
}
