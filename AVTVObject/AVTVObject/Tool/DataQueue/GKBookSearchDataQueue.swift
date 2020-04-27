//
//  GKBookSearchDataQueue.swift
//  MySwiftObject
//
//  Created by wangws1990 on 2019/9/20.
//  Copyright © 2019 wangws1990. All rights reserved.
//

import UIKit

class GKBookSearchDataQueue: NSObject {
    class func insertKeyWord(keyWord : String,completion :@escaping ((_ success : Bool) ->Void)){
        GKSearchDataQueue.insertData(toDataBase: keyWord, completion: completion);
    }
    class func deleteKeyWord(keyWord : String,completion :@escaping ((_ success : Bool) ->Void)){
        GKSearchDataQueue.deleteData(toDataBase: keyWord, completion: completion);
    }
    class func deleteKeyWord(datas : [String],completion :@escaping ((_ success : Bool) ->Void)){
        GKSearchDataQueue.deleteDatas(toDataBase: datas, completion: completion);
    }
    class func getKeyWords(page:NSInteger,size:NSInteger,completion :@escaping ((_ listDatas : [String]) ->Void)){
        GKSearchDataQueue.getDatasFromDataBase(page, pageSize: size, completion: completion);
    }
    
    
}
