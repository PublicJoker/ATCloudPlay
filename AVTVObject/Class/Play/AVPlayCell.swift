//
//  AVPlayCell.swift
//  AVTVObject
//
//  Created by Tony-sg on 2020/4/28.
//  Copyright © 2020 Tony-sg. All rights reserved.
//

import UIKit

class AVPlayCell: UICollectionViewCell {
    var item : AVItem?{
        didSet{
            guard let model = item else { return }
            self.titleLab.text = model.name;
        }
    }
    var selectCell : Bool?{
        didSet{
            guard let select = selectCell else { return}
            self.titleLab.textColor = select ? Appxffffff : Appx333333;
            self.titleLab.backgroundColor = select ? AppColor : Appxf8f8f8
        }
    }
    private lazy var titleLab : UILabel = {
        let titleLab = UILabel.init();
        titleLab.font = UIFont.systemFont(ofSize: 16);
        titleLab.textColor = Appx333333;
        titleLab.textAlignment = .center;
        titleLab.layer.masksToBounds = true;
        titleLab.layer.cornerRadius = AppRadius;
        return titleLab;
    }()
    private lazy var mainView : UIView = {
        let mainView = UIView.init();
        mainView.layer.shadowOpacity = 0.3;
        mainView.layer.shadowRadius = 5;
        mainView.layer.shadowColor = Appx999999.cgColor;
        mainView.layer.shadowOffset = CGSize.init(width:0, height: 0)
        return mainView;
    }()
    override init(frame: CGRect) {
        super.init(frame: frame);
        
        self.contentView.addSubview(self.mainView);
        self.mainView.snp.makeConstraints { (make) in
            make.left.top.equalToSuperview().offset(5);
            make.right.bottom.equalToSuperview().offset(-5);
        }
        self.mainView.addSubview(self.titleLab);
        self.titleLab.snp.makeConstraints { (make) in
            make.edges.equalToSuperview();
        }
        self.selectCell = false;
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
}
