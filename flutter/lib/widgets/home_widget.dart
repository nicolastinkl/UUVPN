import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:sail/constant/app_colors.dart';
import 'package:sail/model/themeCollection.dart';
import 'package:sail/models/app_model.dart';
import 'package:sail/models/plan_model.dart';
import 'package:sail/models/server_model.dart';
import 'package:sail/models/user_model.dart';
import 'package:sail/models/user_subscribe_model.dart';
import 'package:sail/resources/app_colors.dart';
import 'package:sail/utils/l10n.dart';
import 'package:sail/widgets/bottom_block.dart';
import 'package:sail/widgets/connection_stats.dart';
import 'package:sail/widgets/logo_bar.dart';
import 'package:sail/widgets/my_subscribe.dart';
import 'package:sail/widgets/plan_list.dart';
import 'package:sail/widgets/power_btn.dart';
import 'package:sail/widgets/select_location.dart';
import 'package:sail/utils/common_util.dart';
import 'package:sail/widgets/watermuticicel.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({Key? key}) : super(key: key);

  @override
  HomeWidgetState createState() => HomeWidgetState();
}

class HomeWidgetState extends State<HomeWidget>
    with AutomaticKeepAliveClientMixin {
  late AppModel _appModel;
  late UserModel _userModel;
  late UserSubscribeModel _userSubscribeModel;
  late PlanModel _planModel;
  late ServerModel _serverModel;

  customListTile(BuildContext context, String title, String icon,
          {Widget? trailing, String? subtitle, VoidCallback? onTap}) =>
      ListTile(
          onTap: onTap ?? null,
          minLeadingWidth: 35,
          dense: true,
          title: Text(title,
              style: Theme.of(context).primaryTextTheme.labelMedium),
          subtitle: subtitle != null
              ? Text(
                  subtitle,
                  style: Theme.of(context).primaryTextTheme.labelMedium,
                )
              : null,
          leading: SvgPicture.asset(
            icon,
            color: Theme.of(context).colorScheme.secondary,
            width: 24,
            alignment: Alignment.centerRight,
          ),
          trailing: trailing ?? null);

  @override
  bool get wantKeepAlive => true;

  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();

    // _controller.addListener(() {
    //   //print(_controller.offset);
    // });
  }

  @override
  void dispose() {
    //为了避免内存泄露，需要调用_controller.dispose
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _appModel = Provider.of<AppModel>(context);
    _userModel = Provider.of<UserModel>(context);
    _userSubscribeModel = Provider.of<UserSubscribeModel>(context);
    _planModel = Provider.of<PlanModel>(context);
    _serverModel = Provider.of<ServerModel>(context);
    // print("didChangeDependencies");
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    bool isDarkTheme = Provider.of<ThemeCollection>(context).isDarkActive;

    return SingleChildScrollView(
        controller: _controller,
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // // Logo bar
            // Padding(
            //   padding: EdgeInsets.only(
            //       left: ScreenUtil().setWidth(75),
            //       right: ScreenUtil().setWidth(75)),
            //   child: LogoBar(
            //     isOn: _appModel.isOn,
            //   ),
            // ),

            const SizedBox(
              height: 20,
            ),

            // SvgPicture.asset(
            //   'assets/map.svg',
            //   height: 230,
            //   width: ScreenUtil().screenWidth,
            //   color: _appModel.isOn
            //       ? AppColors.greenColor
            //       : isDarkTheme
            //           ? AppColors.darkSurfaceColor
            //           : Color.fromARGB(255, 133, 132, 132),
            // ),
            PowerButton(),
            const SizedBox(
              height: 40,
            ),
            _appModel.isOn
                ? (_serverModel.selectServerEntity?.name != null
                    ? Center(
                        child: Text('${context.l10n.yilianjie}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isDarkTheme ? Colors.white : Colors.black,
                              fontSize: 25,
                            )))
                    : Center(
                        child: Text(context.l10n.yilianjie,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isDarkTheme ? Colors.white : Colors.black,
                              fontSize: 25,
                            ))))
                : Center(
                    child: Text(context.l10n.yiduankai2,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isDarkTheme ? Colors.white : Colors.black,
                          fontSize: 25,
                        ))),
            const SizedBox(
              height: 20,
            ),
            _appModel.isOn
                ? ConnectionStats()
                : const SizedBox(
                    height: 1,
                  ),

            const BottomBlock(),
          ],
        ));
  }
}
