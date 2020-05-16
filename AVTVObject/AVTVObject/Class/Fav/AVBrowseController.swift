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
        AVBrowseDataQueue.getBrowseDatas(page:page, size: RefreshPageSize) { (listData) in
            if page == RefreshPageStart{
                self.listData.removeAll();
            }
            self.listData.append(contentsOf: listData);
    //        self.listData = AVBrowseDataQueue.sortDatas(listDatas: self.listData, ascending: false)
            self.collectionView.reloadData();
            self.endRefresh(more:listData.count >= RefreshPageSize);
        }
    }
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
           return 1;
       }
       override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
           return self.listData.count;
       }
       override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
           return itemTop;
       }
       override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
           return itemTop;
       }
       override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
           return UIEdgeInsets(top:itemTop, left: itemTop, bottom: 0, right: itemTop);
       }
       override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let width = itemWidth
            return CGSize.init(width: width, height:CGFloat(width/5*3.0))
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
