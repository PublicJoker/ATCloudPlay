//
//  ATKit.swift
//  MySwiftObject
//
//  Created by wangws1990 on 2019/9/25.
//  Copyright © 2019 wangws1990. All rights reserved.
//

import UIKit
extension UIView{
    class func xibName() -> String{
        let name : String = NSStringFromClass(self.classForCoder());
        return name.components(separatedBy: ".").last!;
    }
    class func instanceView() -> Self{
        let nib =  Bundle.main.url(forResource:self.xibName(), withExtension:"nib");
        if nib != nil{
            let view = Bundle.main.loadNibNamed(self.xibName(), owner:self, options: nil)?.first;
            return view as! Self;
        }
        return self.init();
    }
}
extension UITableViewCell{
    static var confiTag : Int = 32241981;
    class func cellForTableView(tableView:UITableView,indexPath:IndexPath) ->Self{
       return self.cellForTableView(tableView: tableView, indexPath: indexPath, identifier: nil, config: nil);
    }
    class func cellForTableView(tableView:UITableView,indexPath:IndexPath,identifier:String? = nil,config:((_ cell :UITableViewCell) ->Void)? = nil) ->Self{
        let identy : String = identifier != nil ? identifier! : NSStringFromClass(self.classForCoder());
        var cell = tableView.dequeueReusableCell(withIdentifier: identy);
        if cell == nil {
            let nib =  Bundle.main.url(forResource:self.xibName(), withExtension:"nib");
            if (nib != nil) {
                tableView.register(UINib.init(nibName:self.xibName(), bundle:nil), forCellReuseIdentifier: identy);
            }else{
                tableView.register(self.classForCoder(), forCellReuseIdentifier: identy);
            }
            cell = tableView.dequeueReusableCell(withIdentifier:identy);
        }
        if cell?.tag != confiTag {
            cell?.tag = confiTag;
            if (config != nil) {
                config!(cell!);
            }
        }
        return cell as! Self;
    }
}
extension UICollectionViewCell{
    static var confiTag : Int = 32241981;
    class func cellForCollectionView(collectionView:UICollectionView,indexPath : IndexPath) -> Self{
        return self.cellForCollectionView(collectionView: collectionView, indexPath: indexPath, identifier:nil, config: nil);
    }
    class func cellForCollectionView(collectionView:UICollectionView,indexPath: IndexPath,identifier:String? = nil,config:((_ cell :UICollectionViewCell) ->Void)? = nil) ->Self{
        let identy : String = identifier != nil ? identifier! : NSStringFromClass(self.classForCoder());
        var res1 : Bool = false;
        var res2 : Bool = false;
        if collectionView.value(forKeyPath:"cellNibDict") != nil {
            let dic1 : NSDictionary = (collectionView.value(forKeyPath: "cellNibDict") as?  NSDictionary)! ;
            res1 = (dic1.value(forKeyPath:identy) != nil) ? true : false;
        }
        if collectionView.value(forKeyPath:"cellClassDict") != nil {
            let dic2 : NSDictionary = (collectionView.value(forKeyPath: "cellClassDict") as? NSDictionary)!;
            res2 = (dic2.value(forKeyPath: identy) != nil) ? true : false;
        }
        let hasRegister : Bool = res1 || res2;
        if hasRegister  == false {
            let nib =  Bundle.main.url(forResource:self.xibName(), withExtension:"nib");
            if (nib != nil) {
              collectionView.register(UINib.init(nibName: self.xibName(), bundle: nil), forCellWithReuseIdentifier: identy)
            }else{
                collectionView.register(self.classForCoder(), forCellWithReuseIdentifier: identy)
            }
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:identy, for: indexPath);
        if cell.tag != confiTag {
            cell.tag = confiTag;
            if (config != nil) {
                config!(cell);
            }
        }
        return cell as! Self;
    }
}
extension UICollectionReusableView{
    static var configTag : Int = 32241981981;
    class func viewForCollectionView(collectionView:UICollectionView,elementKind:String,indexPath:IndexPath) ->Self{
        return self.viewForCollectionView(collectionView: collectionView, elementKind: elementKind, indexPath: indexPath, identifier: nil, config: nil);
    }
    class func viewForCollectionView(collectionView:UICollectionView,elementKind:String,indexPath:IndexPath,identifier:String? = nil,config:((_ cell :UICollectionReusableView) ->Void)? = nil) ->Self {
        assert(elementKind.count > 0)
        let identy : String = identifier != nil ? identifier! : NSStringFromClass(self.classForCoder());
        let keyPath = elementKind.appendingFormat("/" + identy);
        var res1 : Bool = false;
        var res2 : Bool = false;
        if  collectionView.value(forKeyPath:"supplementaryViewNibDict") != nil {
            let dic  = collectionView.value(forKeyPath:"supplementaryViewNibDict") as! NSDictionary;
            res1 = dic.value(forKeyPath:keyPath) != nil ? true : false;
        }
        if collectionView.value(forKeyPath: "supplementaryViewClassDict") != nil {
            let dic  = collectionView.value(forKeyPath:"supplementaryViewClassDict") as! NSDictionary;
            res2 = dic.value(forKeyPath:keyPath) != nil ? true : false;
        }
        let hasRegister = res1 || res2;
        if hasRegister == false {
            let nib =  Bundle.main.url(forResource:self.xibName(), withExtension:"nib");
            if (nib != nil) {
                collectionView.register(UINib.init(nibName: self.xibName(), bundle:nil), forSupplementaryViewOfKind: elementKind, withReuseIdentifier:identy);
            }else{
                collectionView.register(self.classForCoder(), forSupplementaryViewOfKind: elementKind, withReuseIdentifier:identy)
            }
        }
        let cell : UICollectionReusableView = collectionView.dequeueReusableSupplementaryView(ofKind: elementKind, withReuseIdentifier: identy, for: indexPath);
        if cell.tag != configTag{
            cell.tag = configTag;
            if config != nil {
                config!(cell)
            }
        }
        return cell as! Self
    }
}
extension UIViewController{
    func showNavTitle(title : String?){
        self.showNavTitle(title: title, back:true);
    }
    func showNavTitle(title :String?,back:Bool){
        self.navigationItem.title = title ?? "";
        if back {
            self.setBackItem(backItem:UIImage.init(named:"icon_nav_back"))
        }else{
            self.navigationItem.leftBarButtonItem = nil;
            self.navigationItem.hidesBackButton = true;
        }
    }
    func setBackItem(backItem:UIImage?){
        self.setBackItem(backItem: backItem, closeItem:UIImage.init(named: "icon_nav_close"));
    }
    func setBackItem(backItem:UIImage?,closeItem:UIImage?){
        if self.navigationController != nil {
            if self.navigationController?.viewControllers.count == 1 && (self.presentingViewController != nil) {
                self.navigationItem.leftBarButtonItem = self.navItem(rightItem:false, image: closeItem , title:(closeItem != nil) ? nil:"ㄨ", color:nil, target:self, action: #selector(goBack))
            }else if((self.navigationController?.viewControllers.count)! > 1 || (!(self.navigationController != nil) && !(self.parent != nil))){
                self.navigationItem.leftBarButtonItem = self.navItem(rightItem:false, image: backItem , title:(backItem != nil) ? nil:"ㄑ", color:nil, target:self, action: #selector(goBack))
            }else{
                self.navigationItem.leftBarButtonItem = nil;
                self.navigationItem.hidesBackButton = true;
            }
            if self.navigationItem.leftBarButtonItem?.customView != nil {
                let button:UIButton = (self.navigationItem.leftBarButtonItem?.customView as? UIButton)!
                button.contentHorizontalAlignment = .left;
            }
        }
    }
    func setKeyBoardDismiss(){
        UIApplication.shared.keyWindow?.endEditing(true)
    }
    func setLargeTitleDisplayModeNever(){
         if #available(iOS 11.0, *) {
            self.navigationItem.largeTitleDisplayMode = .never
        }
    }
    @objc func goBack(){
        self.back(animated:true)
    }
    @objc func back(animated:Bool){
        if self.navigationController?.viewControllers != nil {
            if (self.navigationController?.viewControllers.count)! > 1 {
                self.navigationController?.popViewController(animated: animated);
            }else if((self.presentingViewController) != nil){
                self.dismiss(animated: animated, completion:nil)
                self.view.endEditing(true);
            }
        }
    }
    func dismissOrPopToRootControlelr(){
        self.dismissOrPopToRootController(animated: true);
    }
    func dismissOrPopToRootController(animated : Bool){
        if (self.presentingViewController != nil) {
            self.dismiss(animated:animated, completion: nil)
        }else if (self.navigationController?.viewControllers.count)! > 1{
            self.navigationController?.popToRootViewController(animated: animated);
        }
    }
    func navItem(rightItem :Bool,image:UIImage?,title:String?,color:UIColor?,target: Any?,action:Selector) -> UIBarButtonItem{
        let button:UIButton = UIButton.init(type: .custom);
        button.addTarget(target, action:action, for: .touchUpInside);
        button.setTitle(title, for: .normal);
        button.setImage(image ?? UIImage.init(), for: .normal);
        button.frame = CGRect.init(x: 0, y: 0, width: 40, height: 40);
        button.setTitleColor((color != nil) ? color : UIColor.gray, for: .normal);
        button.contentHorizontalAlignment = rightItem ? UIControl.ContentHorizontalAlignment.right : UIControl.ContentHorizontalAlignment.left;
        return UIBarButtonItem.init(customView: button);
    }
    func setNavRightItem(image:UIImage?,title:String?,color:UIColor?,action:Selector){
        self.navigationItem.rightBarButtonItem = self.navItem(rightItem:true, image: image, title: title, color: color, target:self, action:action);
    }
    class func rootTopPresentedController()->UIViewController{
        return self.rootTopPresentedControllerWihtKeys(keys: nil);
    }
    class func rootTopPresentedControllerWihtKeys(keys:[String]? = nil)->UIViewController{
        let window : UIWindow =  ((UIApplication.shared.delegate?.window)!)!;
        return (window.rootViewController?.topPresentedControllerWihtKeys(keys: keys))!;
    }
    func topPresentedController()->UIViewController{
        return self.topPresentedControllerWihtKeys(keys:nil);
    }
    func topPresentedControllerWihtKeys(keys:[String]? = nil)->UIViewController{
        let top : [String] = (keys != nil) ? keys! : ["centerViewController", "contentViewController"];
        var rootVC : UIViewController = self;
        if rootVC is UITabBarController {
            let tabVC : UITabBarController = rootVC as! UITabBarController;
            let vc = tabVC.selectedViewController != nil ? tabVC.selectedViewController : tabVC.children.first;
            if vc != nil {
                return vc!.topPresentedControllerWihtKeys(keys: top);
            }
        }
        for str in top{
            if rootVC.responds(to: NSSelectorFromString(str)) {
                let vc  = rootVC.perform(NSSelectorFromString(str));
                let ct = vc?.takeUnretainedValue();
                if ct is UIViewController {
                    let ctrl : UIViewController = ct as! UIViewController;
                    return ctrl.topPresentedControllerWihtKeys(keys: top);
                }
            }
        }
        while rootVC.presentingViewController != nil && rootVC.presentingViewController?.isBeingDismissed == false {
            rootVC = rootVC.presentedViewController!;
        }
        if rootVC is UINavigationController {
            let nvc : UINavigationController = rootVC as! UINavigationController;
            rootVC = nvc.topViewController!;
        }
        
        return rootVC;
    }
}


