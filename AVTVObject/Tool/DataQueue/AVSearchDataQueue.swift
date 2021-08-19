//
//  AVSearchDataQueueOC.swift
//  MySwiftObject
//
//  Created by wangws1990 on 2019/9/20.
//  Copyright © 2019 wangws1990. All rights reserved.
//

import UIKit

class AVSearchDataQueue: NSObject {
    public class func insertKeyWord(keyWord : String,completion :@escaping ((_ success : Bool) ->Void)){
        AVSearchDataQueueOC.insertData(toDataBase: keyWord, completion: completion);
    }
    public class func deleteKeyWord(keyWord : String,completion :@escaping ((_ success : Bool) ->Void)){
        AVSearchDataQueueOC.deleteData(toDataBase: keyWord, completion: completion);
    }
    public class func deleteKeyWord(datas : [String],completion :@escaping ((_ success : Bool) ->Void)){
        AVSearchDataQueueOC.deleteDatas(toDataBase: datas, completion: completion);
    }
    public class func getKeyWords(page:NSInteger,size:NSInteger,completion :@escaping ((_ listDatas : [String]) ->Void)){
        AVSearchDataQueueOC.getDatasFromDataBase(page, pageSize: size, completion: completion);
    }
}
