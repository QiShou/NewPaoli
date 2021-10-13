//
//  CommonCellItemModel.swift
//  wallet
//
//  Created by tjpay on 2019/7/31.
//  Copyright © 2019  All rights reserved.
//

import Foundation

struct CommonCellItemModel {
    
    var title: String
    var describe: String?
    var image: String?
    var opration :()->()
    
    init(title:String,desc:String? = nil,image:String? = nil,opration:@escaping ()->()) {
        self.title = title
        self.describe  = desc
        self.image = image
        self.opration = opration
    }
    
}
