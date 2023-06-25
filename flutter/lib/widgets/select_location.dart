import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:sail/constant/app_colors.dart';
import 'package:sail/model/themeCollection.dart';
import 'package:sail/models/server_model.dart';
import 'package:sail/models/user_model.dart';
import 'package:sail/utils/l10n.dart';
import 'package:sail/utils/navigator_util.dart';

class SelectLocation extends StatefulWidget {
  const SelectLocation({
    Key? key,
  }) : super(key: key);

  @override
  SelectLocationState createState() => SelectLocationState();
}

class SelectLocationState extends State<SelectLocation> {
  late ServerModel _serverModel;
  late UserModel _userModel;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _userModel = Provider.of<UserModel>(context);
  }

  @override
  Widget build(BuildContext context) {
    _serverModel = Provider.of<ServerModel>(context);
    bool isDarkTheme = Provider.of<ThemeCollection>(context).isDarkActive;
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: 20, horizontal: ScreenUtil().setWidth(75)),
      child: Material(
        borderRadius: BorderRadius.circular(20),
        color: Colors.green[600],
        child: InkWell(
          onTap: () => _userModel.checkHasLogin(
              context, () => NavigatorUtil.goServerList(context)),
          splashColor: Colors.grey,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                color: AppColors.yellowColor.withAlpha(200),
                blurRadius: 20,
                spreadRadius: -6,
                offset: const Offset(
                  0.0,
                  3.0,
                ),
              )
            ]),
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
            child: Row(
              children: [
                Icon(
                  Icons.sailing,
                  color: isDarkTheme ? Colors.white : Colors.black,
                ),
                Padding(
                    padding: EdgeInsets.only(left: ScreenUtil().setWidth(10))),
                Text(
                  _serverModel.selectServerEntity?.name ??
                      context.l10n.xuanzeliahjiedian,
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: isDarkTheme ? Colors.white : Colors.black),
                ),
                Expanded(child: Container()),
                Icon(
                  Icons.chevron_right,
                  color: isDarkTheme ? Colors.white : Colors.black,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
