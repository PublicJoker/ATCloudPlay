//
//  AVBrowseController.swift
//  AVTVObject
//
//  Created by wangws1990 on 2020/4/29.
//  Copyright © 2020 wangws1990. All rights reserved.
//

import UIKit

class AVBrowseController: BaseConnectionController {

    private lazy var listData : [AVMovieInfo] = {
        return []
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showNavTitle(title: "观看记录");
        self.setupEmpty(scrollView: self.collectionView);
        self.setupRefresh(scrollView: self.collectionView, options: .defaults);
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        self.refreshData(page: RefreshPageStart);
    }
    override func refreshData(page: Int) {
        let size = Int(RefreshPageSize);
        AVBrowseDataQueue.getBrowseDatas(page:page, size: size) { (listData) in
            if page == RefreshPageStart{
                self.listData.removeAll();
            }
            self.listData.append(contentsOf: listData);
            self.collectionView.reloadData();
            self.endRefresh(more:listData.count >= size);
        }
    }
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
           return 1;
       }
       override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
           return self.listData.count;
       }
       override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
           return 1;
       }
       override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
           return 0;
       }
       override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
           return UIEdgeInsets(top:0, left: 0, bottom: 0, right: 0);
       }
       override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let width = SCREEN_WIDTH
            let height = SCREEN_WIDTH/16*9.0;
            return CGSize.init(width: width, height:height)
       }
       override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
           let cell : AVBrowseCell = AVBrowseCell.cellForCollectionView(collectionView: collectionView, indexPath: indexPath);
           cell.info = self.listData[indexPath.row]
           return cell;
       }
       override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
           let model = self.listData[indexPath.row]
           AppJump.jumpToPlayControl(movieId: model.movieId)
       }
}
