//
//  AVHomeHotContrller.swift
//  AVTVObject
//
//  Created by wangws1990 on 2020/4/26.
//  Copyright © 2020 wangws1990. All rights reserved.
//

import UIKit
import ATRefresh_Swift
class AVHomeHotContrller: BaseConnectionController {
    //热门
    convenience init(movieId:String) {
        self.init()
        self.movieId = movieId
    }
    private var  movieId :String? = ""
    private lazy var listData : [AVHomeInfo] = {
        return []
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.layout.sectionHeadersPinToVisibleBounds = true;
        self.collectionView.backgroundColor = Appxffffff;
        self.setupEmpty(scrollView: self.collectionView);
        self.setupRefresh(scrollView: self.collectionView, options:ATRefreshOption(rawValue: ATRefreshOption.autoHeader.rawValue|ATRefreshOption.header.rawValue));
    }
    override func refreshData(page: Int) {
        if self.movieId!.count > 0 {
            ApiMoya.apiRequest(target: ApiMoya.apiMovie(movieId: self.movieId!, vsize: "15"), model: AVHome.self, sucesss: { (model) in
                if page == RefreshPageStart{
                    self.listData.removeAll()
                }
                self.listData = model.data
                self.collectionView.reloadData()
                self.endRefresh(more: false)
            }) { (error) in
                self.endRefreshFailure()
            }
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
        return 10;
    }
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10;
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize.init(width: SCREEN_WIDTH, height:40)
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let reusableView : AVHomeReusableView = AVHomeReusableView.viewForCollectionView(collectionView: collectionView, elementKind: kind, indexPath: indexPath);
        reusableView.info = self.listData[indexPath.section];
        return reusableView;
    }
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top:0, left: 10, bottom: 5, right: 10);
    }
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width        :CGFloat = CGFloat((SCREEN_WIDTH - 4*10)/3 - 0.1);
        let height       :CGFloat = width*1.45 + 50;
        return CGSize.init(width: width, height: height)
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : ATHomeHotCell = ATHomeHotCell.cellForCollectionView(collectionView: collectionView, indexPath: indexPath)
        let info : AVHomeInfo = self.listData[indexPath.section]
        cell.model = info.listData[indexPath.row]
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let info : AVHomeInfo = self.listData[indexPath.section];
        let model = info.listData[indexPath.row]
        AppJump.jumpToPlayControl(movieId: model.movieId)
    }

}
