//
//  AVHomeIndexController.swift
//  AVTVObject
//
//  Created by wangws1990 on 2020/4/26.
//  Copyright © 2020 wangws1990. All rights reserved.
//

import UIKit

class AVHomeIndexController: BaseConnectionController {

        lazy var listData : [AVHomeInfo] = {
            return []
        }()
        override func viewDidLoad() {
            super.viewDidLoad()
            self.layout.sectionHeadersPinToVisibleBounds = true;
            self.setupEmpty(scrollView: self.collectionView);
            self.setupRefresh(scrollView: self.collectionView, options:ATRefreshOption(rawValue: ATRefreshOption.AutoHeader.rawValue|ATRefreshOption.Header.rawValue));
        }
        override func refreshData(page: Int) {
            ApiMoya.apiMoyaRequest(target: .apiHome(vsize: "15"), sucesss: { (json) in
                if let data = [AVHomeInfo].deserialize(from: json.rawString()){
                    self.listData = data as! [AVHomeInfo];
                    self.collectionView.reloadData();
                    self.endRefresh(more: false);
                }else{
                    self.endRefreshFailure();
                }
            }) { (error) in
                self.endRefreshFailure();
            }
        }
        override func numberOfSections(in collectionView: UICollectionView) -> Int {
            return self.listData.count;
        }
        override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            let info : AVHomeInfo = self.listData[section];
            return info.vod.count;
        }
        override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return top;
        }
        override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return top;
        }
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
            return CGSize.init(width: SCREEN_WIDTH, height: 50)
        }
        func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
            let reusableView : AVHomeReusableView = AVHomeReusableView.viewForCollectionView(collectionView: collectionView, elementKind: kind, indexPath: indexPath);
            let info : AVHomeInfo = self.listData[indexPath.section];
            info.index = true;
            reusableView.info = info;
            return reusableView;
        }
        override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            return UIEdgeInsets(top:0, left: top, bottom: 0, right: top);
        }
        override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let width = (SCREEN_WIDTH - 3*top - 1)/2.0;
            return CGSize.init(width: width, height: width*1.35 + 35)
        }
        override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell : AVHomeCell = AVHomeCell.cellForCollectionView(collectionView: collectionView, indexPath: indexPath);
            let info : AVHomeInfo = self.listData[indexPath.section];
            cell.model = info.vod[indexPath.row]
            return cell;
        }
        override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            let info : AVHomeInfo = self.listData[indexPath.section];
            let model = info.vod[indexPath.row]
            AppJump.jumpToDetailControl(movieId: model.movieId)
        }

}
