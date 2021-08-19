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
        UIViewController.rootTopPresentedController().navigationController?.pushViewController(vc, animated: false)
    }
    class func jumpToMoreControl(movieId : String){
        let vc = AVHomeMoreController(movieId: movieId, ztid: nil)
        vc.hidesBottomBarWhenPushed = true;
        UIViewController.rootTopPresentedController().navigationController?.pushViewController(vc, animated: true)
    }
    class func jumpToIndexMoreControl(ztid : String){
        let vc = AVHomeMoreController(movieId: nil, ztid: ztid)
        vc.hidesBottomBarWhenPushed = true;
        UIViewController.rootTopPresentedController().navigationController?.pushViewController(vc, animated: true)
    }
    class func jumpToPlayControl(movieId : String){
        let vc = AVPlayController(movieId: movieId);
        vc.hidesBottomBarWhenPushed = true;
        UIViewController.rootTopPresentedController().navigationController?.pushViewController(vc, animated: true)
    }
}
