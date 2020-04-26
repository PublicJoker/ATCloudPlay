//
//  BaseNavigationController.swift
//  GKGame_Swift
//
//  Created by wangws1990 on 2019/9/29.
//  Copyright © 2019 wangws1990. All rights reserved.
//

import UIKit
import Hue
class BaseNavigationController: UINavigationController,UINavigationControllerDelegate {

    var pushing : Bool = false;
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self;
        if (self.delegate?.responds(to:#selector(getter: interactivePopGestureRecognizer)))! {
            self.interactivePopGestureRecognizer?.isEnabled = true;
        }
        let navBar : UINavigationBar = UINavigationBar.appearance()
        navBar.titleTextAttributes = (self.defaultNvi() as! [NSAttributedString.Key : Any]);
        let imageV : UIImage = UIImage.imageWithColor(color: UIColor.init(hex:"ffffff"));
        navBar.setBackgroundImage(imageV, for: .default);
        navBar.shadowImage = UIImage.init();
        navBar.isTranslucent = false;
    }
    func defaultNvi()-> NSDictionary{
        let dic :NSMutableDictionary = NSMutableDictionary.init();
        let font : UIFont = UIFont.systemFont(ofSize: 18, weight: .semibold);
        let color : UIColor = UIColor.black
        dic.setObject(color, forKey: NSAttributedString.Key.foregroundColor.rawValue as NSCopying);
        dic.setObject(font, forKey: NSAttributedString.Key.font.rawValue as NSCopying)
        return dic
    }
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if self.pushing == true {
            return;
        }else{
            self.pushing = true;
        }
        super.pushViewController(viewController, animated: animated);
    }
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        self.pushing = false;
    }
    override var prefersStatusBarHidden: Bool{
        return self.visibleViewController!.prefersStatusBarHidden;
    }
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .default;
    }
    override var shouldAutorotate: Bool{
        return self.visibleViewController!.shouldAutorotate;
    }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        return self.visibleViewController!.supportedInterfaceOrientations;
    }
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation{
        return self.visibleViewController!.preferredInterfaceOrientationForPresentation;
    }
}
