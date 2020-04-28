//
//  AVPlayDataQueue.swift
//  AVTVObject
//
//  Created by wangws1990 on 2020/4/28.
//  Copyright © 2020 wangws1990. All rights reserved.
//

import UIKit
import SwiftyJSON

class AVPlayDataQueue: NSObject {
    class func insertData(info : AVItemInfo,completion :@escaping ((_ success : Bool) ->Void)){
        BaseDataQueue.insertData(toDataBase:self.table(), primaryId: self.primaryId(), userInfo: info.toJSON()!, completion:completion);
    }
    class func cancleFavData(itemId : String,completion :@escaping ((_ success : Bool) ->Void)){
        BaseDataQueue.deleteData(toDataBase:self.table(), primaryId: self.primaryId(), primaryValue: itemId, completion: completion)
    }
    class func getFavData(itemId : String,completion :@escaping ((_ model : AVItemInfo) ->Void)){
        BaseDataQueue.getDataFromDataBase(self.table(), primaryId: self.primaryId(), primaryValue: itemId) { (object) in
            let json = JSON(object);
            if let info = AVItemInfo.deserialize(from: json.rawString()){
                completion(info);
            }else{
                completion(AVItemInfo());
            }
        }
    }
    class func table() -> String{
        return "PlayTable"
    }
    class func primaryId() -> String{
        return "itemId"
    }
}
