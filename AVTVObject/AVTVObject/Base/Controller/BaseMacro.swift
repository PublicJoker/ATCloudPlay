//
//  BaseMacro.swift
//  GKGame_Swift
//
//  Created by wangws1990 on 2019/9/30.
//  Copyright © 2019 wangws1990. All rights reserved.
//

import UIKit
import Hue
import SnapKit
import SwiftyJSON

let kAppdelegate  : AppDelegate? = UIApplication.shared.delegate as? AppDelegate
let SCREEN_WIDTH  :CGFloat  = UIScreen.main.bounds.size.width
let SCREEN_HEIGHT :CGFloat  = UIScreen.main.bounds.size.height

let iPhone_X : Bool = BaseMacro.iPhone_X();
let STATUS_BAR_HIGHT:CGFloat    = (iPhone_X ? 44: 20)//状态栏
let NAVI_BAR_HIGHT  :CGFloat    = (iPhone_X ? 88: 64)//导航栏
let TAB_BAR_ADDING  :CGFloat    = (iPhone_X ? 34 : 0)//iphoneX斜刘海

let AppColor     :UIColor = UIColor.init(hex:"007EFE")
let Appxdddddd   :UIColor = UIColor.init(hex:"dddddd")
let Appx000000   :UIColor = UIColor.init(hex:"000000")
let Appx333333   :UIColor = UIColor.init(hex:"333333")
let Appx666666   :UIColor = UIColor.init(hex:"666666")
let Appx999999   :UIColor = UIColor.init(hex:"999999")
let Appxf8f8f8   :UIColor = UIColor.init(hex:"f8f8f8")
let Appxffffff   :UIColor = UIColor.init(hex:"ffffff")
let AppRadius    :CGFloat = 3
let placeholder  :UIImage = UIImage.imageWithColor(color: UIColor.init(hex: "dedede"));
let top          :CGFloat = 2;

class BaseMacro: NSObject {
    class func iPhone_X() -> Bool{
        let window : UIWindow = ((UIApplication.shared.delegate?.window)!)!;
           if #available(iOS 11.0, *) {
               let inset : UIEdgeInsets = window.safeAreaInsets
               if inset.bottom == 34 || inset.bottom == 21 {
                   return true;
               }else{
                   return false
               }
           } else {
              return false;
           };
       }
    class func screen()->Bool{
        let res : Bool = (kAppdelegate?.blockRotation == .landscapeRight || kAppdelegate?.blockRotation == .landscapeLeft);
        return res;
    }
}
public extension UIImage{
     class func imageWithColor(color:UIColor) -> UIImage{
           let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
           UIGraphicsBeginImageContext(rect.size)
           let context = UIGraphicsGetCurrentContext()
           context!.setFillColor(color.cgColor)
           context!.fill(rect)
           let image = UIGraphicsGetImageFromCurrentImageContext()
           UIGraphicsEndImageContext()
           return image!
       }
}
