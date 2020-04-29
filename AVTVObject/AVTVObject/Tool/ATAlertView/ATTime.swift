//
//  ATTime.swift
//  GKGame_Swift
//
//  Created by wangws1990 on 2019/10/11.
//  Copyright © 2019 wangws1990. All rights reserved.
//

import UIKit

class ATTime: NSObject {
    class func timeStamp() -> TimeInterval{
        let time : TimeInterval = Date.init().timeIntervalSince1970;
        return time;
    }
    class func getTimeStamp() -> String{
        let dat : NSDate = NSDate.init(timeIntervalSinceNow: 0);
        let a : TimeInterval = dat.timeIntervalSince1970;
        return String(a);
    }
    class func timeStampTunrnToDate(timeStamp:String) -> String{
           let time :TimeInterval = (TimeInterval(timeStamp))!
           let date:NSDate = NSDate.init(timeIntervalSince1970:time);
           let formatter:DateFormatter = DateFormatter.init();
           formatter.dateFormat = "YYYY/MM/dd HH:mm"
           return formatter.string(from: date as Date);
    }
    class func totalTimeTurnToTime(timeStamp:TimeInterval) -> String{
        let time :TimeInterval = timeStamp
        if time/3600 > 1 {
            let date:NSDate = NSDate.init(timeIntervalSince1970: time)
            let formatter:DateFormatter = DateFormatter.init();
            formatter.dateFormat = "HH:mm:ss"
            formatter.timeZone = TimeZone.init(identifier: "GMT")
            return formatter.string(from: date as Date);
        }else{
            let date:NSDate = NSDate.init(timeIntervalSince1970: time)
            let formatter:DateFormatter = DateFormatter.init();
            formatter.dateFormat = "mm:ss"
            formatter.timeZone = TimeZone.init(identifier: "GMT")
            return formatter.string(from: date as Date);
        }
    }
    class func getNumberCount(count:Int) ->String{
        if count > 10000 {
            let value :Float = Float(count/10000);
            return String(value)+"万"
        }
        return String(count);
    }
}
