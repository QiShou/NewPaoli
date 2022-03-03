//
//  AGUserDefaults.swift
//  AgentTool
//
//  Created by 1 on 2021/7/20.
//

import UIKit

 
let AGToken = "token"
let AGAccount = "loginAccount" //电话号码
let AGPassword = "loginPassword"
let AGUserAccount = "userAccount" //登录用户
let AGProjectId = "projectId" // 当前用户projectId
let AGHasSetPassord = "hassetPassword"

class AGUserDefaults: NSObject {

    
    var phone : String? {
        get {
            let moble = "\(AGUserDefaults().getUserDefaults(AGAccount) ?? "")"
            return moble
        }
    }
    
    var projectId:String? {
        get {
            let ids = "\(AGUserDefaults().getUserDefaults(AGProjectId) ?? "")"
            return ids
        }
    }
    
   class var hasSetPassord:Bool? {
        get {
            return AGUserDefaults().getUserBoolDefaults(AGHasSetPassord)
        }
    }
    
    func setUserDefaults(_ value: Any?,_ key:String)  {
        UserDefaults.standard.setValue(value, forKey: key)
        UserDefaults.standard.synchronize()
    }

    func getUserDefaults(_ key : String) -> Any?  {
       return UserDefaults.standard.value(forKey: key)
    }
  
    class func setUserBoolDefaults(_ value: Any?,_ key:String)  {
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    func getUserBoolDefaults(_ key:String) -> Bool {
       return UserDefaults.standard.bool(forKey: key)
        
    }
}



