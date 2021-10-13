//
//  CommonHeader.swift
//  wallet
//
//  Created by tjpay on 2019/7/22.
//  Copyright © 2019  All rights reserved.
//

import Foundation
import UIKit

//@objcMembers class CommonHeader:NSObject{
    
//let SERVER_OPEN_ACC_PROTOCOL_URL = "http://120.79.49.212:1443/h5/signagreement";
let SERVER_PHONE_NUM = "4000655766";

let SERVER_PROBLEM_URL = ""

//隐私协议
let SERVER_PRIVACY_POLICY = HostType.type().baseURLStr + "/html/protocol/secretagreement.html"
//用户协议
let SERVER_PROTOCOL_URL = HostType.type().baseURLStr + "/html/protocol/useragreement.html"
//商户协议
let SERVER_USER_PROTOCOL = HostType.type().baseURLStr + "/html/protocol/signagreement.html"

struct CommonAppearance {
    
    static let mainBtnColor  = UIColor.init(hexString: "#14C9CC")
//    static let mainFontColor = UIColor.init(hexString: "7A8599")
}



////主色
//#define MainColor_Normal            RGB(20, 201, 204)
//#define MainColor_Gray              RGB(196, 243, 243)
//#define MainColor_Press             RGB(52, 193, 193)

let ScreenWidth = UIScreen.main.bounds.size.width
let ScreenHeight = UIScreen.main.bounds.size.height
let StatusHeight = UIApplication.shared.statusBarFrame.size.height
let ScreenBounds = UIScreen.main.bounds

let MainColor = UIColor(red: 88/255.0, green: 65/255.0, blue: 244/255.0, alpha: 1)
let HeadlineHColor = UIColor(red: 51/255.0, green: 51/255.0, blue: 51/255.0, alpha: 1)
let SubtitleColor = UIColor(red: 141/255.0, green: 146/255.0, blue: 163/255.0, alpha: 1)
let ButtonColor = UIColor(red: 242/255.0, green: 77/255.0, blue: 51/255.0, alpha: 1)

let DownColor = UIColor.init(red: 240/255.0, green: 241/255.0, blue: 244/255.0, alpha: 1)
let kSuccessResultCode = "000000"
//
//}

////
//// iphone X
//let isIphoneX = LBFMScreenHeight == 812 ? true : false
//// LBFMNavBarHeight
//let LBFMNavBarHeight : CGFloat = isIphoneX ? 88 : 64
//// LBFMTabBarHeight
//let LBFMTabBarHeight : CGFloat = isIphoneX ? 49 + 34 : 49


//MARK:- 通知名称

let kModifyUserInfo = "kModifyUserInfo"

let kLogInAgain = "kLogInAgain"
