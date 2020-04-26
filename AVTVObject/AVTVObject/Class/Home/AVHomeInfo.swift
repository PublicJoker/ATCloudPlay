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
    var vod     : [AVMovie] = []
    func mapping(mapper: HelpingMapper) {
         mapper <<<
             self.homeId <-- ["homeId","id"]
     }
    required init() {
        
    }
}
