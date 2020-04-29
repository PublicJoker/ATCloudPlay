//
//  AVHomeInfo.swift
//  AVTVObject
//
//  Created by wangws1990 on 2020/4/26.
//  Copyright © 2020 wangws1990. All rights reserved.
//

import UIKit
import HandyJSON
class AVHomeInfo: HandyJSON {
    var name    : String    = "";
    var homeId  : String    = "";
    var ad      : String    = "";
    var pic     : String    = "";
    var index   : Bool      = false;
    var vod     : [AVMovie] = [] //所有数据
    var listData: [AVMovie]{
        get{
            let count : Int = self.vod.count > 4 ? 4 : self.vod.count;
            return [] + self.vod.prefix(count)
        }
    }
    func mapping(mapper: HelpingMapper) {
         mapper <<<
             self.homeId <-- ["homeId","id"]
     }
    required init() {
        
    }
}
