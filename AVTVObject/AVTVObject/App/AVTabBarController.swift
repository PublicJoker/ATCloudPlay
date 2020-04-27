//
//  AVTabBarController.swift
//  AVTVObject
//
//  Created by wangws1990 on 2020/4/26.
//  Copyright © 2020 wangws1990. All rights reserved.
//

import UIKit

class AVTabBarController: UITabBarController {
    lazy var listData: [UIViewController] = {
        return [];
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.isTranslucent = false;
        let vc = AVHomeController.init();
        self.createCtrl(vc: vc, title:"首页", normal:"icon_tabbar_home_n", select:"icon_tabbar_home_h");
        let fav = AVFavController.init();
        self.createCtrl(vc: fav, title:"收藏", normal:"icon_tabbar_video_n", select:"icon_tabbar_video_h");
        let my = BaseViewController.init();
        self.createCtrl(vc: my, title:"我的", normal:"icon_tabbar_wall_n", select:"icon_tabbar_wall_h");
        
        self.viewControllers = self.listData;
    }
    func createCtrl(vc :UIViewController,title :String,normal: String,select :String) {
        let nv = BaseNavigationController.init(rootViewController: vc);
        vc.showNavTitle(title: title)
        nv.tabBarItem.title = title;
        nv.tabBarItem.image = UIImage.init(named: normal)?.withRenderingMode(.alwaysOriginal);
        nv.tabBarItem.selectedImage = UIImage.init(named: select)?.withRenderingMode(.alwaysOriginal);
        nv.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : AppColor as Any], for: .selected);
        nv.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : Appx999999 as Any], for: .normal);
        self.listData.append(nv);
    }
}
