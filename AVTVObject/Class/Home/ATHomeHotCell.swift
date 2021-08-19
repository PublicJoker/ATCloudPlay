//
//  ATHomeHotCell.swift
//  AVTVObject
//
//  Created by Tony-sg on 2020/6/12.
//  Copyright © 2020 Tony-sg. All rights reserved.
//

import UIKit

class ATHomeHotCell: UICollectionViewCell {

    @IBOutlet weak var imageV: UIImageView!
    @IBOutlet weak var pfLab: UIButton!
    @IBOutlet weak var titleLab: UILabel!
    @IBOutlet weak var subTitleLab: UILabel!
    var model : AVMovie?{
        didSet{
            guard let item = model else { return }
            self.imageV.kf.setImage(with: URL.init(string: item.pic),placeholder: placeholder)
            self.titleLab.text = item.name
            self.pfLab.setTitle("评分" + item.pf, for: .normal)
            self.subTitleLab.text = item.info + " " + item.state
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.pfLab.layer.masksToBounds = true
        self.pfLab.layer.cornerRadius = 8
        self.imageV.layer.masksToBounds = true
        self.imageV.layer.cornerRadius = AppRadius
        // Initialization code
    }

}
