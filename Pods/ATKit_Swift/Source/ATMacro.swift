//
//  ATMacro.swift
//  ATKit_Swift
//
//  Created by wangws1990 on 2020/5/9.
//  Copyright © 2020 wangws1990. All rights reserved.
//

import Foundation
import UIKit

public enum ATSize {
    case width
    case height
    case size
}
private let at_iphone                 = ATMacro.iPhone_Bar()

public class ATMacro : NSObject {
    public class func at_iphoneX() -> Bool{
        return at_iphone.iphoneX
    }
    public class func at_statusBar() ->CGFloat{
        return at_iphone.statusBar
    }
    public class func at_naviBar() ->CGFloat{
        return (at_iphone.statusBar + 44)
    }
    public class func at_tabBar() ->CGFloat{
        return at_iphone.tabBar
    }
    class func iPhone_Bar() ->(iphoneX :Bool,statusBar : CGFloat,tabBar : CGFloat){
        if let window = UIApplication.shared.delegate?.window {
            if #available(iOS 11.0, *) {
                let inset : UIEdgeInsets = window!.safeAreaInsets
                return (inset.bottom > 0, inset.top,inset.bottom)
            } else {
                 return (false,20,0)
            }
        }
        return (false,20,0)
    }
    public class func imageWithColor(color:UIColor) -> UIImage{
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
