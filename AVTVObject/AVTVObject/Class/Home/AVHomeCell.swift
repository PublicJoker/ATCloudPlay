//
//  AVHomeCell.swift
//  AVTVObject
//
//  Created by wangws1990 on 2020/4/26.
//  Copyright © 2020 wangws1990. All rights reserved.
//

import UIKit
import Kingfisher

class AVHomeCell: UICollectionViewCell {

    @IBOutlet weak var imageV: UIImageView!
    @IBOutlet weak var titleLab: UILabel!
    var model : AVMovie = AVMovie(){
        didSet{
            let item = model;
            self.titleLab.text = item.name;
            self.imageV.kf.setImage(with: URL.init(string: item.pic),placeholder: placeholder);
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
