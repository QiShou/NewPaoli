//
//  AGUserDefaults.swift
//  AgentTool
//
//  Created by 1 on 2021/7/20.
//  Copyright © 2021 深圳市腾付通电子支付科技有限公司. All rights reserved.
//

import UIKit


let AGToken = "token"
let AGAccount = "loginAccount" //电话号码
let AGPassword = "loginPassword"
let AGUserAccount = "userAccount" //登录用户

class AGUserDefaults: NSObject {

    func setUserDefaults(_ value: Any?,_ key:String)  {
        UserDefaults.standard.setValue(value, forKey: key)
        UserDefaults.standard.synchronize()
    }

    func getUserDefaults(_ key : String) -> Any?  {
       return UserDefaults.standard.value(forKey: key)
    }
  
}

