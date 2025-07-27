<div align="center">
<a name="readme-top"></a>
<h1><a href="https://www.uuvpn.com/" target="_blank">UUVPN🪜</a></h1>

## 一款适用于 iOS 和 Android 的 VPN 应用，支持所有 [V2Board](https://github.com/cedar2025/Xboard) 服务器

[![][license-shield]][license-link] [![][docs-shield]][docs-link] [![][github-release-shield]][github-release-link] [![][github-stars-shield]][github-stars-link]

English | [简体中文](README-zh_CN.md)
</div>
<br/>

## 什么是 UUVPN？
UUVPN 在 iOS/macOS 和 Android 上原生运行，采用强大的 SINGBOX 和 CLASH(mihomo) 核心。

![](screenshots/android/combined_image11-19_12-04-1.jpeg)

### 新版本功能：

- 更流畅、响应更灵敏的用户界面
- 增强了应用稳定性
- 显著的性能优化
- 此外，UUVPN 现已支持服务器后端协议，并完全兼容 V2Board，为 VPN 管理提供更无缝、更灵活的用户体验。

### 主要功能：
- 原生性能：UUVPN 利用适用于 iOS/macOS 的 SINGBOX 和适用于 Android 的 CLASH，优化了稳定性和速度。
- 兼容 V2Board：完全支持 V2Board 协议，为后端管理提供流畅的集成。
- 更精致的用户界面：全新设计的界面，外观时尚，提供用户友好的体验。

### 服务器：
- https://github.com/cedar2025/Xboard
此接口地址用于处理 UUVPN 的核心功能，包括用户身份验证、配置获取和连接管理。

#### 协议兼容性
UUVPN 的 iOS 和 Android 版本与基于 https://github.com/cedar2025/Xboard 系列的服务器高度兼容，并支持以下常用协议：

- Shadowsocks：提供安全的 SOCKS5 代理，支持加密传输。

- VMess：支持多种传输方式（如 TCP、WebSocket、QUIC 等），适用于高性能场景。

- VLESS：轻量级协议，兼容性强，支持 TCP、WebSocket 和 gRPC 等传输方式。

- Trojan：模拟 HTTPS 流量，支持 TLS 加密，隐蔽性强。

- SOCKS5：标准代理协议，支持 TCP 和 UDP 流量。

HTTP/HTTPS：支持 HTTP 代理和 HTTPS 加密连接。

* UUVPN 的 iOS 和 Android 版本与 Xboard 系列的服务器实现一致，理论上支持所有 Xboard 兼容的协议配置。
具体协议支持情况可能取决于服务器端的配置，请确保服务器端正确启用相关协议。
对于特殊协议（例如 TUIC 或 Hysteria），您需要确认服务器端是否已部署支持。
- 兼容性说明
跨平台一致性：iOS 和 Android 版本使用相同的服务器接口地址，以确保用户在不同设备上获得一致的体验。
版本兼容性：UUVPN 的客户端向下兼容基于 Xboard 的服务器版本，适用于大多数 Xboard 系列部署。
扩展性：如果您需要支持其他协议（例如 WireGuard 或 Hysteria2），请参考 Xboard 文档进行服务器端配置调整。 *

### 下载 iOS 和 Android 版本
- [iOS TestFlight (Beta)](https://t.me/dcgzeus)
- [Android Apk](https://github.com/nicolastinkl/UUVPN/releases)

## iOS 截图和演示视频：

### 皮肤 1：
<table>
<tr>

<td><img src="screenshots/IMG_8546.PNG" width="300" /></td>
<td><img src="screenshots/IMG_8544.PNG" width="300" /></td>
<td><img src="screenshots/IMG_8547.PNG" width="300" /></td>
</tr>

</table>

### 皮肤 2：

<table>

<tr>

<td><img src="screenshots/21-31-06.png" width="300" /></td>
<td><img src="screenshots/IMG_8728.PNG" width="300" /></td>
<td><img src="screenshots/IMG_8725.PNG" width="300" /></td>
</tr>

</table>

### 逻辑视图：

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

## 视频：
<table>
<tr>
<td><img src="screenshots/13264cf9-99e7-4ff8-8e32-2564eea05670.gif" width="200" /></td>
 <td><img src="screenshots/8a51ed33-248b-45eb-b5ba-b92821256632.gif" width="200" /></td>
 <td><img src="screenshots/8a51ed33-248b-45eb-b5ba-b928212566321.gif" width="200" /></td>

 </tr>
</表>


## [iOS YouTube 视频预览地址](https://www.youtube.com/shorts/tnr38-IM-Xo)


# Android 应用程序项目


## [Android YouTube 视频预览地址](https://youtube.com/shorts/zI1hrpFJbtg?feature=share)


![](屏幕nshots/combined_image12-31_10-39.jpeg) 
