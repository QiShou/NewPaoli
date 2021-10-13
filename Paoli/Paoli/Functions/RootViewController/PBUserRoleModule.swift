//
//  PBUserRoleModule.swift
//  Paoli
//
//  Created by 1 on 2021/9/29.
//

import UIKit
import Foundation



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
  var hasSetPassword: String? //<null>]
    
}

