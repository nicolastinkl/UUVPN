## UUVPN - Redesigned for Performance, Stability, and [V2Board](https://github.com/cedar2025/Xboard) Compatibility

The original UUVPN was built using Flutter, which led to increasing challenges in maintaining the codebase due to performance issues, subpar UI quality, and a lack of stability. To address these concerns, UUVPN has been completely redeveloped for native performance on iOS/macOS and Android, utilizing the powerful SINGBOX and CLASH cores.


![](screenshots/android/combined_image11-19_12-04-1.jpeg)


### The new version features:

- A sleek, more responsive user interface
- Enhanced app stability
- Significant performance optimizations
- Additionally, UUVPN now supports server backend protocols with full compatibility for V2Board, providing a more seamless and flexible user experience for VPN management.

### Key Features:
- Native Performance: Utilizing SINGBOX for iOS/macOS and CLASH for Android, UUVPN is optimized for stability and speed.
- V2Board Compatibility: Fully supports V2Board protocols, offering smooth integration for backend management.
- Refined UI: A completely redesigned interface with a modern look and feel, providing a user-friendly experience.


### Download iOS and android 
- [iOS TestFlight (Beta)](https://t.me/dcgzeus)
- [Android Apk](https://github.com/nicolastinkl/UUVPN/releases) 

##  iOS  Screenshots and Demo Video:

### SKIN 1:
<table>
  <tr>
    
   <td><img src="screenshots/IMG_8546.PNG" width="300" /></td>
   <td><img src="screenshots/IMG_8544.PNG" width="300" /></td>
   <td><img src="screenshots/IMG_8547.PNG" width="300" /></td>
  </tr>  

 </table>
 


### SKIN 2:


<table>

  <tr>
    
   <td><img src="screenshots/21-31-06.png" width="300" /></td>
   <td><img src="screenshots/IMG_8728.PNG" width="300" /></td>
   <td><img src="screenshots/IMG_8725.PNG" width="300" /></td>
  </tr>  

</table>

### LOGIC VIEWS:


<table>

  <tr>
    
   <td><img src="screenshots/mmexport1730598307009.png" width="300" /></td>
   <td><img src="screenshots/mmexport1730598308041.png" width="300" /></td>
   <td><img src="screenshots/mmexport1730598311150.png" width="300" /></td>
  </tr>  


  <tr>
    
   <td><img src="screenshots/gongdan.png" width="300" /></td>
   <td><img src="screenshots/gongdanchat.png" width="300" /></td>
   <td><img src="screenshots/mmexport1730598305428.jpg" width="300" /></td>
  </tr>  


</table>

 

## Vidos:
<table>
  <tr>
  <td><img src="screenshots/13264cf9-99e7-4ff8-8e32-2564eea05670.gif" width="200" /></td>
   <td><img src="screenshots/8a51ed33-248b-45eb-b5ba-b92821256632.gif" width="200" /></td>
   <td><img src="screenshots/8a51ed33-248b-45eb-b5ba-b928212566321.gif" width="200" /></td>

  </tr>  
</table>


## [iOS Youtu视频预览地址](https://www.youtube.com/shorts/tnr38-IM-Xo)
 

# Android App Project


## [Android Youtu视频预览地址](https://youtube.com/shorts/zI1hrpFJbtg?feature=share)
 
 
![](screenshots/combined_image12-31_10-39.jpeg)
## Prerequisites

Before you begin, ensure you have met the following requirements:

- **Operating System**: Any system that supports Android development (Windows, macOS, Linux).
- **Java Development Kit (JDK)**: JDK 11 or higher.
- **Android Studio**: The official IDE for Android development, version 4.1 or higher.
- **Android SDK**: The latest version of the Android SDK tools.
- **Go**: go version go1.23.2 darwin/amd64

# Legacy Version (Original Flutter-based UUVPN)
The following section contains information about the original Flutter-based UUVPN for historical reference. If you need the source code, you can check out the **flutter** branch

<details> <summary>Click to view the legacy version details</summary>
# Old Description:
  
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
