//
//  AVHomeReusableView.swift
//  AVTVObject
//
//  Created by wangws1990 on 2020/4/26.
//  Copyright © 2020 wangws1990. All rights reserved.
//

import UIKit

class AVHomeReusableView: UICollectionReusableView {

    @IBOutlet weak var titleLab: UILabel!
    @IBOutlet weak var moreBtn: UIButton!
    var info : AVHomeInfo = AVHomeInfo(){
        didSet{
            let item  = info;
            self.titleLab.text = item.name;
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.moreBtn.setTitleColor(AppColor, for: .normal);
        self.moreBtn.layer.masksToBounds = true;
        self.moreBtn.layer.cornerRadius = 2.5;
        self.moreBtn.layer.borderWidth = 1.0;
        self.moreBtn.layer.borderColor = AppColor.cgColor;
        self.titleLab.textColor = Appx333333;
        self.titleLab.font = UIFont.systemFont(ofSize: 17)
        self.backgroundColor = Appxffffff;
        self.moreBtn.addTarget(self, action: #selector(moreAction), for: .touchUpInside)
    }
    @objc func moreAction(){
        if self.info.index {
            AppJump.jumpToIndexMoreControl(movieId:self.info.homeId);
        }else{
            AppJump.jumpToMoreControl(movieId: self.info.homeId);
        }

    }
}
