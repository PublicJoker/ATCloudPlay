//
//  AVSearchController.swift
//  AVTVObject
//
//  Created by wangws1990 on 2020/4/26.
//  Copyright © 2020 wangws1990. All rights reserved.
//

import UIKit

class AVSearchController: BaseTableViewController,searchDelegate {
    lazy var listData : [Any] = {
        return []
    }()
    var _keyWord : String?
    var keyWord  : String?{
        set{
            _keyWord = newValue ?? "";
            self.refreshData(page:RefreshPageStart);
        }get{
            return _keyWord ?? "";
        }
    }
    lazy var searchView : AVSearchView = {
        let searchView = AVSearchView.instanceView();
        searchView.delegate = self
        searchView.backBtn.addTarget(self, action: #selector(goBack), for: .touchUpInside);
        return searchView;
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fd_prefersNavigationBarHidden = true;
        self.view.addSubview(self.searchView);
        self.searchView.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview();
            make.height.equalTo(NAVI_BAR_HIGHT);
        }
        self.tableView.snp.remakeConstraints { (make) in
            make.left.right.bottom.equalToSuperview();
            make.top.equalTo(self.searchView.snp_bottom);
        }
        self.setupEmpty(scrollView: self.tableView);
        self.setupRefresh(scrollView: self.tableView, options: .Default);
    }
    override func refreshData(page: Int) {
        if self.keyWord!.count > 0{
            MBProgressHUD.show(to: self.view) { (hud) in
                ApiMoya.apiMoyaRequest(target: .apiSearch(page: page, size: RefreshPageSize, keyWord: self.keyWord!), sucesss: { (json) in
                    hud?.hide(animated: true)
                    if let datas = [AVMovie].deserialize(from: json.rawString()){
                        if page == RefreshPageStart {
                            self.listData.removeAll();
                        }
                        self.listData.append(contentsOf: datas as [Any]);
                        self.tableView.reloadData();
                        self.endRefresh(more: datas.count >= RefreshPageSize);
                    }else{
                        self.endRefreshFailure();
                    }
                }) { (error) in
                    hud?.hide(animated: true)
                    self.endRefreshFailure();
                }
            }
        }else{
            AVSearchDataQueue.getKeyWords(page: page, size: RefreshPageSize) { (datas) in
                if page == RefreshPageStart{
                    self.listData.removeAll();
                }
                self.listData.append(contentsOf: datas);
                self.tableView.reloadData();
                self.endRefresh(more: datas.count >= RefreshPageSize);
            }
        }
    }
    func searchText(text : String){
        self.keyWord = text;
        if text.count > 0 {
            let keyWord = text.trimmingCharacters(in: .whitespacesAndNewlines);
            self.inseartData(keyWord: keyWord);
        }else{
            self.refreshData(page: RefreshPageStart)
        }
    }
    func inseartData(keyWord : String){
        if keyWord.count > 0 {
            AVSearchDataQueueOC.insertData(toDataBase: keyWord) { (success) in
                
            }
        }
    }
    func searchView(searchView: AVSearchView, keyWord: String) {
        self.searchText(text: keyWord);
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listData.count;
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension;
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let object = self.listData[indexPath.row];
        if object is String{
            let cell = AVSearchCell.cellForTableView(tableView: tableView, indexPath: indexPath);
            cell.titleLab.text = (self.listData[indexPath.row] as! String);
            return cell;
        }else if object is AVMovie{
            let cell = AVSearchResultCell.cellForTableView(tableView: tableView, indexPath: indexPath);
            cell.model = (object as! AVMovie)
            return cell;
        }
        return UITableViewCell.cellForTableView(tableView: tableView, indexPath: indexPath);
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true);
        let object = self.listData[indexPath.row];
        if object is String{
            self.searchText(text: (object as! String))
            self.searchView.keyWord = self.keyWord;

        }else if object is AVMovie{
            let model : AVMovie = object as! AVMovie;
            AppJump.jumpToDetailControl(movieId: model.movieId);
        }
    }
}
