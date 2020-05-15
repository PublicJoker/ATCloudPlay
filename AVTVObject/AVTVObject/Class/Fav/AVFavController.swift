//
//  AVFavController.swift
//  AVTVObject
//
//  Created by wangws1990 on 2020/4/26.
//  Copyright © 2020 wangws1990. All rights reserved.
//

import UIKit
import ATKit_Swift
class AVFavController: BaseConnectionController {

    private lazy var listData : [AVMovie] = {
        return []
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupEmpty(scrollView: self.collectionView);
        self.setupRefresh(scrollView: self.collectionView, options: .defaults)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        self.refreshData(page:RefreshPageStart)
    }
    override func refreshData(page: Int) {
        let size : Int = RefreshPageSize;
        AVFavDataQueue.getFavDatas(page: page, size: size) { (listData) in
            if page == RefreshPageStart{
                self.listData.removeAll()
            }
            self.listData.append(contentsOf: listData);
//            self.listData = AVFavDataQueue.sortDatas(listDatas: self.listData, ascending: false);
            self.collectionView.reloadData();
            self.endRefresh(more: listData.count >= size)
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
        let width = itemWidth;
        return CGSize.init(width: width, height: width*1.25)
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : AVHomeCell = AVHomeCell.cellForCollectionView(collectionView: collectionView, indexPath: indexPath);
        cell.model = self.listData[indexPath.row]
        return cell;
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = self.listData[indexPath.row]
        AppJump.jumpToPlayControl(movieId: model.movieId)
    }
}
