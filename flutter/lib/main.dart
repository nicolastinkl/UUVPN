import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as services;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:uuvpn/constant/app_colors.dart';
import 'package:uuvpn/constant/app_strings.dart';
import 'package:provider/provider.dart';
import 'package:uuvpn/models/app_model.dart';
import 'package:uuvpn/models/plan_model.dart';
import 'package:uuvpn/models/server_model.dart';
import 'package:uuvpn/models/user_subscribe_model.dart';
import 'package:uuvpn/router/application.dart';
import 'package:uuvpn/router/routers.dart';
import 'package:uuvpn/models/user_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'model/UserPreference.dart';
import 'model/themeCollection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var appModel = AppModel();
  var userViewModel = UserModel();
  var userSubscribeModel = UserSubscribeModel();
  var serverModel = ServerModel();
  var planModel = PlanModel();

  await userViewModel.refreshData(); // Add this line
  await ScreenUtil.ensureScreenSize();

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider<AppModel>.value(value: appModel),
    ChangeNotifierProvider<UserModel>.value(value: userViewModel),
    ChangeNotifierProvider<UserSubscribeModel>.value(value: userSubscribeModel),
    ChangeNotifierProvider<ServerModel>.value(value: serverModel),
    ChangeNotifierProvider<ThemeCollection>.value(value: ThemeCollection()),
    ChangeNotifierProvider<UserPreference>.value(value: UserPreference()),
    ChangeNotifierProvider<PlanModel>.value(value: planModel)
  ], child: SailApp()));
}

class SailApp extends StatelessWidget {
  SailApp({Key? key}) : super(key: key) {
    final router = FluroRouter();
    Routers.configureRoutes(router);
    Application.router = router;
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // // var userViewModel = Provider.of<UserModel>(context);
    // // var onceuse = userViewModel.getOnceUse();
    // // print("onceuse.toString(): ${onceuse.toString()}");
    // String onceuse = "0";
    // if (onceuse == "1") {
    // } else {

    // }

    AppModel appModel = Provider.of<AppModel>(context);

    services.SystemChrome.setPreferredOrientations([
      services.DeviceOrientation.portraitUp,
      services.DeviceOrientation.portraitDown
    ]);

    return MaterialApp(
      // <--- /!\ Add the builder
      title: AppStrings.appName,
      navigatorKey: Application.navigatorKey,
      debugShowCheckedModeBanner: false,
      onGenerateRoute: Application.router?.generator,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', 'US'), // 美式英语
        Locale('zh', 'CN'), // 简体中文
        //其它Locales
      ],
      // theme: appModel.themeData, //固定主题
      theme: Provider.of<ThemeCollection>(context).getActiveTheme,
    );
  }
}
