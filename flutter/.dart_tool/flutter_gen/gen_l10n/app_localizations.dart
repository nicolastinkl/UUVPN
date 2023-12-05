import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen_l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('zh')
  ];

  /// Title for the Demo application
  ///
  /// In en, this message translates to:
  /// **'Flutter APP'**
  String get title;

  /// No description provided for @wodedingyue.
  ///
  /// In en, this message translates to:
  /// **'My Subscription'**
  String get wodedingyue;

  /// No description provided for @guoqi.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get guoqi;

  /// No description provided for @yiyong.
  ///
  /// In en, this message translates to:
  /// **'Used'**
  String get yiyong;

  /// No description provided for @zongji.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get zongji;

  /// No description provided for @dinggoutaocan.
  ///
  /// In en, this message translates to:
  /// **'Sub Package'**
  String get dinggoutaocan;

  /// No description provided for @xuangou.
  ///
  /// In en, this message translates to:
  /// **'Buy'**
  String get xuangou;

  /// No description provided for @yidingyue.
  ///
  /// In en, this message translates to:
  /// **'Subscribed'**
  String get yidingyue;

  /// No description provided for @yilianjie.
  ///
  /// In en, this message translates to:
  /// **'Connected'**
  String get yilianjie;

  /// No description provided for @yiduankai.
  ///
  /// In en, this message translates to:
  /// **'Disconnected'**
  String get yiduankai;

  /// No description provided for @qingxiandenglu.
  ///
  /// In en, this message translates to:
  /// **'Please login first'**
  String get qingxiandenglu;

  /// No description provided for @qingxiandingyuetaocan.
  ///
  /// In en, this message translates to:
  /// **'Please subscribed first'**
  String get qingxiandingyuetaocan;

  /// No description provided for @taocanguoqichongxindingyue.
  ///
  /// In en, this message translates to:
  /// **'Package has expired, please subscribe again'**
  String get taocanguoqichongxindingyue;

  /// No description provided for @chagnqiyouxiao.
  ///
  /// In en, this message translates to:
  /// **'Subscribed Never Expires'**
  String get chagnqiyouxiao;

  /// No description provided for @renew.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get renew;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'welcome'**
  String get welcome;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'logout'**
  String get logout;

  /// No description provided for @xuanzeliahjiedian.
  ///
  /// In en, this message translates to:
  /// **'Select Services'**
  String get xuanzeliahjiedian;

  /// No description provided for @yiduankai2.
  ///
  /// In en, this message translates to:
  /// **'Disconnected'**
  String get yiduankai2;

  /// No description provided for @pleaseenter.
  ///
  /// In en, this message translates to:
  /// **'Please enter the correct email address'**
  String get pleaseenter;

  /// No description provided for @passwordcan.
  ///
  /// In en, this message translates to:
  /// **'Password can not be null'**
  String get passwordcan;

  /// No description provided for @passwordcannot.
  ///
  /// In en, this message translates to:
  /// **'Password cannot be less than 6 characters'**
  String get passwordcannot;

  /// No description provided for @loginfailed.
  ///
  /// In en, this message translates to:
  /// **'Login failed, please try again'**
  String get loginfailed;

  /// No description provided for @registrationfailed.
  ///
  /// In en, this message translates to:
  /// **'Registration failed, please try again'**
  String get registrationfailed;

  /// No description provided for @mail.
  ///
  /// In en, this message translates to:
  /// **'Mail'**
  String get mail;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @zhengzailinajie.
  ///
  /// In en, this message translates to:
  /// **'Connecting, please wait...'**
  String get zhengzailinajie;

  /// No description provided for @zhengzaiduankailianjie.
  ///
  /// In en, this message translates to:
  /// **'Disconnecting, please wait...'**
  String get zhengzaiduankailianjie;

  /// No description provided for @confirmpassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmpassword;

  /// No description provided for @twopasswords.
  ///
  /// In en, this message translates to:
  /// **'Two passwords do not match'**
  String get twopasswords;

  /// No description provided for @forgetthepassword.
  ///
  /// In en, this message translates to:
  /// **'Forget the password?'**
  String get forgetthepassword;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @resetpassword.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetpassword;

  /// No description provided for @sure.
  ///
  /// In en, this message translates to:
  /// **'Sure'**
  String get sure;

  /// No description provided for @thesystemwill.
  ///
  /// In en, this message translates to:
  /// **'The system will send a reset password email to your mailbox, please pay attention to check it'**
  String get thesystemwill;

  /// No description provided for @sentsuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Sent successfully'**
  String get sentsuccessfully;

  /// No description provided for @returnstring.
  ///
  /// In en, this message translates to:
  /// **'Return'**
  String get returnstring;

  /// No description provided for @qingxuanzefuwqjiedian.
  ///
  /// In en, this message translates to:
  /// **'Please select a server node'**
  String get qingxuanzefuwqjiedian;

  /// No description provided for @pingallnodes.
  ///
  /// In en, this message translates to:
  /// **'Click Ping All'**
  String get pingallnodes;

  /// No description provided for @timeout.
  ///
  /// In en, this message translates to:
  /// **'timeout'**
  String get timeout;

  /// No description provided for @alertsss.
  ///
  /// In en, this message translates to:
  /// **'alert'**
  String get alertsss;

  /// No description provided for @wanttoexit.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to exit?'**
  String get wanttoexit;

  /// No description provided for @cancelss.
  ///
  /// In en, this message translates to:
  /// **'cancel'**
  String get cancelss;

  /// No description provided for @exitout.
  ///
  /// In en, this message translates to:
  /// **'exit'**
  String get exitout;

  /// No description provided for @clicktoselectanothernode.
  ///
  /// In en, this message translates to:
  /// **'Click to select another node'**
  String get clicktoselectanothernode;

  /// No description provided for @nodefornullcheckissubscripts.
  ///
  /// In en, this message translates to:
  /// **'The Service list is empty, \nPlease Login first.'**
  String get nodefornullcheckissubscripts;

  /// No description provided for @foreveryfree1.
  ///
  /// In en, this message translates to:
  /// **'Notable features of UU: \n * No credit card required\n * You can try premium features for free for 7 days \n* Do not keep any user logs\n* Simple, one-click connection VPN\n* Automatically connects you to the fastest VPN server'**
  String get foreveryfree1;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'zh': return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
