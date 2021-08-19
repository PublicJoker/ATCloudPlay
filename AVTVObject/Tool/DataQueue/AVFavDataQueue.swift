//
//  AVFavDataQueue.swift
//  AVTVObject
//
//  Created by wangws1990 on 2020/4/27.
//  Copyright © 2020 wangws1990. All rights reserved.
//

import UIKit
import SwiftyJSON
private let table     = "FavTable";
private let primaryId = "movieId";
class AVFavDataQueue: NSObject {
    public class func favData(model : AVMovie,completion :@escaping ((_ success : Bool) ->Void)){
        model.updateTime = ATTime.timeStamp();
        BaseDataQueue.insertData(toDataBase:table, primaryId:primaryId, userInfo: model.toJSON()!, completion:completion);
    }
    public class func cancleFavData(movieId : String,completion :@escaping ((_ success : Bool) ->Void)){
        BaseDataQueue.deleteData(toDataBase:table, primaryId: primaryId, primaryValue: movieId, completion: completion)
    }
    public class func getFavData(movieId : String,completion :@escaping ((_ model : AVMovie) ->Void)){
        BaseDataQueue.getDataFromDataBase(table, primaryId: primaryId, primaryValue: movieId) { (object) in
            let json = JSON(object);
            if let info = AVMovie.deserialize(from: json.rawString()){
                completion(info);
            }else{
                completion(AVMovie());
            }
        }
    }
    public class func getFavDatas(completion :@escaping ((_ listData : [AVMovie]) ->Void)){
        BaseDataQueue.getDatasFromDataBase(table, primaryId:primaryId) { (object) in
            let json = JSON(object);
            var arrayData : [AVMovie] = []
            if let data = [AVMovie].deserialize(from: json.rawString()){
                arrayData = data as! [AVMovie]
            }
            arrayData = self.sortDatas(listDatas: arrayData, ascending: false)
            completion(arrayData);
        }
    }
    public class func getFavDatas(page: Int, size : Int,completion :@escaping ((_ listData : [AVMovie]) ->Void)){
        BaseDataQueue.getDatasFromDataBase(table, primaryId: primaryId, page: page, pageSize: size) { (object) in
            let json = JSON(object);
            var arrayData : [AVMovie] = []
            if let data = [AVMovie].deserialize(from: json.rawString()){
                arrayData = data as! [AVMovie]
            }
            arrayData = self.sortDatas(listDatas: arrayData, ascending: false)
            completion(arrayData);
        }
    }
    //yes 升序
    private class func sortDatas(listDatas:[AVMovie],ascending : Bool) ->[AVMovie]{
        var datas  = listDatas;
        datas.sort { (model1, model2) -> Bool in
            return Double(model1.updateTime) < Double(model2.updateTime)  ? ascending : !ascending;
        }
        return datas;
    }
}
