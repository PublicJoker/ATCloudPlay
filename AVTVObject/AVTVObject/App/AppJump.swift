//
//  AppJump.swift
//  AVTVObject
//
//  Created by wangws1990 on 2020/4/26.
//  Copyright © 2020 wangws1990. All rights reserved.
//

import UIKit

class AppJump: NSObject {
    class func jumpToSearchControl(){
        let vc = AVSearchController.init();
        vc.hidesBottomBarWhenPushed = true;
        UIViewController.rootTopPresentedController().navigationController?.pushViewController(vc, animated: true)
    }
    class func jumpToMoreControl(movieId : String){
        let vc = AVHomeMoreController.vcWithMovieId(movieId: movieId);
        vc.hidesBottomBarWhenPushed = true;
        UIViewController.rootTopPresentedController().navigationController?.pushViewController(vc, animated: true)
    }
    class func jumpToIndexMoreControl(movieId : String){
        let vc = AVHomeMoreController.vcWithMovieId(ztid: movieId)
        vc.hidesBottomBarWhenPushed = true;
        UIViewController.rootTopPresentedController().navigationController?.pushViewController(vc, animated: true)
    }
    class func jumpToDetailControl(movieId : String){
        let vc = AVPlayController.vcWithMovieId(movieId: movieId)
        vc.hidesBottomBarWhenPushed = true;
        UIViewController.rootTopPresentedController().navigationController?.pushViewController(vc, animated: true)
    }
}
