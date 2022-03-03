//
//  NetworkClient.swift
//  ReviewDemo
//
//  Created by zlp001 on 2017/9/7.
//  Copyright © 2017年 zlp001. All rights reserved.
//

import Foundation


struct NullData :HandyJSON {
    
    
}

/** 网络请求等待视图显示情况 */
public enum NetworkHUD : NSInteger {
    
    case background                 = 0      //不锁屏，不提示
    case msg                        = 1      //不锁屏，只要msg不为空就提示
    case error                      = 2      //不锁屏，提示错误信息
    case lockScreen                 = 3      //锁屏
    case lockScreenAndMsg           = 4      //锁屏，只要msg不为空就提示
    case lockScreenAndError         = 5      //锁屏，提示错误信息
    case lockScreenButNavWithMsg    = 6      //锁屏，但是导航栏可以操作，只要msg不为空就提示
    case lockScreenButNavWithError  = 7      //锁屏，但是导航栏可以操作，提示错误信息
    case lockScreenButNavWithNoMsg  = 8      //锁屏，但是导航栏可以操作，没有提示语；
    case lockScreenButNoLoading     = 9      //锁屏，没有提示语,没有菊花
}


class NetworkClient {
    
    
    static let password : String = "01696d2b4be916cbe06b3c4c6a30e3f8"
    
    static let isTestnet : Bool = true
    
    public static let `default` = { NetworkClient() }()
    
    /// 开始请求
    ///
    /// - Parameters:
    ///   - r: 请求参数
    ///   - mType: model 类型  无需处理数据时 用 NullData
    ///   - target: hud显示的视图
    ///   - networkHUD: hud
    ///   - complete: 成功回调
    ///   - fail: 错误回调
    func sent<R : Request  , M : HandyJSON>(_ r: R, mType : M.Type,target: UIView? = nil, networkHUD: NetworkHUD, requestComplete: ((RequestResult<M>) -> Void)?) {
        
        networkHUDHandle(target: target, networkHUD: networkHUD)
        
        print(r.baseURL.absoluteString + r.path + "\(r.headers ?? [:])")
        
        let provider = MoyaProvider<R>()
    
        print(r.parameters)
        provider.request(r) { (result) in
            
            var requestResult : RequestResult<M> = .requestFail
            
            switch result {
                
            case .success(let response):
                
                var responseData : [String : Any]
                
                do {
                    
                    responseData = try JSON.init(data: response.data).dictionaryObject ?? ["code":"404"]
                    
                }catch {
                    
                    responseData = ["code": response.statusCode]
                }
                
                print(responseData)
                
                //                self.saveUserToken(httpResponse: response.response)
                
                self.networkHUDHandle(target: target, networkHUD: networkHUD, responseData: responseData)
                
                self.validUserToken(response: responseData)

                requestResult = self.handleResponseData(mType: mType, responseData: responseData)
 
            case .failure(let error):
                
                print(error)
                print("错误连接：\(r.baseURL.absoluteString)\(r.path)")
                print("参数:\(r.parameters)")
                
                
                requestResult = .requestFail
                
                self.networkHUDHandle(target: target, networkHUD: networkHUD, responseData: ["code" : "404","message" :  "Network traffic anomaly. Please check the network connection."])
                
            }
            
            if requestComplete != nil {
                
                requestComplete!(requestResult)
                
            }
        }
        
        
    }
    
    func sent<R : Request  , M : HandyJSON>(_ r: R, mType : M.Type,keyStr : String, requestComplete: ((RequestResult<M>) -> Void)?) {
        
        let provider = MoyaProvider<R>()
        
        provider.request(r) { (result) in
            
            var requestResult : RequestResult<M> = .requestFail
            
            
            switch result {
                
            case .success(let response):
                
                var responseData : [String : Any]
                
                do {
                    
                    responseData = try JSON.init(data: response.data).dictionaryObject ?? ["code":"404"]
                    
                    guard keyStr.count > 0 else {
                        
                        requestResult = .responseNoMap(data: JSON.init(responseData))
                        requestComplete?(requestResult)
                        return
                    }
                    
                    let resultData = responseData[keyStr]
                    
                    guard resultData != nil else {
                        
                        requestComplete?(requestResult)
                        return
                    }
                    
                    
                    let jsonData = JSON.init(resultData!)
                    
                    if mType == NullData.self  {
                        
                        requestResult = .responseNoMap(data: jsonData)
                    }
                    
                    if let dataObj : [String : Any] = jsonData.dictionaryObject {
                        
                        if mType != NullData.self {
                            
                            let aModel : M = mType.deserialize(from: dataObj)!
                            
                            requestResult = .responseObject(model: aModel)
                        }
                    }
                    
                    if let dataArr : [Any] = jsonData.arrayObject  {
                        
                        if mType != NullData.self {
                            
                            let models : [M] = [M].deserialize(from: dataArr) as! [M]
                            
                            requestResult = .responseArray(dataArr : models)
                        }
                        
                    }
                    
                    
                }catch {
                    
                    responseData = ["code": response.statusCode]
                }
                
            case .failure(let error):
                
                requestResult = .requestFail
            }
            
            if requestComplete != nil {
                
                requestComplete!(requestResult)
                
                
            }
        }
    }
    
    /* 请求之前 NetworkHUD 处理*/
    func networkHUDHandle(target : UIView?,networkHUD : NetworkHUD,msg : String? = nil){
        
        guard networkHUD.rawValue > 2 else {
            
            return
        }
        
        SVProgressHUD.show()

    }
    
    /* 请求之后 NetworkHUD 处理 */
    func  networkHUDHandle(target : UIView?,networkHUD : NetworkHUD,responseData : [String : Any]){

        let data : JSON = JSON.init(responseData)
        
        let msg : String = data["message"].stringValue
        
        if networkHUD.rawValue > 2 {
            
            SVProgressHUD.dismiss()
        }
        
        switch networkHUD {
            
        //            没有提示语
        case .background,.lockScreen,.lockScreenButNavWithNoMsg,.lockScreenButNoLoading: break
            
        //           只要msg不为空就提示
        case .msg,.lockScreenAndMsg,.lockScreenButNavWithMsg:
            
            if msg.count > 0 {
                
                SVProgressHUD.showError(withStatus:msg)
            }
            
        //            提示错误信息
        case .error,.lockScreenAndError,.lockScreenButNavWithError:
            
            
            if responseData.keys.contains("code") {
                let code : Int = data["code"].intValue
                if code != 200 {
                    
                    if msg.count == 0 {
                        
                        SVProgressHUD.showError(withStatus: "操作失败！")
                        
                    }else{
                        
                        SVProgressHUD.showError(withStatus: msg)
                    }
                    
                }
            } else if responseData.keys.contains("state"){
                
                let state : Int = data["state"].intValue
                if state != 1 {
                    
                    if msg.count == 0 {
                        
                        SVProgressHUD.showError(withStatus: "操作失败！")
                        
                    }else{
                        
                        SVProgressHUD.showError(withStatus: msg)
                    }
                    
                }
            } else {
                
                SVProgressHUD.showError(withStatus: msg)
                
            }
           
        }
    }

    //    /* 登陆权限验证 */
    //    func loginVerify(responseData : [String : Any] ,url: String){
    //
    //        if accountLoginData.isLogin == false {
    //
    //            return
    //        }
    //
    //
    //        let code : NSInteger = JSON.init(responseData)["errcode"].intValue
    //
    //
    //        if code == 4000101 || code == 4000108 || code == 4000109 {
    //
    //            accountLoginData.cancelLogin()
    //            RouterManager.default.display(router: LoginManagerRouter.login, params: nil)
    //
    //            print(code)
    //            print(url)
    //            HUDManager.showCenterHUDAutoHide("个人信息已失效，请重新登陆")
    //        }
    //    }
    
    
    /* 数据处理 转成 RequestResult */
    func handleResponseData<M : HandyJSON>( mType : M.Type,responseData : [String : Any] ) -> RequestResult<M> {
        
        let jsonData : JSON = JSON.init(responseData)
        var requestResult : RequestResult<M> = .requestFail
        
        if jsonData["errorCode"].intValue == 0 {
            
            if mType == NullData.self {
                
                requestResult = .responseNoMap(data: jsonData["data"])
                
                return requestResult
            }
            
            if let dataObj : [String : Any] = jsonData["data"].dictionaryObject {
                
                let aModel : M = mType.deserialize(from: dataObj)!
                requestResult = .responseObject(model: aModel)
                return requestResult

            }
            
            if let dataArr : [Any] = jsonData["data"].arrayObject  {
                
                let models : [M] =  [M].deserialize(from: dataArr) as! [M]
                
                requestResult = .responseArray(dataArr : models)
                return requestResult

            }
            
            
        } else {
            
            requestResult = .responseFail(errcode : jsonData["errorCode"].intValue,msg : jsonData["message"].stringValue)
        }
        
        return requestResult
    }
    
}

extension NetworkClient {
    
    //    func saveUserToken (httpResponse : HTTPURLResponse?) {
    //
    //        if let resposne = httpResponse {
    //            print(resposne.allHeaderFields["refresh_token"])
    //            if let token = resposne.allHeaderFields["refresh_token"] as? String {
    //                _ = UserInfoModel.updateModel(by: token)
    //            }
    //        }
    //
    //    }
    
    
    /// 严重token
    ///
    /// - Parameter response: <#response description#>
    func validUserToken (response : [String : Any]) {
        
        let jsonDict = JSON(response)
        
        if jsonDict["errorCode"].stringValue == "512345" {
            UIApplication.shared.keyWindow!.rootViewController = UINavigationController(rootViewController: PLLoginViewController())

            AGUserDefaults().setUserDefaults("", AGToken)

//            HUDManager.showCenterHUDAutoHide(kLanguageManger.myLocalizedString(key: "Account login to expire, please log in again"))
//            NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: KAccountLogoutNotification), object: nil)
            // NotificationCenter.default.post(name: NSNotification.Name.init(KTokenDisabledNotification), object: nil)// TODO: - 在设置页处理重新登陆
        }
        
        
        
    }
    
}


// MARK: - RXSwift
extension NetworkClient {
    
//    static let disposeBag = DisposeBag()
    
    //    func send<R : Request,M : NSObject>(_ r: R, mType : M.Type?,target: UIView?, networkHUD: NetworkHUD) -> Single<RequestResult<M>> {
    //
    //
    //        return Observable<RequestResult<M>>.create { (observable) -> Disposable in
    //
    //            let provider = MoyaProvider<R>()
    //
    //            provider.request(<#T##target: Request##Request#>, completion: <#T##Completion##Completion##(Result<Response, MoyaError>) -> Void#>)
    //
    //            provider.request(r).subscribe(onSuccess: { (response) in
    //
    //
    //                var responseData : [String : Any] = JSON.init(data: response.data).dictionaryObject ?? ["code":"404"]
    //
    //                print(responseData)
    //
    //                self.networkHUDHandle(target: target, networkHUD: networkHUD, responseData: responseData)
    //
    //
    ////                if responseData["retData"] != nil {
    ////
    ////                    let content = self.decrypt(dataStr: responseData["retData"] as! String)
    ////
    ////                    responseData["retData"] = content
    ////
    ////                }
    //
    //
    ////                self.loginVerify(responseData: responseData,url : r.baseURL.absoluteString + r.path)
    //
    //                let requestResult : RequestResult<M> = self.handleResponseData(mType: mType, responseData: responseData)
    //
    //                observable.onNext(requestResult)
    //                observable.onCompleted()
    //
    //            }, onError: { (error) in
    //
    //                self.networkHUDHandle(target: target, networkHUD: networkHUD, responseData: ["status" : "404","msg" : "网络请求失败，请稍后再试"])
    //
    //
    //                print(error)
    //                print("错误连接：\(r.baseURL.absoluteString)\(r.path)")
    //                print("参数:\(r.parameters)")
    //
    //                observable.onNext(RequestResult<M>.requestFail)
    //                observable.onCompleted()
    //
    //
    //            }).addDisposableTo(NetworkClient.disposeBag)
    //
    //
    //
    //            return Disposables.create()
    //
    //        }.asSingle()
    //
    //    }
        
    class func sent(){
         
    }
    
}


//MARK: ----------------------加密解密协议--------------------------------------
public protocol EncryptHandle {
    
    /* 加密 */
    func encyptHandle(data: [String : Any]) -> [String : Any]
    
    /* 解密 */
    func decrypt(dataStr : String) -> Any?
}


extension EncryptHandle {
    
    
    //    /* 加密 */
    //    public func encyptHandle(data: [String : Any]) -> [String : Any] {
    //
    //        do {
    //
    //            let parasData : Data = try JSONSerialization.data(withJSONObject: data, options: JSONSerialization.WritingOptions.prettyPrinted)
    //
    //            let ciphertext = RNCryptor.encrypt(data: parasData, withPassword: password)
    //
    //            var parasStr : String = ciphertext.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters)
    //
    //
    //            /* 过滤换行和空格 */
    //            parasStr = parasStr.trimmingCharacters(in: CharacterSet.whitespaces)
    //            parasStr = parasStr.replacingOccurrences(of: "\r", with: "")
    //            parasStr = parasStr.replacingOccurrences(of: "\n", with: "")
    //
    //
    //            let nowDate : Date = Date()
    //
    //            let nowTime : NSInteger  = NSInteger(nowDate.timeIntervalSince1970)
    //
    //            let sig = parasStr + String(nowTime) + password
    //
    //
    //
    //            let md5Str = NSString.getMd5_32Bit_String(sig.sha1(), uppercase: false)
    //
    //
    //
    //            return ["timestamp" : String(nowTime) as AnyObject,"content" :parasStr as AnyObject,"sig" : md5Str as AnyObject]
    //
    //        }catch {
    //
    //            return [:]
    //        }
    //
    //
    //    }
    //
    //    /* 解密 */
    //    public func decrypt(dataStr : String) -> Any? {
    //
    //        let jsonData : Data? = Data.init(base64Encoded: dataStr, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)
    //
    //        if jsonData == nil {
    //
    //            return nil
    //        }
    //
    //        do {
    //
    //            let res : Data? = try RNCryptor.decrypt(data: jsonData!, withPassword: password)
    //
    //            if res == nil {
    //
    //                return nil
    //            }
    //
    //            let jsonDic : Any = try JSONSerialization.jsonObject(with: res!, options: JSONSerialization.ReadingOptions.mutableContainers)
    //
    //            return jsonDic
    //
    //        }catch {
    //
    //            return nil
    //        }
    //
    //    }
}




