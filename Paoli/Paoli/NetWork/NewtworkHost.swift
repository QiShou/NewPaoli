//
//  NewtworkHost.swift
//  HeyZhimaProduct
//
//  Created by zlp001 on 2017/9/7.
//  Copyright © 2017年 zlp001. All rights reserved.
//

import Foundation

public enum HostType {
    
    case release                     //正式发布环境

    case develop                   //开发环境
    
    case test                     //测试环境
}

public enum HostUrl {
    
    case H5                     //正式发布环境

}

extension HostType {
    
    static let isChange : Bool = false
    
    
    /** 网络环境 */
    static func type() -> HostType {
        
        #if DEBUG
        
        return .develop
        
        #elseif PRODUCT
        
        return .release
        
        #elseif TEST
        
        return .test
        
        #else
        
        return .release
        
        #endif
    }
    
    var baseURLStr : String  {
    
        switch self {
            
        case .release:
            
            return "http://43.240.127.2:7443"
        case .test:

            
            return "https://gateway-test.itianding.com"
//            return "https://bop-gateway-uat.itianding.com"

            
        case .develop:
            
//           return "http://192.168.18.108:8004"
            
            return "https://gateway-test.itianding.com"

//            return "https://bop-gateway-uat.itianding.com"

        }
    
    }

    var domain :String {
        
       switch self {
        
       case .release:
           
           return "https://tpos.tftpay.com"
           
       case .test:

           return "https://tpos.tftpay.com"

       case .develop:
           
           return "http://192.168.10.109"
//           return "http://192.168.4.54:9528"


       }
    }
    
    
    var webBaseUrl :String {
        
       switch self {
        
       case .release:
           
           return "https://tpos.tftpay.com"
           
       case .test:

           return "https://owner-test.itianding.com"

       case .develop:
           
           return "https://owner-test.itianding.com"
//           return "https://ownerapp-uat.itianding.com"
           return "http://192.168.4.54:9528"
           
       }
    }

    var appID : String {
        
        return ""
    }
    
    var LICENCE : String {
        
        switch self {
        case .release:
         break
        default:
            break
        }
        return ""       
    }
}


