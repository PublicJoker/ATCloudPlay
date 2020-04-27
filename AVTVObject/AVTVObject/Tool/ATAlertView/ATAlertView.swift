//
//  ATAlertView.swift
//  MySwiftObject
//
//  Created by wangws1990 on 2019/3/21.
//  Copyright © 2019 wangws1990. All rights reserved.
//

import UIKit

class ATAlertView: NSObject {
    class func showAlertView(title:String?,message:String?,normals:NSArray?,hights:NSArray?,completion: @escaping ((_ title:String,_ index :NSInteger) -> Void)){
        let alertView = UIAlertController.init(title: title, message: message, preferredStyle: .alert);
        if normals != nil {
            for (index,object) in normals!.enumerated() {
                let action = UIAlertAction.init(title:(object as! String), style: .cancel) { (alert) in
                    completion(object as! String,index);
                };
                alertView.addAction(action);
            }
        }
        if hights != nil {
            for (index,sure) in hights!.enumerated() {
                let action = UIAlertAction.init(title:(sure as! String), style: .destructive) { (alert) in
                    completion(sure as! String,index+normals!.count);
                };
                alertView.addAction(action);
            }
        }
        let rootVC = UIViewController.rootTopPresentedController();
        rootVC.present(alertView, animated:true, completion: nil);
    }
}

class ATActionSheet: NSObject {
    class func showActionSheet(title:String,message:String,normals:NSArray,hights:NSArray,completion:@escaping ((_ title:String,_ index:NSInteger)->Void)){
        let actionSheet = UIAlertController.init(title: title, message: message, preferredStyle: .actionSheet);
        let rootVC = UIViewController.rootTopPresentedController();
        for (index, object) in normals.enumerated() {
            let action = UIAlertAction.init(title: (object as! String), style:.default) { (alert) in
                completion(object as! String,index);
            }
            actionSheet.addAction(action);
        }
        for (index, object) in hights.enumerated() {
            let action = UIAlertAction.init(title: (object as? String), style:.destructive) { (alert) in
                completion(object as! String,index+normals.count);
            }
            actionSheet.addAction(action);
        }
        rootVC.present(actionSheet, animated:true, completion: nil);
    }
}
