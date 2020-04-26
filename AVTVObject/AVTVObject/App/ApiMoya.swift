//
//  ApiMoya.swift
//  AVTVObject
//
//  Created by wangws1990 on 2020/4/26.
//  Copyright © 2020 wangws1990. All rights reserved.
//

import UIKit
import Moya
import SwiftyJSON

let moya = MoyaProvider<ApiMoya>();

public enum ApiMoya{
    case apiHome(vsize: String)
    case apiMovie(movieId: String, vsize:String)
    case apiHomeMore(page: Int, size: Int, ztid: String)
    case apiMovieMore(page: Int, size: Int, movieId: String)
    case apiSearch(page: Int, size: Int, keyWord: String)
    case apiShow(movieId: String)
}

extension ApiMoya : TargetType{
    public var baseURL: URL {
        return URL.init(string: "https://mjappaz.yefu365.com")!
    }
    
    public var path: String {
        switch self {
          case .apiHome:
              return "/index.php/app/ios/topic/index"
          case .apiMovie:
              return "/index.php/app/ios/type/index"
          case .apiShow:
              return "/index.php/app/ios/vod/show"
          default :
              return "/index.php/app/ios/vod/index"
          }
    }
    
    public var method: Moya.Method {
        
        return .get;
    }
    
    public var sampleData: Data {//单元测试
        return Data(base64Encoded: "just for test")!
    }
    
    public var task: Task {
        switch self {
        case let .apiHome(vsize: vsize):
            return .requestParameters(parameters: ["vsize":vsize], encoding: URLEncoding.default);
        case let .apiHomeMore(page: page, size: size, ztid: ztid):
            return .requestParameters(parameters: ["page":(page),"size":(size),"ztid":ztid], encoding: URLEncoding.default);
        case let .apiMovie(movieId: movieId, vsize: vsize):
            return .requestParameters(parameters: ["id":movieId,"vsize":vsize], encoding: URLEncoding.default);
        case let .apiMovieMore(page: page, size: size, movieId: movieId):
            return .requestParameters(parameters: ["page":(page),"size":(size),"id":movieId], encoding: URLEncoding.default);
        case let .apiSearch(page: page, size: size, keyWord: keyWord):
            return .requestParameters(parameters: ["page":(page),"size":(size),"key":keyWord], encoding: URLEncoding.default);
        case let .apiShow(movieId: movieId):
            return .requestParameters(parameters: ["id": movieId], encoding: URLEncoding.default)
        }
    }
    
    public var headers: [String : String]? {
        return [
            "Accept": "*/*",
            "Accept-Encoding": "br, gzip, deflate",
            "Accept-Language": "en-CN;q=1, zh-Hans-CN;q=0.9",
            "Connection": "keep-alive",
            "Content-Type": "application/x-www-form-urlencoded;charset=utf8",
            "Host": "mjappaz.yefu365.com",
        ]
    }
    static func apiMoyaRequest(target: ApiMoya,sucesss:@escaping ((_ object : JSON) ->()),failure:@escaping ((_ error : String) ->())){
        moya.request(target) { (result) in
            switch result{
            case let .success(respond):
                let json = JSON(respond.data)
                if json["code"] == 0 {
                    sucesss(json["data"]);
                }else{
                    failure("code != 0")
                }
                break;
            case let .failure(error):
                failure(error.errorDescription!)
                break;
            }
        }
    }
    static func testDemo(){
        moya.request(ApiMoya.apiHome(vsize: "15")) { (result) in
            switch result{
            case let .success(respond):
                let json = JSON(respond.data)
                print(json)
                break;
            case let .failure(error):
                print(error.errorDescription as Any);
                break;
            }
        }
    }
}
