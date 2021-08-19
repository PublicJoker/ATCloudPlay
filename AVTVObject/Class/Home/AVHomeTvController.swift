//
//  AVHomeTvController.swift
//  AVTVObject
//
//  Created by Tony-sg on 2020/4/26.
//  Copyright © 2020 Tony-sg. All rights reserved.
//

import UIKit
import ATRefresh_Swift
class AVHomeTvController: BaseConnectionController {
    private lazy var listData : [AVHomeInfo] = {
        return []
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.layout.sectionHeadersPinToVisibleBounds = true;
        self.setupRefresh(scrollView: self.collectionView, options:ATRefreshOption(rawValue: ATRefreshOption.autoHeader.rawValue|ATRefreshOption.header.rawValue));

    }
    override func refreshData(page: Int) {
//        ApiMoya.apiMoyaRequest(target: .apiMovie(movieId: "1", vsize: "15"), sucesss: { (json) in
//            if let data = [AVHomeInfo].deserialize(from: json.rawString()){
//                self.listData = data as! [AVHomeInfo];
//                self.collectionView.reloadData();
//                self.endRefresh(more: false);
//            }else{
//                self.endRefreshFailure();
//            }
//        }) { (error) in
//            self.endRefreshFailure();
//        }
        ApiMoya.apiRequest(target: .apiMovie(movieId: "1", vsize: "15"), model: AVHome.self, sucesss: { (object) in
            self.listData = object.data
            self.collectionView.reloadData()
            self.endRefresh(more: false)
        }) { (error) in
            self.endRefreshFailure()
        }
    }
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.listData.count;
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let info : AVHomeInfo = self.listData[section];
        return info.listData.count;
    }
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return itemTop;
    }
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return itemTop;
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize.init(width: SCREEN_WIDTH, height: 40)
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let reusableView : AVHomeReusableView = AVHomeReusableView.viewForCollectionView(collectionView: collectionView, elementKind: kind, indexPath: indexPath);
        reusableView.info = self.listData[indexPath.section];
        return reusableView;
    }
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top:0, left: itemTop, bottom: 0, right: itemTop);
    }
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: itemWidth, height:itemHeight)
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : AVHomeCell = AVHomeCell.cellForCollectionView(collectionView: collectionView, indexPath: indexPath);
        let info : AVHomeInfo = self.listData[indexPath.section];
        cell.model = info.listData[indexPath.row]
        return cell;
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let info : AVHomeInfo = self.listData[indexPath.section];
        let model = info.listData[indexPath.row]
        AppJump.jumpToPlayControl(movieId: model.movieId)
    }

}
