//
//  BaseViewController.swift
//  GKGame_Swift
//
//  Created by wangws1990 on 2019/9/29.
//  Copyright © 2019 wangws1990. All rights reserved.
//

import UIKit
import SwiftyJSON
import SnapKit

class BaseViewController: UIViewController,UIGestureRecognizerDelegate {
    deinit {
        print(self.classForCoder, "is deinit");
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = [];
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self;
        self.view.backgroundColor = UIColor.white;
        self.fd_prefersNavigationBarHidden = false;
        self.fd_interactivePopDisabled = false;
    }
    //MARK:UIGestureRecognizerDelegate
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true;
    }
    override var prefersStatusBarHidden: Bool{
        return false;
    }
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .default;
    }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        return .portrait;
    }
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation{
        return .portrait;
    }
}
