//
//  AVSearchResultCell.swift
//  AVTVObject
//
//  Created by Tony-sg on 2020/4/27.
//  Copyright © 2020 Tony-sg. All rights reserved.
//

import UIKit

class AVSearchResultCell: UITableViewCell {
    @IBOutlet weak var imageV: UIImageView!
    @IBOutlet weak var titleLab: UILabel!
    @IBOutlet weak var hitLab: UILabel!
    @IBOutlet weak var subTitleLab: UILabel!
    @IBOutlet weak var vip: UIImageView!
    var model : AVMovie?{
        didSet{
            guard let item = model else { return }
            self.titleLab.text = item.name;
            self.imageV.kf.setImage(with: URL.init(string: item.pic),placeholder: placeholder);
            self.subTitleLab.text = item.type + "/" + item.state + "/" + item.info;
            self.vip.isHidden = item.vip == 0;
            self.hitLab.text = "点击量" + item.hits;
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

class AVSearchCell : UITableViewCell {
    public lazy var titleLab : UILabel = {
        let label = UILabel.init();
        label.font = UIFont .systemFont(ofSize: 16);
        label.textColor = Appx333333;
        return label;
    }()
    private lazy var lineView : UIView = {
        let line = UIView.init();
        line.backgroundColor = Appxdddddd;
        return line;
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        loadUI();
    }
    private func loadUI(){
        self.contentView.addSubview(self.titleLab);
        self.titleLab.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(12);
            make.top.equalToSuperview().offset(20);
            make.bottom.equalToSuperview().offset(-20);
            make.right.equalToSuperview().offset(-12);
        }
        self.contentView.addSubview(self.lineView);
        self.lineView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview();
            make.height.equalTo(0.5);
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
