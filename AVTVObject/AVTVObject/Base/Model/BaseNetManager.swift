//
//  BaseNetManager.swift
//  MySwiftObject
//
//  Created by wangws1990 on 2018/12/13.
//  Copyright © 2018 wangws1990. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
protocol BaseNetRequestProtocol {
    static func baseUrlString(url:String,method:HTTPMethod,parameters:[String:String],headers:[String:String],sucesss:@escaping ((_ object : JSON) ->()),failure:@escaping ((_ error : String) ->()));
}
class BaseNetManager: NSObject,BaseNetRequestProtocol {
    class func iGetUrlString(urlString:String,parameters:[String:String],sucesss:@escaping ((_ object : JSON) ->Void),failure:@escaping ((_ error : String) ->Void))
    {
        baseCodeUrl(urlString: urlString, method: .get, parameters: parameters, sucesss: sucesss, failure: failure);
    }
    class func iPostUrlString(urlString:String,parameters:[String:String],sucesss:@escaping ((_ object : JSON) ->Void),failure:@escaping ((_ error : String) ->Void))
    {
        baseCodeUrl(urlString: urlString, method: .post, parameters: parameters, sucesss: sucesss, failure: failure);
    }
    private class func baseCodeUrl(urlString:String,method:HTTPMethod,parameters:[String:String],sucesss:@escaping ((_ object : JSON) ->Void),failure:@escaping ((_ error : String) ->Void))
    {
        baseUrlString(url: urlString, method:method, parameters: parameters, headers: [:], sucesss: { (object) in
            sucesss(object)
        }, failure: failure);
    }
    static func baseUrlString(url:String,method: HTTPMethod,parameters:[String:String],headers:[String:String],sucesss:@escaping ((_ object : JSON) ->Void),failure:@escaping ((_ error : String) ->Void)){
        let request : DataRequest = Alamofire.request(url,method:method,parameters:parameters,encoding: URLEncoding.default, headers:headers);
        request.responseJSON(queue: DispatchQueue.main, options: .mutableContainers) { (respond) in
            if respond.error != nil
            {
                failure(respond.error.debugDescription);
            }else
            {
                let json = respond.result.value;
                sucesss (JSON(json as Any));
            }
        }
        request.resume()
    }
    
}
class BaseNetSystem : NSObject,BaseNetRequestProtocol{
    static func baseUrlString(url: String, method: HTTPMethod, parameters: [String : String], headers: [String : String], sucesss: @escaping ((JSON) -> ()), failure: @escaping ((String) -> ())){
           var url = url;
            var data: Data? = nil;
            if method.rawValue == "GET" {
                url = url + (parameters.count > 0 ? "?":"") + parames(parameters: parameters)
            }
            else if (method.rawValue == "POST"){
                if JSONSerialization.isValidJSONObject(parameters) {
                    do {
                        data = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
                    } catch  {

                    }
                }
            }
            let path : URL = URL.init(string: url)!;
            let conifg : URLSessionConfiguration = URLSessionConfiguration.default;
            let session : URLSession = URLSession.init(configuration: conifg);
            var request = URLRequest.init(url: path)
            request.httpMethod = method.rawValue;
            request.timeoutInterval = 10;
            request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField:"Content-Type")
            request.addValue("chrome", forHTTPHeaderField:"User-Agent")
            if data != nil {
                request.httpBody = data;
            }
            let task : URLSessionDataTask = session.dataTask(with: request) { (datas, respone, error) in
                DispatchQueue.main.async {
                    do{
                        if error != nil
                        {
                            failure(error.debugDescription);
                        }else
                        {
                            let json = try JSONSerialization.jsonObject(with: datas!, options: .mutableContainers)
                            sucesss(JSON(json));
                        }
                    }catch{

                    }
                }
            }
            task.resume();
        }
        class func parames(parameters:[String:String]) -> String{
            var listData : [String] = [];
            parameters.forEach { (key,value) in
                if key.count > 0 && value.count > 0{
                    listData.append(key + "=" + value);
                }
            }
            return listData.joined(separator: "&")
        }
}
 

