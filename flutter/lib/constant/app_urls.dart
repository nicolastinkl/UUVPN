class AppUrls {
  // static const String baseUrl = 'https://user.51mdss.com'; // 基础接口地址
  // static const String baseUrl = "https://www.58mdss.com";
  static const String baseUrl = "https://gohash123.com";
  static const String baseApiUrl = '$baseUrl/api/v1'; // 基础接口地址

  static const String login = '$baseApiUrl/passport/auth/login';
  static const String register = '$baseApiUrl/passport/auth/register';

  // static const String login = 'https://www.heyuegendan.com/vpn/login.php';
  // static const String register = 'https://www.heyuegendan.com/vpn/register.php';
  static const String getQuickLoginUrl =
      '$baseApiUrl/passport/auth/getQuickLoginUrl';

  static const String userSubscribe = '$baseApiUrl/user/getSubscribe';
  static const String plan = '$baseApiUrl/guest/plan/fetch';
  static const String server = '$baseApiUrl/user/server/fetch';
  static const String userInfo = '$baseApiUrl/user/info';
}
