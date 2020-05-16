//
//  AVPlayCell.swift
//  AVTVObject
//
//  Created by wangws1990 on 2020/4/28.
//  Copyright © 2020 wangws1990. All rights reserved.
//

import UIKit

class AVPlayCell: UICollectionViewCell {
    var item : AVItem = AVItem(){
        didSet{
            let model = item
            self.titleLab.text = model.name;
        }
    }
    var _selectCell: Bool?
    var selectCell : Bool?{
        set{
            _selectCell = newValue ?? false;
            self.titleLab.textColor = _selectCell! ? Appxffffff : Appx333333;
            self.titleLab.backgroundColor = _selectCell! ? AppColor : Appxf8f8f8
        }get{
            return _selectCell;
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
        fatalError("init(coder:) has not been implemented")
    }
}
