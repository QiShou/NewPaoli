//
//  CommonListResModel.swift
//  AgentTool
//
//  Created by Wxb on 2020/9/10.
//  Copyright © 2020 深圳市腾付通电子支付科技有限公司. All rights reserved.
//

import Foundation

struct CommonListRes<T> :HandyJSON {
    
    var hitCount :String?
    var pages :UInt?
    var searchCount :UInt?
    var records :[T]?
    var total :String?
    var current :UInt?
    var orders:[Any]?
    var tabMenu:[T]?
}


