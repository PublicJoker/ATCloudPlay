//
//  BaseMacro.swift
//  GKGame_Swift
//
//  Created by wangws1990 on 2019/9/30.
//  Copyright © 2019 wangws1990. All rights reserved.
//

import UIKit
import SnapKit
import SwiftyJSON
import ATRefresh_Swift
import ATKit_Swift

let kAppdelegate  : AppDelegate? = UIApplication.shared.delegate as? AppDelegate
public let SCREEN_WIDTH  :CGFloat  = UIScreen.main.bounds.size.width
public let SCREEN_HEIGHT :CGFloat  = UIScreen.main.bounds.size.height

public let iPhoneX        : Bool       = at_iphoneX;
public let STATUS_BAR_HIGHT:CGFloat    = at_statusBar//状态栏
public let NAVI_BAR_HIGHT  :CGFloat    = at_naviBar//导航栏
public let TAB_BAR_ADDING  :CGFloat    = at_tabBar//iphoneX斜刘海

public let AppColor     :UIColor = UIColor(hex:"007EFE")
public let Appxdddddd   :UIColor = UIColor(hex:"dddddd")
public let Appx000000   :UIColor = UIColor(hex:"000000")
public let Appx333333   :UIColor = UIColor(hex:"333333")
public let Appx666666   :UIColor = UIColor(hex:"666666")
public let Appx999999   :UIColor = UIColor(hex:"999999")
public let Appxf8f8f8   :UIColor = UIColor(hex:"f8f8f8")
public let Appxffffff   :UIColor = UIColor(hex:"ffffff")
public let AppRadius    :CGFloat = 3
public let placeholder  :UIImage = UIImage.imageWithColor(color: UIColor.init(hex: "dedede"));

public let itemTop          :CGFloat = 1;
public let itemWidth        :CGFloat = CGFloat((SCREEN_WIDTH - 4*itemTop)/3 - 0.1);
public let itemHeight       :CGFloat = itemWidth*1.45;

class BaseMacro: NSObject {
    public class func screen()->Bool{
        let res : Bool = (kAppdelegate?.blockRotation == .landscapeRight || kAppdelegate?.blockRotation == .landscapeLeft);
        return res;
    }
}
