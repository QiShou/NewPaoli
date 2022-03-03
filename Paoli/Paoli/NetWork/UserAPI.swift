//
//  UserAPi.swift
//  Paoli
//
//  Created by 1 on 2021/9/28.
//

//
//  UserApi.swift
//  BoxexWallet
//
//  Created by hjl on 2020/3/5.
//  Copyright © 2020 hjl. All rights reserved.
//

import UIKit

enum UserAPI {
    
    case login(account: String, password : String)
    case laginMsg(mobile:String,smsCode:String)
    case loginOut(account: String)
    case switchTenant(projetId : String)
    case switchTenantMenu(account : String)
    case listByCurrentOwner(cityCodes:String,companyId:String,masterOrgId:String,name:String)
    case personalProfile
//    //短信类型枚举：LOGIN：短信登录；RECOVER_PWD：找回密码；SETTING_PWD：设置密码
    case sendMsgCode(mobile : String,type : String)
    case forgetPwd(mobile:String,password:String,repeatPassword:String,smsCode:String)
    case setPayPwd(mobile:String,password:String,repeatPassword:String,smsCode:String)
    case changePwd(account:String,newPassword:String,oldPassword:String)
}

extension UserAPI : Request {
    
    var parameters: [String : Any] {
        
        var param : [String :Any]
        
        switch self {
            
        case .login(let account,let password):
            
            param = ["account":account,"password":password]
        case .laginMsg(let mobile,let smsCode):
            
            param = ["mobile":mobile,"smsCode":smsCode]
    
        case .loginOut(let account):
            param = ["account":account]

    
        case .listByCurrentOwner(let cityCodes,let companyId,let masterOrgId, let name):
            param = ["":""]
            
        case .switchTenant(let projectId):
            param = ["projectId":projectId]

        case .switchTenantMenu(let account):
        param = ["account":account]

        case .forgetPwd(let mobile, let password ,let repeatPassword,let smsCode):
            param = ["mobile":mobile,"password":password,"repeatPassword":repeatPassword,"smsCode":smsCode]
        case .setPayPwd(let mobile, let password, let repeatPassword, let  smsCode):
            param = ["password":password,"repeatPassword":repeatPassword,"smsCode":smsCode]
        case .changePwd(let mobile,let newPassword,let oldPassword):
            param = ["account":mobile,"newPassword":newPassword,"oldPassword":oldPassword]
        case .sendMsgCode(let mobile,let type):
            param = ["mobile":mobile,"type":type,]
        case .personalProfile:
            param = ["":""]
        default:
            param = ["":""]
        }
        param =  ["data":param]
        return param
    }
    
    var path: String {
        
        switch  self {
        //    MARK: -  以下在用
        case .login:
            return "/bop-portal/open/login/account"
            
        case .laginMsg:
            return "/bop-portal/open/login/mobile"
            
        case .loginOut:
            return "/bop-portal/open/login/logout"
            
//        case .listTenant:
//
//            return "/bop-portal/open/login/listTenant"
//            
        case .switchTenant:
            return "/bop-portal/open/login/switchTenant"
            
        case .switchTenantMenu:
            return "/bop-base/portal/app/resource/tenant/owner/menu"
      
        case .listByCurrentOwner:
            return "bop-core/org/project/listByCurrentOwner"
            
        case .personalProfile:
            return "/bop-portal/personal/profile/get"
            
        case .sendMsgCode:
            return "/bop-portal/open/api/sms/sendSmsCode"
            
        case .forgetPwd:
            return "/bop-portal/personal/password/retrieve"
            
         case .setPayPwd:
             return "/bop-portal/personal/password/set"
            
        case .changePwd:
            return "/bop-portal/personal/password/change"

        default :
            return HostType.type().baseURLStr
        }
        return ""
    }
    
    var task: Task {
        
        switch self {
            
        default:
            
            return Task.requestParameters(parameters: parametersHandle(), encoding: JSONEncoding.default)
        }
    }
    
//    var headers: [String: String]? {
//
//        switch self {
//
//        default:
            
//            let dis = ["sys" : "ios","version" : Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String,"token":ShareData.shared.token ?? ""]
//            return dis
//        }
//    }
//
 
 
}
