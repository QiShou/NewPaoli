//
//  PBUserRoleModule.swift
//  Paoli
//
//  Created by 1 on 2021/9/29.
//

import UIKit
import Foundation
import HandyJSON


struct PBUserRoleModule: HandyJSON {
    
    var id: Int? // 363,
    var parentId: Int? // 0,
    var iconUrl: String? // "",
    var name: String? // "首页",
    var isJump: Bool? // false,
    var path: String? // "/home",
    var code: String? // "HOME_PAGE",
    var displayOrder: Int? // 1,
    var type: String? // "MODUL",
    var badgeNum: Int? // 0,
    var children: [PBUserRoleModule]? //

}

struct PLUserInfo: HandyJSON {

  var tenantName: String? //<null>,
  var email: String? //<null>,
  var account: String? //<null>,
  var userName: String? //<null>,
  var mobile: String? //<null>,
  var nickName: String? //<null>,
  var gender: String? //<null>,
  var imageUrl: String? //<null>,
  var genderText: String? //<null>,
  var hasSetPassword: String? //<null>
    
    
}

//
struct PLProjectListModel : HandyJSON{
    
    var address : String? //
    var areaCode : String? //
    var cityCode : String? //
    var code : String? //
    var contractEndTime : Date? //2021-11-19T02:49:59.513Z",
    var contractStartTime : Date? //2021-11-19T02:49:59.513Z",
    var deviceCount : Int?
    var employeeCount : Int?
    var housesCount : Int?
    var id : Int?
    var level : Int?
    var name : String? //
    var parentId : Int?
    var parentName : String? //
    var positionName : String? //
    var projectState : String? //
    var projectStateText : String? //
    var provinceCityArea : String? //
    var provinceCode : String? //
    var shareType : String? //
    var shareTypeText : String? //
    var type : String? //
    var typeText : String? //
    var updateBy : String? //
    var updateTime : Date? //2021-11-19T02:49:59.513Z"
    
}
