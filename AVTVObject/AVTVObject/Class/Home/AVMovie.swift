//
//  AVMovie.swift
//  AVTVObject
//
//  Created by wangws1990 on 2020/4/26.
//  Copyright © 2020 wangws1990. All rights reserved.
//

import UIKit
import HandyJSON

class AVMovie: HandyJSON {
    var name    : String  = "";
    var pic     : String  = "";
    var movieId : String  = "";
    var cion    : String  = "";
    var hits     : String  = "";
    var pf       : String  = "";
    var state    : String  = "";
    var type     : String  = "";
    var info      : String  = "";
    var vip      : Bool    = false;
    func mapping(mapper: HelpingMapper) {
         mapper <<<
             self.movieId <-- ["movieId","id"]
     }
    required init() {
        
    }
}
