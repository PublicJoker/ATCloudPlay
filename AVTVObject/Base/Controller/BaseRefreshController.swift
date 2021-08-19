//
//  BaseRefreshController.swift
//  GKGame_Swift
//
//  Created by wangws1990 on 2019/9/30.
//  Copyright © 2019 wangws1990. All rights reserved.
//

import UIKit
import ATRefresh_Swift
import ATKit_Swift
import Alamofire
public let RefreshPageStart : Int = (1)
public let RefreshPageSize  : Int = (20)


class BaseRefreshController: BaseViewController {
    lazy var refreshData : ATRefreshData = {
        let refresh = ATRefreshData()
        refresh.dataSource = self
        refresh.delegate = self
        return refresh
    }()
    private lazy var images: [UIImage] = {
        var images :[UIImage] = [];
        for i in 0...35{
            let image = UIImage(named:String("下拉loading_00") + String(i < 10 ? ("0"+String(i)) : String(i)));
            if image != nil {
                images.append(image!);
            }
        }
        return images;
    }()
    deinit {
        
    }
    public var refreshNetAvailable : Bool{
        return NetworkReachabilityManager()!.isReachable
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    public func setupRefresh(scrollView:UIScrollView,
                             options:ATRefreshOption){
        
        self.refreshData.setupRefresh(scrollView: scrollView, options: options)
    }
    public func endRefresh(more:Bool){
        self.refreshData.endRefresh(more: more)
    }
    public func endRefreshFailure(error :String = "Net Error..."){
        self.refreshData.endRefreshFailure()
    }
}
extension BaseRefreshController : ATRefreshDataSource{
    var refreshFooterData: [UIImage] {
        return self.images
    }
    
    var refreshHeaderData: [UIImage] {
        return self.images
    }
    var refreshLogo: UIImage{
        let image : UIImage = ((self.refreshData.refreshing ? UIImage.animatedImage(with: self.images, duration: 0.35)! : (self.refreshNetAvailable ? UIImage(named: "icon_data_empty") : UIImage(named: "icon_net_error")))!)
        return image
    }
    var refreshTitle: NSAttributedString{
        let text :String = self.refreshData.refreshing ? "Data Loading..." : (self.refreshNetAvailable ? "Data Empty..." : "Data Error...")
        var dic : [NSAttributedString.Key : Any ] = [:]
        let font : UIFont = UIFont.systemFont(ofSize: 16)
        let color : UIColor = Appx999999
        dic.updateValue(font, forKey: .font)
        dic.updateValue(color, forKey: .foregroundColor)
        let att : NSAttributedString = NSAttributedString(string:text, attributes:(dic))
        return att
    }
}
extension BaseRefreshController : ATRefreshDelegate{
    @objc func refreshData(page: Int) {
        
    }
}
