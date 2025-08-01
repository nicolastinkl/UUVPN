# UUVPN iOS SwiftUI Application

A professional iOS VPN application built with SwiftUI, designed to integrate seamlessly with V2Board panel APIs. This application provides a modern, intuitive interface for VPN management with comprehensive configuration options.

## 🚀 Features

- **Modern SwiftUI Interface**: Responsive design that adapts to different screen sizes
- **Dark/Light Mode Support**: Automatic theme synchronization with system preferences
- **V2Board API Integration**: Complete integration with V2Board panel APIs
- **Network Management**: Advanced networking capabilities using `URLSession`
- **Background Updates**: Automatic profile updates with background task scheduling
- **Multi-platform Support**: iOS 15.0+ with macOS compatibility

## 📋 Requirements

Before getting started, ensure your development environment meets the following requirements:

- **Xcode**: 14.0 or later
- **iOS Deployment Target**: 15.0 or later
- **Swift**: 5.7+
- **Network Access**: VPN required for Swift Package Manager dependencies

## 🏗️ Project Structure

```
iOS-SwiftUI-Code/
├── ApplicationLibrary/          # Core application library
│   ├── Service/                 # API services and managers
│   │   ├── StoreManager.swift   # Configuration storage manager
│   │   └── ProfileUpdateTask.swift # Background update tasks
│   ├── Views/                   # SwiftUI view components
│   │   ├── Dashboard/           # Dashboard interface
│   │   ├── Profile/             # Profile management
│   │   └── Setting/             # Settings interface
│   └── Assets.xcassets/         # Application assets
├── XiaoXiong/                   # Main application target
│   ├── DefaultUI/               # Default UI components
│   └── Info.plist               # Application configuration
├── Extension/                   # Network extension
├── SystemExtension/             # System extension for macOS
├── uuvpn.xcodeproj             # Xcode project file
└── README.md                   # Project documentation
```

## ⚙️ Installation & Setup

### 1. Clone the Repository

```bash
git clone https://github.com/nicolastinkl/UUVPN/tree/main/iOS-SwiftUI-Code
cd iOS-SwiftUI-Code
```

### 2. Install Dependencies

The project uses Swift Package Manager for dependency management. **Note: VPN connection required for package resolution.**

```bash
# Dependencies will be automatically resolved when opening the project
```

### 3. Open Project in Xcode

```bash
open uuvpn.xcodeproj
```

Select your target device or simulator and click the **Run** button.

## 🔧 V2Board API Configuration

### Base Configuration

The application integrates with V2Board panels through a comprehensive API configuration system managed by [`StoreManager.swift`](ApplicationLibrary/Service/StoreManager.swift:17).

#### Configuration URL
```swift
public let configURL = "https://api.gooapis.com/api/vpnconfig.php"
```

### API Endpoints Configuration

Configure the following API endpoints in your initialization response:

```json
{
  "baseURL": "https://api.0008.uk/api/v1/",
  "baseDYURL": "https://api.gooapis.com/api/vpnnodes.php",
  "mainregisterURL": "https://lelian.app/#/register?code=",
  "paymentURL": "xxxxx",
  "telegramurl": "https://t.me/fastlink",
  "kefuurl": "https://gooapis.com/fastlink/",
  "websiteURL": "https://gooapis.com/fastlink/",
  "crisptoken": "5546c6ea-4b1e-41bc-80e4-4b6648cbca76",
  "banners": [
    "https://image.gooapis.com/api/images/12-11-56.png",
    "https://image.gooapis.com/api/images/12-44-57.png",
    "https://image.gooapis.com/api/images/12-47-03.png"
  ],
  "message": "OK",
  "code": 1
}
```

### API Field Descriptions

| Field | Description | Usage |
|-------|-------------|-------|
| `baseURL` | Primary API endpoint for V2Board panel | All main API requests |
| `baseDYURL` | Default VPN node testing endpoint | Node connectivity testing |
| `mainregisterURL` | User registration page with referral code | User onboarding |
| `paymentURL` | Payment gateway URL | **Critical for App Store compliance** |
| `telegramurl` | Telegram support channel | Customer support |
| `kefuurl` | Customer service page | Online support |
| `websiteURL` | Official website URL | General information |
| `crisptoken` | Crisp chat authentication token | Live chat integration |
| `banners` | Promotional banner image URLs | Marketing content |
| `message` | Response status message | API response validation |
| `code` | Response status code | Success/error handling |

### API Request Headers

All API requests include the following headers for authentication and tracking:

```swift
request.addValue("application/json", forHTTPHeaderField: "Content-Type")
request.addValue(Bundle.main.bundleIdentifier ?? "", forHTTPHeaderField: "bid")
request.addValue(UserManager.shared.appversion, forHTTPHeaderField: "appver")
```

## 🆔 Bundle Identifier (BID) Configuration

### Understanding Bundle Identifier

The Bundle Identifier (BID) is crucial for app identification and API authentication. It's referenced throughout the codebase as `Bundle.main.bundleIdentifier`.

### Current BID Configuration

Based on the [`Info.plist`](XiaoXiong/Info.plist:7) analysis, the current BID pattern is:
```
com.uuvpn.appleaman
```

### Modifying Bundle Identifier

To change the Bundle Identifier for your deployment:

#### 1. Update Xcode Project Settings
1. Open `uuvpn.xcodeproj` in Xcode
2. Select the project root in the navigator
3. Choose your target (e.g., "SFI", "SFM", "SFT")
4. Navigate to **General** → **Identity**
5. Update the **Bundle Identifier** field

#### 2. Update Info.plist References
Search and replace all BID references in configuration files:

```bash
# Search for current BID references
grep -r "com.uuvpn.appleaman" .

# Update the following files:
# - XiaoXiong/Info.plist
# - Extension/Info.plist  
# - SystemExtension/Info.plist
# - IntentsExtension/Info.plist
```

#### 3. Update Code References
The BID is automatically retrieved via `Bundle.main.bundleIdentifier` in:
- [`Login.swift`](XiaoXiong/DefaultUI/View/LoginView/Login.swift:494)
- [`HomeView.swift`](XiaoXiong/DefaultUI/View/HomeView.swift:984)

No code changes required as it uses the system bundle identifier.

### BID Validation in API

The server can validate requests using the BID header to ensure API calls come from authorized applications.

## 💳 Payment URL Logic & App Store Compliance

### Payment URL Length Detection

The application implements intelligent payment handling based on the `paymentURL` field length:

```swift
// Apple Review Mode Detection
if (paymentURLKey.count > 3) {
    // Normal payment mode - show external payment options
    // Enable subscription features
    // Show payment buttons and pricing
} else {
    // Apple Review Mode - hide external payments
    // Comply with App Store guidelines
    // Hide sensitive payment information
}
```

### Implementation Details

#### Normal Mode (paymentURL.length > 3)
- **External Payment**: Direct users to web-based payment systems
- **Full Feature Access**: All subscription features available
- **Payment Integration**: Complete payment flow with external providers

#### Apple Review Mode (paymentURL.length ≤ 3)
- **Compliance Mode**: Hides external payment options
- **Limited Features**: Restricted functionality during review
- **App Store Guidelines**: Complies with Apple's payment policies

### Code Implementation

The logic is implemented across multiple view files:

- [`HomeView.swift`](XiaoXiong/DefaultUI/View/HomeView.swift:125): Main payment UI logic
- [`SideMenuView.swift`](XiaoXiong/DefaultUI/View/SideMenuView.swift:119): Menu payment options
- [`ActiveDashboardViewNewUI.swift`](XiaoXiong/DefaultUI/View/ActiveDashboardViewNewUI.swift:217): Dashboard payment handling

### Server-Side Configuration

Configure your initialization endpoint to return:

```json
{
  "paymentURL": "https://your-payment-gateway.com/pay",  // Normal mode
  // OR
  "paymentURL": "xx",  // Apple review mode
}
```

## 🔄 Initialization Endpoint Configuration

### Endpoint Setup

The application fetches configuration from a remote endpoint on startup. This allows dynamic configuration without app updates.

#### Recommended Hosting
- **Alibaba Cloud OSS**: Faster response times in China
- **CDN Integration**: Global content delivery
- **HTTPS Required**: Secure configuration delivery

### Configuration Response Format

```json
{
  "baseURL": "https://your-v2board-panel.com/api/v1/",
  "baseDYURL": "https://your-node-test-endpoint.com/api/vpnnodes.php",
  "mainregisterURL": "https://your-panel.com/#/register?code=",
  "paymentURL": "https://your-payment-gateway.com/",
  "telegramurl": "https://t.me/your-support-channel",
  "kefuurl": "https://your-support-site.com/",
  "websiteURL": "https://your-website.com/",
  "crisptoken": "your-crisp-chat-token",
  "banners": [
    "https://your-cdn.com/banner1.png",
    "https://your-cdn.com/banner2.png"
  ],
  "message": "OK",
  "code": 1
}
```

### Error Handling

```json
{
  "message": "Configuration Error",
  "code": 0,
  "error": "Invalid request"
}
```

### Caching Strategy

The [`StoreManager`](ApplicationLibrary/Service/StoreManager.swift) implements local caching:

```swift
// Configuration is cached locally using UserDefaults
func storebaseURLData(data: String) {
    defaults.set(data, forKey: "baseURLKey")
    defaults.synchronize()
}
```

## 🔐 Security Considerations

### API Security
- **HTTPS Only**: All API endpoints must use HTTPS
- **Token Validation**: Implement proper token validation
- **Rate Limiting**: Protect against API abuse

### Bundle Identifier Security
- **Unique BID**: Use a unique bundle identifier for your deployment
- **Server Validation**: Validate BID on server-side for API requests
- **Certificate Pinning**: Consider implementing certificate pinning

## 🚀 Deployment Guide

### Pre-Deployment Checklist

1. **Update Bundle Identifier**: Change from default BID
2. **Configure API Endpoints**: Set up your V2Board panel URLs
3. **Test Payment Logic**: Verify both normal and review modes
4. **Update App Icons**: Replace default icons with your branding
5. **Configure Push Notifications**: Set up notification certificates

### Build Configuration

```bash
# Clean build folder
rm -rf ~/Library/Developer/Xcode/DerivedData

# Archive for distribution
xcodebuild archive \
  -project uuvpn.xcodeproj \
  -scheme YourSchemeName \
  -archivePath YourApp.xcarchive
```

## 🤝 Contributing

We welcome contributions to improve the application. Please follow these guidelines:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## 📄 License

This project is licensed under the MIT License. See the LICENSE file for details.

## 📞 Support

For technical support and questions:

- **GitHub Issues**: [Create an issue](https://github.com/nicolastinkl/UUVPN/issues)
- **Documentation**: Refer to the deployment documentation in the project
- **Community**: Join our developer community for assistance

---

**Note**: This application requires proper V2Board panel setup and valid API endpoints to function correctly. Ensure your backend infrastructure is properly configured before deployment.
