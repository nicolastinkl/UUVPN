# UUVPN


### UUVPN源代码基于Flutter开发，过于难维护，UI效果也很差，最主要是性能和稳定性都不行，所以就决定重新基于 （IOS MACOS）和 Android 分别 基于 SINGBOX 和 CLASH 的内核进行研发。成品已经开发好，视频和展示图如下：

![](screenshots/combined_image10-18_00-08.jpeg)
![](screenshots/4b35f3fd-17a1-40f5-9c73-4484437ca7e6.gif)



-------------------------------过去 UUVPN 的老代码 分界线-------------------------------------
![](screenshots/Snipaste_2023-06-25_11-38-47.png)

# UUVPN 
基于Flutter开发的VPN客户端(ios/android)，自主设计，精美UI,优化VPN速度，完全开源。

A VPN application for [V2Board](https://github.com/v2board/v2board)  

Support iOS and Android now.


 
**IF THIS PROJECT HELPS YOU, PLEASE GIVE ME A LITTLE STAR⭐️.**

## Screenshots
![](screenshots/page_7.png)

## App Store 
![](screenshots/Snipaste_2023-06-10_14-21-20.png)
 

## Environment

- Flutter Flutter 3.10.1 • channel stable • https://github.com/flutter/flutter.git
    Framework • revision d3d8effc68 (6 weeks ago) • 2023-05-16 17:59:05 -0700
    Engine • revision b4fb11214d
    Tools • Dart 3.0.1 • DevTools 2.23.1
    - Download this version url: https://drive.google.com/file/d/1ksM4_PK9Ibk7ycyrfF7XffM_99_4JYV3/view?usp=sharing
    - leaf sdk downlaod url: https://github.com/eycorsican/leaf/releases/tag/v0.10.7

- macOS 13.3.1 +
- Xcode 14 +
- iOS 15.0 +

## Installation

```shell
flutter pub get
```

## Develop
```shell
flutter run
```

## Build
build android apk
```shell
flutter build apk
```

build ios
```shell
flutter build ios
```

---------------------- 

# How to use it?
![](screenshots/ios.png)
![](screenshots/Snipaste_2024-07-24_14-25-11.png)
![](screenshots/Snipaste_2024-07-24_14-58-41.png)

- 1:  Change Domain File Path : ~UUVPN/flutter/lib/constant/app_urls.dart
  ```
    static const String baseUrl = "https://xxxx.com";
  ```

- 2: Xcode Settings:
![](screenshots/Snipaste_2023-12-05_09-48-45.png)
![](screenshots/Snipaste_2023-12-05_09-49-14.png)
![](screenshots/Snipaste_2023-12-05_09-49-23.png) 

- 3: running screenshot:
![](screenshots/Snipaste_2023-12-05_15-43-54.png)
