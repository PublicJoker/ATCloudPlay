//
//  AVBrowseCell.swift
//  AVTVObject
//
//  Created by wangws1990 on 2020/4/29.
//  Copyright © 2020 wangws1990. All rights reserved.
//

import UIKit

class AVBrowseCell: UICollectionViewCell {
    @IBOutlet weak var imageV: UIImageView!
    @IBOutlet weak var titleLab: UILabel!
    @IBOutlet weak var currentLab: UILabel!
    @IBOutlet weak var totalLab: UILabel!
    
    var info : AVMovieInfo = AVMovieInfo(){
        didSet{
            let item =  info;
            self.imageV.kf.setImage(with: URL.init(string: item.pic));
            self.titleLab.text = item.name;
            self.totalLab.text = ATTime.totalTimeTurnToTime(timeStamp: item.playItem.totalTime);
            let his = String(format:"%.1f",Float(item.playItem.currentTime/item.playItem.totalTime*100))
            self.currentLab.text = "观看了" + his + "%";
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
