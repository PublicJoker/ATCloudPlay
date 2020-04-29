//
//  AVHomeMoreController.swift
//  AVTVObject
//
//  Created by wangws1990 on 2020/4/26.
//  Copyright © 2020 wangws1990. All rights reserved.
//

import UIKit
import SwiftyJSON

class AVHomeMoreController: BaseConnectionController {
    class func vcWithMovieId(movieId:String?) -> Self{
        let vc : AVHomeMoreController = AVHomeMoreController.init();
        vc.movieId = movieId ?? "";
        return vc as! Self;
    }
    class func vcWithMovieId(ztid:String?) -> Self{
        let vc : AVHomeMoreController = AVHomeMoreController.init();
        vc.ztid = ztid ?? "";
        return vc as! Self;
    }
    var movieId : String = "";
    var ztid : String = "";
    lazy var listData : [AVMovie] = {
        return []
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showNavTitle(title: "更多");
        self.setupEmpty(scrollView: self.collectionView);
        self.setupRefresh(scrollView: self.collectionView, options: .Default);
    }
    override func refreshData(page: Int) {
        if self.movieId.count > 0 {
            ApiMoya.apiMoyaRequest(target:.apiMovieMore(page: page, size: RefreshPageSize, movieId:self.movieId), sucesss: { (json) in
                if let data = [AVMovie].deserialize(from: json.rawString()){
                    let list = data as! [AVMovie];
                    self.listData.append(contentsOf: list);
                    self.collectionView.reloadData();
                    self.endRefresh(more: list.count >= RefreshPageSize);
                }else{
                    self.endRefreshFailure();
                }
            }) { (error) in
                self.endRefreshFailure();
            }
        }else if(self.ztid.count > 0){
            ApiMoya.apiMoyaRequest(target: .apiHomeMore(page: page, size: RefreshPageSize, ztid: self.ztid), sucesss: { (json) in
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
            self.endRefresh(more: list.count >= RefreshPageSize);
        }else{
            self.endRefreshFailure();
        }
    }
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1;
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.listData.count;
    }
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return top;
    }
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return top;
    }
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top:top, left: top, bottom: 0, right: top);
    }
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = CGFloat((SCREEN_WIDTH - 3*top - 1)/2);
        return CGSize.init(width: width, height: width*1.25)
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : AVHomeCell = AVHomeCell.cellForCollectionView(collectionView: collectionView, indexPath: indexPath);
        cell.model = self.listData[indexPath.row]
        return cell;
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let info = self.listData[indexPath.row]
        AppJump.jumpToPlayControl(movieId: info.movieId);
    }

}
