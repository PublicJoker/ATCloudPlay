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
    var movieId  : String  = "";
    var name     : String  = "";
    var pic      : String  = "";
    var cion     : String  = "";
    var hits     : String  = "";
    var pf       : String  = "";
    var state    : String  = "";
    var type     : String  = "";
    var info     : String  = "";
    var vip      : Int     = 0;
    var updateTime :TimeInterval = 0;
    func mapping(mapper: HelpingMapper) {
         mapper <<<
             self.movieId <-- ["movieId","id"]
     }
    required init() {
        
    }
}

class AVMovieInfo : AVMovie{
    var cname        : String  = "";
    var addtime      : String  = "";
    var daoyan       : String  = "";
    var yuyan        : String  = "";
    var text         : String  = "";
    var area         : String  = "";
    
    var routes       : [AVRoute] = [];
    var playItem     : AVItemInfo = AVItemInfo.init();
    
    override func mapping(mapper: HelpingMapper) {
         mapper <<<
             self.movieId <-- ["movieId","id"]
         mapper <<<
             self.area    <-- ["area","diqu"]
        mapper <<<
             self.routes  <-- ["routes","zu"]
     }
}
class AVRoute : HandyJSON{
    var count   : Int =  0;
    var name    : String = "";
    var ly      : String = "";
    var items   : [AVItem] = [];
    func mapping(mapper: HelpingMapper) {
         mapper <<<
             self.items <-- ["items","ji"]
     }
    required init() {
        
    }
}
class AVItem : HandyJSON{//每一集
    var itemId  : String = "";//每一部的id 都是 0 1 2 3 无法作为主键
    var playUrl : String = "";//播放地址做主键 就怕地址会变化
    var ext     : String = "";
    var name    : String = "";
    func mapping(mapper: HelpingMapper) {
        mapper <<<
             self.itemId  <-- ["itemId","id"]
        mapper <<<
             self.playUrl <-- ["playUrl","purl"]
    }
    required init() {
        
    }
}
class AVItemInfo : AVItem{
    var currentTime : TimeInterval = 0;
    var totalTime   : TimeInterval = 1;
    var living      : Bool = false;
    var needSeek    : Bool?{
        get{
            let time : TimeInterval = self.totalTime > 60*60 ? 120 : 30
            let seek = self.currentTime > 5 && self.currentTime < (self.totalTime - time) ? true : false;
            return seek;
        }
    }
}
