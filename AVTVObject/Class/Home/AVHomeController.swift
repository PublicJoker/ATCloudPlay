//
//  AVHomeController.swift
//  AVTVObject
//
//  Created by Tony-sg on 2020/4/26.
//  Copyright © 2020 Tony-sg. All rights reserved.
//

import UIKit
class AVHomeController: BaseViewController {
    private lazy var searchBtn : UIButton = {
        let btn : UIButton = UIButton()
        btn.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        btn.setImage(UIImage(named: "icon_search"), for: .normal)
        btn.addTarget(self, action: #selector(searchAction), for: .touchUpInside)
        return btn
    }()
    private lazy var titleDatas: [String] = {
        return ["热门","推荐","剧集","综合"]
    }()
    private lazy var controllerDatas: [UIViewController] = {
        return [AVHomeHotContrller(movieId: "2"),AVHomeIndexController(),AVHomeHotContrller(movieId: "1"),AVHomeHotContrller(movieId: "0")]
    }()
    private lazy var magicCtrl: VTMagicController = {
        let ctrl = VTMagicController()
        ctrl.magicView.navigationInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        ctrl.magicView.separatorHeight = 0.5
        ctrl.magicView.backgroundColor = Appxffffff
        ctrl.magicView.separatorColor = UIColor.clear
        ctrl.magicView.navigationColor = Appxffffff
        ctrl.magicView.switchStyle = .default
        
        ctrl.magicView.sliderColor = Appxffffff
        
        ctrl.magicView.layoutStyle = .default
        ctrl.magicView.sliderStyle = .bubble
        ctrl.magicView.bubbleInset = UIEdgeInsets.init(top: 3, left: 8, bottom: 3, right: 8)
        ctrl.magicView.navigationHeight = 44
        ctrl.magicView.itemSpacing = 25
        
        ctrl.magicView.isAgainstStatusBar = true
        ctrl.magicView.dataSource = self
        ctrl.magicView.delegate = self
        ctrl.magicView.itemScale = 1.05
        ctrl.magicView.needPreloading = true
        ctrl.magicView.bounces = false
        ctrl.magicView.isScrollEnabled = true
        let sliderView = UIView.init()
        sliderView.layer.cornerRadius = 5
        sliderView.layer.borderWidth = 1.5
        sliderView.layer.borderColor = AppColor.cgColor
        ctrl.magicView.setSlider(sliderView)
        return ctrl
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fd_prefersNavigationBarHidden = true
        self.magicCtrl.magicView.rightNavigatoinItem = self.searchBtn
        self.view.addSubview(self.magicCtrl.view)
        self.magicCtrl.view.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        self.magicCtrl.magicView.reloadData()
    }
    @objc private func searchAction(){
        AppJump.jumpToSearchControl()
    }

}
extension AVHomeController :VTMagicViewDelegate,VTMagicViewDataSource{
    func menuTitles(for magicView: VTMagicView) -> [String] {
        return self.titleDatas
    }
    func magicView(_ magicView: VTMagicView, menuItemAt itemIndex: UInt) -> UIButton {
        let button : UIButton = magicView.dequeueReusableItem(withIdentifier: "www.new.btn.identy") ?? UIButton(type: .custom)
        button.setTitleColor(Appx333333, for: .normal)
        button.setTitleColor(AppColor, for: .selected)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        return button
    }
    func magicView(_ magicView: VTMagicView, viewControllerAtPage pageIndex: UInt) -> UIViewController {
        return self.controllerDatas[Int(pageIndex)]
    }
}
