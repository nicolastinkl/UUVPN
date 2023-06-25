import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

enum Os {
  web,
  android,
  ios,
  macOS,
  linux,
  windows,
  fuchsia,
}

class Platform {
  const Platform();

  /// Platform is Web.
  static bool get isWeb => os == Os.web;

  /// Platform is Android.
  static bool get isAndroid => os == Os.android;

  /// Platform is IOS.
  static bool get isIOS => os == Os.ios;

  /// Platform is Fuchsia.
  static bool get isFuchsia => os == Os.fuchsia;

  /// Platform is Linux.
  static bool get isLinux => os == Os.linux;

  /// Platform is MacOS.
  static bool get isMacOS => os == Os.macOS;

  /// Platform is Windows.
  static bool get isWindows => os == Os.windows;

  /// Platform is Android or IOS.
  static bool get isMobile => isAndroid || isIOS;

  /// Platform is Android or IOS or Fuchsia.
  static bool get isFullMobile => isMobile || isFuchsia;

  /// Platform is Linux or Windows or MacOS.
  static bool get isDesktop => isLinux || isWindows || isMacOS;

  /// Getting the os name.
  static Os get os {
    if (kIsWeb) {
      return Os.web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return Os.android;
      case TargetPlatform.iOS:
        return Os.ios;
      case TargetPlatform.macOS:
        return Os.macOS;
      case TargetPlatform.windows:
        return Os.windows;
      case TargetPlatform.fuchsia:
        return Os.fuchsia;
      case TargetPlatform.linux:
        return Os.linux;
    }
  }
}
