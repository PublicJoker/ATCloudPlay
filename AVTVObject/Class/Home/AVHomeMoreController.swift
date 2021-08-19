//
//  AVHomeMoreController.swift
//  AVTVObject
//
//  Created by Tony-sg on 2020/4/26.
//  Copyright © 2020 Tony-sg. All rights reserved.
//

import UIKit
import SwiftyJSON
private let pageSize = RefreshPageSize + 1
class AVHomeMoreController: BaseConnectionController {
    convenience init(movieId : String? = nil, ztid : String? = nil) {
        self.init();
        self.movieId = movieId ?? "";
        self.ztid = ztid ?? "";
    }
    private var movieId : String = "";
    private var ztid : String = "";
    private lazy var listData : [AVMovie] = {
        return []
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showNavTitle(title: "更多");
        self.setupRefresh(scrollView: self.collectionView, options: .defaults);
    }
    override func refreshData(page: Int) {
        if self.movieId.count > 0 {
            ApiMoya.apiMoyaRequest(target:.apiMovieMore(page: page, size: pageSize, movieId:self.movieId), sucesss: { (json) in
                if(page == RefreshPageStart){
                    self.listData.removeAll()
                }
                if let data = [AVMovie].deserialize(from: json.rawString()){
                    let list = data as! [AVMovie];
                    self.listData.append(contentsOf: list);
                    self.collectionView.reloadData();
                    self.endRefresh(more: list.count >= pageSize);
                }else{
                    self.endRefreshFailure();
                }
            }) { (error) in
                self.endRefreshFailure();
            }
        }else if(self.ztid.count > 0){
            ApiMoya.apiMoyaRequest(target: .apiHomeMore(page: page, size: pageSize, ztid: self.ztid), sucesss: { (json) in
                if(page == RefreshPageStart){
                    self.listData.removeAll()
                }
                self.reloadData(json: json);
            }) { (error) in
                self.endRefreshFailure();
            }
        }
    }
    func reloadData(json : JSON){
        if let data = [AVMovie].deserialize(from: json.rawString()){
            let list = data as! [AVMovie];
            self.listData.append(contentsOf: list);
            self.collectionView.reloadData();
            self.endRefresh(more: list.count >= pageSize)
        }else{
            self.endRefreshFailure();
        }
    }
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1;
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.listData.count
    }
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return itemTop
    }
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return itemTop
    }
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top:itemTop, left: itemTop, bottom: 0, right: itemTop)
    }
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: itemWidth, height: itemHeight)
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : AVHomeCell = AVHomeCell.cellForCollectionView(collectionView: collectionView, indexPath: indexPath);
        cell.model = self.listData[indexPath.row]
        return cell;
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let info = self.listData[indexPath.row]
        AppJump.jumpToPlayControl(movieId: info.movieId)
    }

}
