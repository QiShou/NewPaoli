//
//  CommonService.swift
//  AgentTool
//
//  Created by Wxb on 2020/8/18.
//  Copyright . All rights reserved.
//

import Foundation

enum CommonService {
    
    case login(account:String,passWord:String)
    
}

extension CommonService :TargetType {
    
    var baseURL: URL {
        
        return URL.init(string: "")!
    }
    
    var path: String {
        
        switch self {
            
        case .login(_,_):
            return "accountService/login"
        default:
           return ""
        }
    }
    
    var method: Moya.Method {
        
        switch self {
        default:
            return .post
        }
       
    }
    
    var sampleData: Data {
        
        switch self {
            
        default:
            return "".data(using: .utf8)!
        }
        
    }
    
    var task: Task {
        
        switch self {
            
        default:
            return .requestPlain
        }
        
    }
    
    var headers: [String : String]? {
        
        return nil
    }
    
   
    
}
