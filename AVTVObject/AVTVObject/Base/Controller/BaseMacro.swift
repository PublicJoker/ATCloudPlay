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
import ATKit_Swift

let kAppdelegate  : AppDelegate? = UIApplication.shared.delegate as? AppDelegate
let SCREEN_WIDTH  :CGFloat  = UIScreen.main.bounds.size.width
let SCREEN_HEIGHT :CGFloat  = UIScreen.main.bounds.size.height

let iPhoneX        : Bool       = (ATMacro.iPhoneX());
let STATUS_BAR_HIGHT:CGFloat    = (ATMacro.Status_Bar())//状态栏
let NAVI_BAR_HIGHT  :CGFloat    = (ATMacro.Navi_Bar())//导航栏
let TAB_BAR_ADDING  :CGFloat    = (ATMacro.Tab_Baar())//iphoneX斜刘海

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

let itemTop          :CGFloat = 1;
let itemWidth        :CGFloat = CGFloat((SCREEN_WIDTH - 3*itemTop)/2);

class BaseMacro: NSObject {
    class func iPhone_X() -> Bool{
        return ATMacro.iPhoneX();
    }
    class func screen()->Bool{
        let res : Bool = (kAppdelegate?.blockRotation == .landscapeRight || kAppdelegate?.blockRotation == .landscapeLeft);
        return res;
    }
}
