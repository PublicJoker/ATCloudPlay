//
//  AVBrowseDataQueue.swift
//  AVTVObject
//
//  Created by wangws1990 on 2020/4/27.
//  Copyright © 2020 wangws1990. All rights reserved.
//

import UIKit
import SwiftyJSON

class AVBrowseDataQueue: NSObject {
    
    class func browseData(model : AVMovieInfo,completion :@escaping ((_ success : Bool) ->Void)){
        model.updateTime = ATTime.timeStamp();
        BaseDataQueue.insertData(toDataBase:self.table(), primaryId: self.primaryId(), userInfo: model.toJSON()!, completion:completion);
    }
    class func cancleBrowseData(movieId : String,completion :@escaping ((_ success : Bool) ->Void)){
        BaseDataQueue.deleteData(toDataBase:self.table(), primaryId: self.primaryId(), primaryValue: movieId, completion: completion)
    }
    class func getBrowseData(movieId : String,completion :@escaping ((_ model : AVMovieInfo) ->Void)){
        BaseDataQueue.getDataFromDataBase(self.table(), primaryId: self.primaryId(), primaryValue: movieId) { (object) in
            let json = JSON(object);

            if let info = AVMovieInfo.deserialize(from: json.rawString()){
                completion(info);
            }else{
                completion(AVMovieInfo());
            }
        }
    }
    class func getBrowseDatas(completion :@escaping ((_ listData : [AVMovieInfo]) ->Void)){
        BaseDataQueue.getDatasFromDataBase(self.table(), primaryId: self.primaryId()) { (object) in
            let json = JSON(object);
            var arrayData : [AVMovieInfo] = []
            if let list = json.array{
                for obj in list {
                    var newData = obj;
                    newData["zu"] = [];
                    if let model : AVMovieInfo = AVMovieInfo.deserialize(from: newData.rawString()){
                        arrayData.append(model)
                    }
                }
            }
//            if let data = [AVMovieInfo].deserialize(from: json.rawString()){
//                arrayData = data as! [AVMovieInfo]
//            }
            arrayData = self.sortDatas(listDatas: arrayData, ascending: false)
            completion(arrayData);
        }
    }
    class func getBrowseDatas(page: Int, size : Int,completion :@escaping ((_ listData : [AVMovieInfo]) ->Void)){
        BaseDataQueue.getDatasFromDataBase(self.table(), primaryId: self.primaryId(), page: page, pageSize: size) { (object) in
            let json = JSON(object);
            var arrayData : [AVMovieInfo] = []
            if let list = json.array{
                for obj in list {
                    var newData = obj;
                    newData["zu"] = [];
                    if let model : AVMovieInfo = AVMovieInfo.deserialize(from: newData.rawString()){
                        arrayData.append(model)
                    }
                }
            }
//            if let data = [AVMovieInfo].deserialize(from: json.rawString()){
//                arrayData = data as! [AVMovieInfo]
//            }
            arrayData = self.sortDatas(listDatas: arrayData, ascending: false)
            completion(arrayData);
        }
    }
    //yes 升序
    class func sortDatas(listDatas:[AVMovieInfo],ascending : Bool) ->[AVMovieInfo]{
        var datas  = listDatas;
        datas.sort { (model1, model2) -> Bool in
            return Double(model1.updateTime) < Double(model2.updateTime)  ? ascending : !ascending;
        }
        return datas;
    }
    private class func table() -> String{
        return "BrowseTable"
    }
    private class func primaryId() -> String{
        return "movieId"
    }
}
