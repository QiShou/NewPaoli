//
//  ComonWebViewController.swift
//  TFTMPOS
//
//  Created by wangxb on 2020/4/29.
//  Copyright © 2020 tftpay. All rights reserved.
//

import UIKit
import WebKit

class ComonWebViewController: PLBaseViewViewController, WKNavigationDelegate, WKUIDelegate {
    
    let urlAbsoluteString = (shareSmallProgram: "zjh://?action=shareSmallProgram",
                             close:"zjh://?action=close",
                             shareToWechat:"zjh://?action=shareToWechat",
                             shareWXWorkProgram:"zjh://?action=shareWXWorkProgram",
                             closes:"zjh://close",
                             rightBtnAction:"zjh://?action=rightNavBarButton",//
                             callPhone:"zjh://?action=callPhone",//电话号码
                             propertyService:"zjh://?action=property_service", //客服首页按钮点击
                             changeVillage:"zjh://?action=change_village",//修改社区
                             newPage: "zjh://?action=new_page",//打开新界面
                             error:"zjh://?action=error&errorCode", //错误类型
                             deviceInspect:"zjh://?action=device_inspect" ,//设备巡保
                             shareDownUrl:"zjh://?action=down_file_and_share" //下载分享
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
        
        let view = WKWebView(frame:self.view.bounds, configuration: configura)
    
        view.uiDelegate = self
        view.navigationDelegate = self
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
}


extension ComonWebViewController {
    
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
        
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
    }
    
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        let urls = navigationAction.request.url!
        let urlString = urls.absoluteString

        print(urlString)
        
      if urlString.hasPrefix(urlAbsoluteString.close) || urlString.hasPrefix(urlAbsoluteString.closes) { //关闭界面
            navigationController?.popViewController(animated: true)
            
        decisionHandler(.cancel)
        return

        }
        
        isShowNav = true
        
        decisionHandler(.allow)
        
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        
        decisionHandler(.allow)
        
    }
}
