//
//  AVPlayToastView.swift
//  AVTVObject
//
//  Created by wangws1990 on 2020/4/28.
//  Copyright © 2020 wangws1990. All rights reserved.
//

import UIKit

class AVPlayToastView: UIView {

    lazy var imageV : UIImageView = {
        return UIImageView.init();
    }()
    lazy var titleLab : UILabel = {
        let titleLab = UILabel.init();
        titleLab.font = UIFont.boldSystemFont(ofSize: 16)
        titleLab.textColor = Appxffffff;
        titleLab.textAlignment = .center;
        return titleLab;
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadUI();
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadUI();
    }
    private func loadUI(){
        self.layer.masksToBounds = true;
        self.layer.cornerRadius = 5;
        self.backgroundColor = UIColor.init(white: 0, alpha: 0.8)
        self.addSubview(self.imageV);
        self.addSubview(self.titleLab);
        self.imageV.snp.makeConstraints { (make) in
            make.width.height.equalTo(32);
            make.centerX.equalToSuperview();
            make.centerY.equalToSuperview().offset(-12);
        }
        self.titleLab.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview();
            make.top.equalTo(self.imageV.snp.bottom).offset(5);
            
        }
    }

}
