import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:sail/constant/app_colors.dart';
import 'package:sail/model/themeCollection.dart';
import 'package:sail/models/app_model.dart';
import 'package:sail/models/server_model.dart';
import 'package:sail/models/user_model.dart';
import 'package:sail/utils/l10n.dart';
import 'package:sail/utils/message_util.dart';
import 'package:sail/utils/navigator_util.dart';
import 'package:sail/widgets/watermuticicel.dart';
import 'package:sail/widgets/waterrepper.dart';

class PowerButton extends StatefulWidget {
  const PowerButton({Key? key}) : super(key: key);

  @override
  PowerButtonState createState() => PowerButtonState();
}

class PowerButtonState extends State<PowerButton> {
  late AppModel _appModel;
  late UserModel _userModel;
  late ServerModel _serverModel;
  bool light = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _appModel = Provider.of<AppModel>(context);
    _userModel = Provider.of<UserModel>(context);
    _serverModel = Provider.of<ServerModel>(context);
    light = _appModel.isOn; // || _appModel.isconnectordisconnct;
  }

  Future<void> pressConnectBtn() async {
    if (_serverModel.selectServerEntity == null) {
      Fluttertoast.showToast(
          msg: context.l10n.qingxuanzefuwqjiedian,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2,
          textColor: Colors.white,
          fontSize: 14.0);
      if (_serverModel.serverEntityList.isEmpty) {
        MessageUtil.toast(context.l10n.nodefornullcheckissubscripts);
      } else {
        NavigatorUtil.goServerList(context);
      }
      return;
    }

    _appModel.togglePowerButton();
  }

  final MaterialStateProperty<Icon?> thumbIcon =
      MaterialStateProperty.resolveWith<Icon?>(
    (Set<MaterialState> states) {
      if (states.contains(MaterialState.selected)) {
        return const Icon(Icons.check);
      }
      return const Icon(Icons.close);
    },
  );

  @override
  Widget build(BuildContext context) {
    //
    return Column(
      children: [
        _appModel.isOn
            ? Container(
                width: 330,
                height: 330,
                child: WaterRipple(
                  color: Colors.green,
                  duration: Duration(milliseconds: 2000),
                )
                //  WaterMultipleCircleLoading(
                //   color: Colors.green,
                //   duration: Duration(milliseconds: 2500),
                // ),
                )
            : Container(
                height: 330,
              ),
        /*InkWell(
          splashColor: Color.fromARGB(255, 51, 117, 54),
          onTap: () => _userModel.checkHasLogin(context, pressConnectBtn),
          borderRadius: BorderRadius.circular(ScreenUtil().setWidth(440)),
          child: Container(
              padding: EdgeInsets.all(ScreenUtil().setWidth(20)),
              child: Icon(
                _appModel.isOn ? Icons.toggle_on : Icons.toggle_off,
                size: ScreenUtil().setWidth(420),
                color: _appModel.isOn
                    ? Color.fromARGB(255, 47, 161, 53)
                    : Colors.grey,
              )),
        )*/
        Transform.scale(
          scale: 4.0,
          child: Switch(
            // thumbIcon: thumbIcon,
            // This bool value toggles the switch.
            value: light,
            activeColor: Color.fromARGB(255, 47, 161, 53),
            inactiveTrackColor:
                Provider.of<ThemeCollection>(context).isDarkActive
                    ? AppColors.whiteColor.withAlpha(90)
                    : const Color(0xffD7D6D9),
            onChanged: (bool value) {
              // This is called when the user toggles the switch.
              setState(() {
                light = value;

                if (value) {
                  _userModel.checkHasLogin(context, pressConnectBtn);
                } else {
                  _appModel.togglePowerButton();
                }
              });
            },
          ),
        ),
      ],
    );

    /*return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color:
            _appModel.isOn ? const Color(0x20000000) : const Color(0xff606060),
        borderRadius: BorderRadius.circular(ScreenUtil().setWidth(460)),
      ),
      child: Material(
        borderRadius: BorderRadius.circular(ScreenUtil().setWidth(440)),
        color: _appModel.isOn ? Color.fromARGB(255, 47, 161, 53) : Colors.grey,
        child: InkWell(
          splashColor: Color.fromARGB(255, 51, 117, 54),
          onTap: () => _userModel.checkHasLogin(context, pressConnectBtn),
          borderRadius: BorderRadius.circular(ScreenUtil().setWidth(440)),
          child: Container(
              padding: EdgeInsets.all(ScreenUtil().setWidth(20)),
              child: Icon(
                Icons.toggle_off,
                size: ScreenUtil().setWidth(420),
                color: Colors.white,
              )),
        ),
      ),
    );*/
  }
}
