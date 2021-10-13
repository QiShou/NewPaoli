//
//  Request.swift
//  Paoli
//
//  Created by 1 on 2021/9/26.
//

import UIKit
import Moya



enum NetworkError : Error {
    case noElements
}


/* 网络请求结果处理 */
enum RequestResult<T> {
    
    case responseObject(model : T)                          //请求成功  返回数据是对象
    case responseArray(dataArr : [T])                       //请求成功  返回数据是数组
    case responseNoData                                     //请求成功  没有返回数据
    case responseFail(errcode : NSInteger,msg : String)     //返回结果错误  errcode 返回的错误码 msg 返回的提示语
    case responseNoMap(data : JSON)                          //返回结果 不解析 或者是解析错误   data是原数据
    ///请求错误
    case requestFail
}


public protocol Request: TargetType {
    var parameters:[String:Any]{get}
    func parametersHandle() -> [String:Any]
    
}

public extension Request{
    var baseURL: URL {
        return URL(string: HostType.type().baseURLStr)!
    }
    
    func parametersHandle() -> [String : Any] {
        
        return parameters
    }
    
    
    var task: Task {
        
        if method == .post {
            
            return Task.requestParameters(parameters: parametersHandle(), encoding: JSONEncoding.default)
            
            if parametersHandle().count == 0 {
                
                return Task.requestParameters(parameters: parametersHandle(), encoding: JSONEncoding.default)
            }
            
            var paraFormData : [Moya.MultipartFormData] = []
            
            for e in parametersHandle() {
                
                let contentData = "\(e.value)".data(using: .utf8)
                let contentFormData = MultipartFormData.init(provider: .data(contentData!), name: e.key)
                paraFormData.append(contentFormData)
            }
            
            return Task.uploadMultipart(paraFormData)
            
        }
        
        return Task.requestParameters(parameters: parametersHandle(), encoding: URLEncoding.default)
 
    }
    
    var method: Moya.Method {
        return .post
    }
    
    var sampleData: Data {
        return Data.init()
    }
    
    var headers: [String: String]? {
        
        let dis = ["sys" : "ios","version" : Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String,"Authorization":"\(AGUserDefaults().getUserDefaults(AGToken) ?? "")","client":"OWNERAPP"]
        
        return dis
    }
    
}
