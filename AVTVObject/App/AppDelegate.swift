//
//  AppDelegate.swift
//  AVTVObject
//
//  Created by Tony-sg on 2020/4/26.
//  Copyright © 2020 Tony-sg. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var makeOrientation :UIInterfaceOrientation?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow.init(frame: UIScreen.main.bounds)
        self.window?.makeKeyAndVisible();
        self.window?.backgroundColor = UIColor.white;
        self.window?.rootViewController = AVTabBarController.init();
        
        // 三方SDK初始化
        PlatformConfig.shared.init3rdSDK(application: application, launchOptions: launchOptions)
        return true
    }
    open func supportedInterfaceOrientations(for window: UIWindow?) -> UIInterfaceOrientationMask{
        return .allButUpsideDown
       // return self.makeOrientation == UIInterfaceOrientation.landscapeRight ? UIInterfaceOrientationMask.all : UIInterfaceOrientationMask.portrait;
    }
    var blockRotation: UIInterfaceOrientationMask = .portrait{
        didSet{
            if blockRotation.contains(.portrait){
                //强制设置成竖屏
                UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
            }else{
                //强制设置成横屏
                UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
                
            }
        }
    }
}

