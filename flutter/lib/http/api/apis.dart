/*后台接口api*/
import 'package:sail/common/public.dart';

class Apis {
  static String appid = "IPOSih2134KHJKLDIO";
  static String token =
      "${Global.baseUrl}flutter/gettoken.php/?s=App.JYApp_Main.GetToken";
  static String getLaunchAds =
      "${Global.baseUrl}flutter/gettoken.php/?s=App.JYApp_Main.GetLaunchAds";
  static String getRecommandList = "${Global.baseUrl}flutter/recommand.php";
}
