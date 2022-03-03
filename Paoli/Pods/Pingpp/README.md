# Pingpp iOS SDK

## 目录

* [1. 简介](#1)
* [2. 版本要求](#2)
* [3. 接入方法](#3)
    * [3. 使用 CocoaPods](#3.1)
    * [3. 手动导入](#3.2)
* [4. 接入方法](#4)
    * [4.1 使用 Ping++ 标准版 SDK](#4.1)
    * [4.2 接收并处理交易结果](#4.2)
* [5. 额外配置](#5)
* [6. 注意事项](#6)

## <h2 id='1'>简介</h2>

lib 文件夹下是 iOS SDK 文件，  
example 文件夹里面是一个简单的接入示例，该示例仅供参考。

## <h2 id='2'>版本要求</h2>

iOS SDK 要求 iOS 10.0 及以上版本

## <h2 id='3'>接入方法</h2>

### <h3 id='3.1'>使用 CocoaPods</h3>

1. 在 `Podfile` 添加

    ```ruby
    pod 'Pingpp', '~> 2.2.35'
    ```

    默认会包含支付宝和银联。你也可以自己选择渠道。  
    目前支持以下模块：

    - `Alipay`（支付宝移动支付）
    - `Wx`（微信支付）
    - `CBAlipay`（支付宝移动支付 - 境外支付）
    - `AlipayNoUTDID`（支付宝移动支付，独立 `UTDID.framework`）
    - `Wx`（微信 app 支付）
    - `QQWallet`（QQ 钱包 app 支付）
    - `UnionPay`（银联手机支付）
    - `ApplePay`
    - `CmbWallet`（招行一网通）
    - `BfbWap`（百度钱包 Wap 支付）
    - `Yeepay`（易宝支付 Wap 支付）
    - `Jdpay`（京东支付 Wap 支付）
    - `CcbPay`（建设银行 app 支付）
    - `Agreement`（带扣签约）
    - `Cmpay`（和包支付）
    - `Lakala`（拉卡拉 `alipay_app_lakala`, `wx_app_lakala`）
    - `Chinaums`（银联商务）

    例如：

    ```ruby
    pod 'Pingpp/Alipay', '~> 2.2.35'
    pod 'Pingpp/Wx', '~> 2.2.35'
    pod 'Pingpp/UnionPay', '~> 2.2.35'
    ```

    代扣签约

    ```ruby
    pod 'Pingpp/Agreement', '~> 2.2.35'
    ```

2. 运行 `pod install`
3. 从现在开始使用 `.xcworkspace` 打开项目，而不是 `.xcodeproj`
4. 添加 URL Schemes：在 Xcode 中，选择你的工程设置项，选中 "TARGETS" 一栏，在 "Info" 标签栏的 "URL Types" 添加 "URL Schemes"，如果使用微信，填入所注册的微信应用程序 id，如果不使用微信，则自定义，允许英文字母和数字，首字母必须是英文字母，建议起名稍复杂一些，尽量避免与其他程序冲突。如果使用 CcbPay，格式为 `comccbpay+商户代码(即 MERCHANTID 字段值)+商户自定义的标示`，示例：`comccbpay105320148140002myapp`。
5. 2.1.0 及以上版本，可打开 Debug 模式，打印出 log，方便调试。开启方法：`[Pingpp setDebugMode:YES];`。
6. 2.2.8 及以上版本，可选择是否在 WAP 渠道中支付完成后，点击“返回商户”按钮，直接关闭支付页面。开启方法：`[Pingpp ignoreResultUrl:YES];` 。
7. 使用银联商务时，最好使用单独的 URL Scheme(使用微信支付时除外)，并在调用 `createPayment` 方法时，通过 `appURLScheme` 参数传入。

### <h3 id='3.2'>手动导入</h3>

1. 获取 SDK  
下载 SDK, 里面包含了 lib 文件夹和 example 文件夹。lib 文件夹里面是 SDK 的文件。
2. 依赖 Frameworks：

    必需：

    ```
    CFNetwork.framework
    SystemConfiguration.framework
    Security.framework
    QuartzCore.framework
    CoreTelephony.framework
    libc++.tbd
    libz.tbd
    libsqlite3.0.tbd
    CoreMotion.framework
    CoreLocation.framework
    WebKit.framework
    CoreGraphics.framework
    ```

    Apple Pay 所需：

    ```
    PassKit.framework
    ```

3. 如果不需要某些渠道，删除 `lib/Channels` 下的相应目录即可。
4. 添加 URL Schemes：在 Xcode 中，选择你的工程设置项，选中 "TARGETS" 一栏，在 "Info" 标签栏的 "URL Types" 添加 "URL Schemes"，如果使用微信，填入所注册的微信应用程序 id，如果不使用微信，则自定义，允许英文字母和数字，首字母必须是英文字母，建议起名稍复杂一些，尽量避免与其他程序冲突。
5. 添加 Other Linker Flags：在 Build Settings 搜索 Other Linker Flags ，添加 `-ObjC`。
6. 2.1.0 及以上版本，可打开 Debug 模式，打印出 log，方便调试。开启方法：`[Pingpp setDebugMode:YES];`。
7. 2.2.8 及以上版本，可选择是否在 WAP 渠道中支付完成后，点击“返回商户”按钮，直接关闭支付页面。开启方法：`[Pingpp ignoreResultUrl: YES];` 。

## <h2 id='4'>接入方法</h2>

### <h3 id='4.1'>使用 Ping++ 标准版 SDK</h3>

```
#import <Pingpp.h>
```

Objective-C

``` objective-c
// data 表示 Charge/Order/Recharge 的 JSON 字符串
[Pingpp createPayment:data
       viewController:viewController
         appURLScheme:URLScheme
       withCompletion:^(NSString *result, PingppError *error) {
    if ([result isEqualToString:@"success"]) {
        // 支付成功
    } else {
        // 支付失败或取消
        NSLog(@"Error: code=%lu msg=%@", error.code, [error getMsg]);
    }
}];
```

Swift

```swift
// 微信支付 SDK 需要设置 Universal Links
Pingpp.setUniversalLink("https://example.com/sample/")

Pingpp.createPayment(data as NSObject, viewController: viewController, appURLScheme: URLScheme) { (result: String?, error: PingppError?) in
    if error != nil {
        // 处理错误
    }
    // 处理结果
}
```

> Universal Links 配置方法请参考 [Apple 官方文档](https://developer.apple.com/documentation/uikit/inter-process_communication/allowing_apps_and_websites_to_link_to_your_content/enabling_universal_links)及[微信相关文档](https://developers.weixin.qq.com/doc/oplatform/Mobile_App/Access_Guide/iOS.html)

#### 招行相关方法

##### 控制支付方式

自动判断，安装招行 app 时通过打开 app 支付，未安装时通过 WebView 打开 H5 页面支付。

```swift
Pingpp.setCmbPayMethod(PingppCmbPayMethod.auto)
```

仅通过打开 app 支付，要求必须安装有招行 app。

```swift
Pingpp.setCmbPayMethod(PingppCmbPayMethod.appOnly)
```

仅通过 WebView 打开 H5 页面支付。

```swift
Pingpp.setCmbPayMethod(PingppCmbPayMethod.h5Only)
```

##### 设置招行 H5 地址

> 生产环境不需要设置。仅在招行要求在招行的测试环境执行测试案例时使用。

```swift
// 参数 1，Bool，是否启用招行测试地址；
// 参数 2，String，招行测试 H5 地址。仅参数 1 为 true 时生效。如果参数 2 传 nil，则会使用默认测试地址。
Pingpp.setCmbEnv(true, url: nil)
Pingpp.setCmbEnv(true, url: "https://...")
```

### <h3 id='4.2'>接收并处理交易结果</h3>

> alipay_app_lakala 渠道没有支付结果回调。

##### 渠道为支付宝但未安装支付宝钱包时，交易结果会在调起插件时的 Completion 中返回。渠道为微信、支付宝(安装了支付宝钱包)、银联或者测试模式时，请实现 UIApplicationDelegate 的 - application:openURL:options: 方法:

``` objective-c
- (BOOL)application:(UIApplication *)app
            openURL:(NSURL *)url
            options:(NSDictionary *)options {
    BOOL canHandleURL = [Pingpp handleOpenURL:url withCompletion:nil];

    return canHandleURL;
}
```

```swift
func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
    if Pingpp.handleOpen(url, withCompletion: nil) {
        return true;
    } else if Pingpp.handleAgreementURL(url, withCompletion: nil) {
        return true;
    } else {
        // 其他逻辑
    }

    return false
}

// 微信使用 Universal Links 的情况，需要该方法
func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
    var ret = Pingpp.handleContinue(userActivity, withCompletion: nil)
    if !ret {
        // 其他逻辑
        // ret = 其他处理
    }

    return ret
}
```

### <h3 id='4.4'>使用代扣签约接口</h3>

Podfile 添加

```ruby
pod 'Pingpp/Agreement', '~> 2.2.35'
```

通过服务端获取 `agreement` 对象后，调用接口

Objective-C

```objective-c
[Pingpp signAgreement:agreement
       withCompletion:^(NSString *result, PingppError *error) {
    // 处理结果/错误
}];
```

Swift

```swift
Pingpp.signAgreement(agreement) { (result: String?, error: PingppError?) in
    // 处理结果/错误
}
```

#### 处理签约结果

Objective-C

``` objective-c
- (BOOL)application:(UIApplication *)app
            openURL:(NSURL *)url
            options:(NSDictionary *)options {
    if ([Pingpp handleOpenURL:url withCompletion:nil]) {
        // 这个是处理支付回调的
        return YES;
    } else if ([Pingpp handleAgreementURL:url withCompletion:nil]) {
        // 这个是处理签约回调的，签约回调，目前前端只会在 completion 返回 "unknown"，需要通过服务端查询实际结果
        return YES;
    }

    return NO;
}
```

Swift

``` swift
func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
    if Pingpp.handleOpen(url, withCompletion: nil) {
        return true;
    } else if Pingpp.handleAgreementURL(url, withCompletion: nil) {
        return true;
    } else {
        // 其他逻辑
    }

    return false
}

// 微信使用 Universal Links 的情况，需要该方法
func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
    var ret = Pingpp.handleContinue(userActivity, withCompletion: nil)
    if !ret {
        // 其他逻辑
        // ret = 其他处理
    }

    return ret
}
```

## <h2 id='5'>额外配置</h2>

1. 如果需要使用支付宝和微信等跳转至渠道 app 的渠道，需要在 `Info.plist` 添加以下代码：

    ```xml
    <key>LSApplicationQueriesSchemes</key>
    <array>
        <string>weixinULAPI</string>
        <string>weixin</string>
        <string>wechat</string>
        <string>alipay</string>
        <string>alipays</string>
        <string>mqq</string>
        <string>mqqwallet</string>
        <string>uppaysdk</string>
        <string>uppaywallet</string>
        <string>uppayx1</string>
        <string>uppayx2</string>
        <string>uppayx3</string>
        <string>cmbmobilebank</string>
        <string>mbspay</string>
        <string>cmpay</string>
    </array>
    ```
2. 如果 App 需要访问 `http://`，需要在 `Info.plist` 添加如下代码，或者根据需求添加 `NSExceptionDomains`：

    ```xml
    <key>NSAppTransportSecurity</key>
    <dict>
        <key>NSAllowsArbitraryLoads</key>
        <true/>
    </dict>
    ```
3. 如果编译失败，遇到错误信息为：

    ```
    XXXXXXX does not contain bitcode. You must rebuild it with bitcode enabled (Xcode setting ENABLE_BITCODE), obtain an updated library from the vendor, or disable bitcode for this target.
    ```
    请到 Xcode 项目的 `Build Settings` 标签页搜索 bitcode，将 `Enable Bitcode` 设置为 `NO`。  
4. 招行一网通 app 支付配置招行分配的 `URL Schemes`，并调用方法 `[Pingpp setCmbURLScheme:@"..."];`，该 `URL Scheme` 不要与其他支付方式共用，否则会影响前端支付结果返回；
5. 判断设备上是否已经安装招商银行 app 的方法：`[Pingpp isCmbWalletInstalled]`。
6. 使用 CcbPay 请先确保用户手机安装了建设银行 app。判断设备上是否已经安装建设银行 app 的方法：`[Pingpp isCcbAppInstalled]`。
7. 使用 CcbPay 的情况，需要在 `Info.plist` 的 `NSAppTransportSecurity` 字段添加相应的 `NSExceptionDomains`。

    ```xml
    <key>NSExceptionDomains</key>
    <dict>
        <key>ibsbjstar.ccb.com.cn</key>
        <dict>
            <key>NSExceptionAllowsInsecureHTTPLoads</key>
            <true/>
            <key>NSExceptionRequiresForwardSecrecy</key>
            <false/>
            <key>NSIncludesSubdomains</key>
            <true/>
        </dict>
    </dict>
    ```

## <h2 id='6'>注意事项</h2>

### * 如果不需要 Apple Pay，请不要导入 Apple Pay 的静态库。以免提交到 App Store 时审核不通过。

### * 如果 集成 Apple Pay 测试时请注意 以下几点

1. 测试时必须是真机进行测试
2. 检查相关的证书是否正确
3. 手机必须是 iPhone 6 以上
4. 支付时必须绑定了真实的银行卡且有充足的余额

### * 请勿直接使用客户端支付结果作为最终判定订单状态的依据，支付状态以服务端为准!!!在收到客户端同步返回结果时，请向自己的服务端请求来查询订单状态。

### * 支付宝渠道发生包冲突的情况

使用阿里百川等阿里系的 SDK 时，可能会出现冲突，请尝试使用 `pod 'Pingpp/AlipayNoUTDID'` 代替 `pod 'Pingpp/Alipay'`。

因为 `CocoaPods` 的限制，只有编译通过的才能上传成功，所以使用时，需要删除项目中已经存在的 `UTDID.framework`。

**关于如何使用 SDK 请参考 [开发者中心](https://www.pingxx.com/docs/index) 或者 [example](https://github.com/PingPlusPlus/pingpp-ios/tree/master/example) 文件夹里的示例。**
