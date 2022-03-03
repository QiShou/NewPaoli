//
//  ComonWebViewController.swift
//  TFTMPOS
//
//  Created by wangxb on 2020/4/29.
//  Copyright © 2020 tftpay. All rights reserved.
//

import UIKit
import WebKit
import SwiftyJSON
import CoreMedia

struct URLPath {
    let urlPathString = (serviceOrder:"/#/serviceOrder",createWorkOrder:"/#/createWorkOrder",userApplyRecord:"#/userApplyRecord",preCharge:"/#/preCharge",utilityBill:"/#/utilityBill",collectionSign:"/#/collectionSign",home:"/#/home",my:"/#/my")

    func prarm(_ dict : Dictionary<String, String>) -> String {
        var prarmStr = ""
        guard dict.keys.count != 0 else {
            return ""
        }
        for (key,value) in dict {
            prarmStr = prarmStr + key + "=" + value + "&"
        }
        prarmStr = "?"+prarmStr
        prarmStr.removeLast()
        return prarmStr
    }
}


class ComonWebViewController: PLBaseViewViewController, WKNavigationDelegate, WKUIDelegate {
    
    let urlAbsoluteString = (shareSmallProgram: "zjh://?action=shareSmallProgram",
                             close:"zjh://?action=close",
                             shareToWechat:"zjh://?action=shareToWechat",
                             shareWXWorkProgram:"zjh://?action=shareWXWorkProgram",
                             closes:"zjh://close",
                             rightBtnAction:"zjh://?action=rightNavBarButton",//
                             callPhone:"zjh://?action=callPhone",//电话号码
                             tel:"tel://",
                             propertyService:"zjh://?action=property_service", //客服首页按钮点击
                             changeVillage:"zjh://?action=change_village",//修改社区
                             newPage: "zjh://?action=new_page",//打开新界面
                             error:"zjh://?action=error&errorCode", //错误类型
                             deviceInspect:"zjh://?action=device_inspect" ,//设备巡保
                             shareDownUrl:"zjh://?action=down_file_and_share", //下载分享
                             javaPay:"zjh://?action=JavaPay",
                             singout:"zjh://?action=signOut",
                             hiddenTab:"zjh://?action=hidden_tab",
                             showTab:"zjh://?action=show_tab",
                             changeProject:"zjh://?action=change_project",
                             scanCode:"zjh://?action=scan_code"
                      
                            )
    var isShowNav:Bool?
    {
        willSet {
            self.navigationController?.isNavigationBarHidden = newValue ?? false
        }
    }
    lazy var webView :WKWebView = {
        
        var js = ""
        js.append("document.documentElement.style.webkitUserSelect='none';")
        js.append("document.documentElement.style.webkitTouchCallout='none';")
        
        let uscript = WKUserScript.init(source: js, injectionTime: .atDocumentStart, forMainFrameOnly: true)
        
        let configura = WKWebViewConfiguration()
        configura.userContentController .addUserScript(uscript)
        
        let view = WKWebView(frame:CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight), configuration: configura)
    
        view.uiDelegate = self
        view.navigationDelegate = self
        return view
    }()
    lazy var tabV : UIView = {
         
        let view = UIView(frame: CGRect(x: 0, y: 0, width: (self.tabBarController?.tabBar.bounds.width)!, height: (self.tabBarController?.tabBar.bounds.height)!))
        
        view.backgroundColor = UIColor.init(white: 0, alpha: 0.4)
         return view
     }()
    
    var bridge : WKWebViewJavascriptBridge?
    
    func bridges()  {
        
        bridge = WKWebViewJavascriptBridge(for: webView)
        bridge?.setWebViewDelegate(self)
        bridge?.registerHandler("getToken", handler: { ( data, responseCallback) in
            
            DispatchQueue.main.async {
                var token = "\(AGUserDefaults().getUserDefaults(AGToken) ?? "")"
                if token.contains("bearer ") {
                    token = token.replacingOccurrences(of: "bearer ", with: "")
                }
                responseCallback!(token)
            }
        })
    }
    
    var url :URL
    init(url:URL,title:String){
        self.url = url
        super.init(nibName: nil, bundle: nil)
        self.title = title
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.navigationController?.isNavigationBarHidden = isShowNav ?? false
        
        self.automaticallyAdjustsScrollViewInsets = false
        registerNotifications()

        self.view.addSubview(webView)
        webView.snp.makeConstraints { (maker) in
            
            maker.top.equalToSuperview()
            maker.left.equalToSuperview()
            maker.right.equalToSuperview()
            maker.bottom.equalToSuperview()
        }
    
        
//        url = URL(string:"http://192.168.4.54:9529/#/createWorkOrder?pd=iOS&projectId=8")!
//        url = URL(string: " http://192.168.4.54:9529/#/createWorkOrder?pd=iOS&projectId=8")

        let request = URLRequest(url: self.url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 20.0)
        webView.load(request)
        
        bridges()
        print(url)
    }
   
    deinit {
        self.bridge?.reset()
        self.bridge = nil
    }
    
    func registerNotifications()  {
        
        NotificationCenter.default.addObserver(self, selector: #selector(handlePingURL(_:)), name: NSNotification.Name.init(rawValue: KNotificationNamePingPPURL), object: nil)
    }
    
    @objc func handlePingURL(_ result:Notification?)  {
        
        
        guard let dict = result?.userInfo as? Dictionary<String,String> else { return  }
        
        bridge?.callHandler("handlePayResult", data: dict["result"], responseCallback: { callBack in
            
            print(callBack)
        })
    }
    
    func removeNotification(_ name:String){
        
        NotificationCenter.default.removeObserver(self, name:Notification.Name.init(name) , object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        removeNotification(KNotificationNamePingPPURL)
    }
}


extension ComonWebViewController {
    
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
    
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        isShowNav = true
    }
    
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        let urls = navigationAction.request.url!
        let urlString = urls.absoluteString

        print(urlString)
        
        if urlString.hasPrefix(urlAbsoluteString.close) || urlString.hasPrefix(urlAbsoluteString.closes) { //关闭界面
            isShowNav = false
            navigationController?.popViewController(animated: true)
            decisionHandler(.cancel)
        } else if (urls.scheme == "tel"){
//            [NSString stringWithFormat:@"telprompt://%@", resourceSpecifier];
//            let tel = "telprompt://" + urls.query
//            [[UIApplication sharedApplication] openURL:
            
            let arr = urlString.components(separatedBy: ":")
            open(scheme:"telprompt://" + arr.last!)
            decisionHandler(.cancel)
        } else if (urlString.hasPrefix(urlAbsoluteString.javaPay)) {
            
            let arr = urlString.components(separatedBy: "\(urlAbsoluteString.javaPay)+&")
            guard let pingPP = arr.last , pingPP.contains("PingParam=") else {
                decisionHandler(.cancel)
                return }
           let arr1 = pingPP.components(separatedBy: "PingParam=")
          let json = JSON.init(arr1.last?.removingPercentEncoding ?? "")
            creatPingPayment(change: json.rawValue as! NSObject) { s in
                print("creatPingPayment:\(s)")
            }
            decisionHandler(.cancel)
        } else if (urlString.hasPrefix(urlAbsoluteString.shareToWechat)){
            var pramDict = stringConvertDicForShare(urlString)
            print("asdfasdf \(pramDict)")
            shareWx(pramDict)
            decisionHandler(.cancel)
        } else if (urlString.hasPrefix(urlAbsoluteString.singout)) {
            let con = PLMeViewController ()
            self.navigationController?.pushViewController(con, animated: true)
            decisionHandler(.cancel)
         } else if urlString.hasPrefix(urlAbsoluteString.newPage) {
            
            let str = prarmStringToDict(absoluteString: urlString, shemeUrl: urlAbsoluteString.newPage, pathStr: "url")
            if str == "" {
                decisionHandler(.cancel)
            } else {
                
                let url = URL(string: str)!
                
                let con = ComonWebViewController(url: url, title: "")
                con.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(con, animated: true)
                decisionHandler(.cancel)
            }
        } else if urlString.hasPrefix(urlAbsoluteString.hiddenTab) {
            showWindow()
            decisionHandler(.cancel)
        } else if urlString.hasPrefix(urlAbsoluteString.showTab) {
            hideWindow()
            decisionHandler(.cancel)
        }
        else if urlString.hasPrefix(urlAbsoluteString.scanCode) {
            hideWindow()
            decisionHandler(.cancel)
        }
        else {
            decisionHandler(.allow)
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        
        decisionHandler(.allow)
        
    }
    
}


extension ComonWebViewController {
    
    @objc func prarmStringToDict(absoluteString:String, shemeUrl:String, pathStr:String) -> String{
        
        let urls = absoluteString.removingPercentEncoding!
        print(urls)
    
        let startIndex = urls.index(shemeUrl.endIndex, offsetBy: 0)
        let newStr = String(urls[startIndex..<urls.endIndex])
        print("newStr \(newStr)")
        var arr = [String]()
        if newStr.contains("\(pathStr)=") {
            arr = newStr.components(separatedBy: "&\(pathStr)=")
        }
        return arr.last ?? ""
    }
    
    
    
    //分解微信小程序分享的URL
       @objc func sharePrarmDStringToDict(absoluteString:String , shemeUrl:String ) -> Dictionary<String, String> {
    //    display.removingPercentEncoding (ios10.0之后)
        let urls = absoluteString.removingPercentEncoding!
        print(urls)
        var mutDict = Dictionary<String, String>()
        let startIndex = urls.index(shemeUrl.endIndex, offsetBy: 0)
        let newStr = String(urls[startIndex..<urls.endIndex])
            print("newStr \(newStr)")
            let arr = newStr.components(separatedBy: "&")
    
            print(arr)
        for i in arr {
            if i.contains("path=") || i.contains("htid=") || (i.contains("url=") && !i.contains("jump_url=") && !i.contains("pathUrl")) || i.contains("attname=") || (i.contains("jump_url") && i.contains("curProjectInfo")){
                let tempArr = i.components(separatedBy: "=")
                if  tempArr.count >= 3 {
                    mutDict[tempArr[0]] = String(format: "%@=%@", tempArr[1],tempArr[2])
                }
            } else {
                if i.contains("=") {
                    let tempArr = i.components(separatedBy: "=")
                    mutDict[tempArr[0]] = tempArr[1]
                }
            }
        }
            return mutDict
        }
    
    func shareParamDict(_ dict:Dictionary<String,String>, urlStr: String)->Dictionary<String,String> {
        
        
        var mutDict = Dictionary<String,String>()
        var str = String()
        if urlStr.contains("jump_url") {
            
            for (key,value) in dict {
                
                if key == "title" || key == "description" {
                    mutDict[key] = value
                    
                } else {
                    if key == "jump_url" {
                        str = value + str
                    } else {
                        
                        str = str + "&" + key + "=" + value
                    }
                }
                
            }
            
            mutDict["jump_url"] = str
        }
     
        return mutDict
    }
    
    func stringConvertDicForShare(_ urlString:String)->Dictionary<String, String>{
//        let urls = urlString.removingPercentEncoding!
        var dict = Dictionary<String,String>()
        
        let arr1 = urlString.components(separatedBy: "jump_url=")
        let arr2 = arr1.last?.components(separatedBy: "&title=")
        
        dict["jump_url"] = arr2?.first
        
        let arr3 = arr2?.last?.components(separatedBy: "&description=")
        dict["title"] = arr3?.first?.removingPercentEncoding
        
        let arr4 = arr3?.last?.components(separatedBy: "&imageUrl=")
        dict["description"] = arr4?.last?.removingPercentEncoding
        
        return dict
    }
    
    func shareWx(_ dict:Dictionary<String,String>) {
    
        guard let urlStr = dict["jump_url"] , !urlStr.isEmpty else {
            return
        }
        
        let webPageObj = WXWebpageObject()
        
        webPageObj.webpageUrl = urlStr
        
        let messgae = WXMediaMessage()
        messgae.title = dict["title"] ?? "田丁"
        messgae.description = dict["description"] ?? "来自田丁的消息，请点击查看"
        messgae.setThumbImage(UIImage(named: "share_icon")!)
        messgae.mediaObject = webPageObj
        
        let req = SendMessageToWXReq()
        req.bText = false
        req.message = messgae
        req.scene = 0
        WXApi.send(req) { success in
            
        }
          
    }
}
extension ComonWebViewController {
   
    func showWindow() {
        self.tabBarController?.tabBar.addSubview(tabV)
    }
    func hideWindow() {
        guard tabV != nil else {
            return
        }
        tabV.removeFromSuperview()
    }
}

func open(scheme: String) {
    if let url = URL(string: scheme) {
        if#available(iOS 10, *) {
            UIApplication.shared.open(url, options: [:],
                                      completionHandler: { (success)in
                print("Open \(scheme): \(success)")
            })
        }else{
            let success = UIApplication.shared.openURL(url)
            print("Open \(scheme): \(success)")
        }
    }
}

func creatPingPayment(change:NSObject,results:@escaping (String?)->Void)  {
    Pingpp.createPayment(change, appURLScheme: PayWxAppId) {(result:String?, error:PingppError?) in
        
        results(result)
        
    }
}


