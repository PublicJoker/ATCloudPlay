//
//  AVPlayController.swift
//  AVTVObject
//
//  Created by wangws1990 on 2020/4/27.
//  Copyright © 2020 wangws1990. All rights reserved.
//

import UIKit
import SnapKit

class AVPlayController: BaseConnectionController,playerDelegate,playVideoDelegate {

    var info : AVMovieInfo? = nil;
    var _playItem : AVItem?
    var playItem : AVItem?{
        set{
            _playItem = newValue;
        }get{
            return _playItem;
        }
    }
    lazy var listData : [AVItem] = {
        return []
    }()
    class func vcWithMovieId(movieId : String) -> Self{
        let vc = AVPlayController.init();
        vc.movieId = movieId ;
        return vc as! Self
    }
    lazy var player : TVPlayer = {
        let player = TVPlayer();
        player.delegate = self;
        return player
    }()
    lazy var playerView: UIView = {
        let view : UIView = UIView.init();
        view.backgroundColor = UIColor.black;
        return view;
    }()
    lazy var playView : AVPlayView = {
        let playView = AVPlayView.instanceView();
        playView.favBtn.addTarget(self, action: #selector(favAction(sender:)), for: .touchUpInside)
        playView.delegate = self;
        return playView;
    }()
    lazy var backBtn : UIButton = {
        let btn : UIButton = UIButton.init();
        btn.setImage(UIImage.init(named:"icon_nav_back_w"), for: .normal);
        btn.addTarget(self, action: #selector(goBackAction), for: .touchUpInside);
        return btn;
    }()
    var movieId : String? = nil;
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUI()
        loadDataQueue()
    }
    func loadUI(){
        self.fd_prefersNavigationBarHidden = true;
        self.view.backgroundColor = UIColor.white;
        self.view.addSubview(self.playerView);
        self.halfScreen();
        self.playerView.addSubview(self.player.contentView);
        self.player.contentView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        self.playerView.addSubview(self.playView);
        self.playView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview();
        }
        self.playerView.addSubview(self.backBtn);
        self.backBtn.snp.makeConstraints { (make) in
            make.width.height.equalTo(44);
            if #available(iOS 11.0, *) {
                make.left.equalTo(self.backBtn.superview!.safeAreaLayoutGuide).offset(10)
            } else {
                make.left.equalToSuperview().offset(10)
            }
            make.top.equalToSuperview();
        }
        self.setupEmpty(scrollView: self.collectionView);
        self.setupRefresh(scrollView: self.collectionView, options: .None);
        self.collectionView.snp.remakeConstraints { (make) in
            make.left.right.bottom.equalToSuperview();
            make.top.equalTo(self.playerView.snp_bottom);
        }
        self.view.sendSubviewToBack(self.playerView);
    }
    func loadData(){
        self.refreshData(page:RefreshPageStart)
    }
    override func refreshData(page: Int) {
        self.show();
        if self.movieId != nil {
            ApiMoya.apiMoyaRequest(target: .apiShow(movieId: self.movieId!), sucesss: { (json) in
                print(json);
                if let info = AVMovieInfo.deserialize(from: json.rawString()){
                    self.info = info;
                    self.reloadData();
                }
            }) { (error) in
                self.dismiss()
                ATAlertView.showAlertView(title: "网络问题,是否重试" + error, message: nil, normals: ["取消"], hights: ["确定"]) { (title , index) in
                    if index > 0{
                        self.loadData();
                    }else{
                        self.goBackAction()
                    }
                }
            };
        }
    }
    func reloadData(){
        self.playView.titleLab.text = self.info?.name;
        if (self.info?.routes.count)! > 0 {
            let info : AVRoute = (self.info?.routes.first)!;
            if info.items.count > 0 {
                AVBrowseDataQueue.getBrowseData(movieId: self.info!.movieId) { (model) in
                    if model.playUrl.count > 0{
                        let res = info.items.contains { (new) -> Bool in
                            return model.playUrl == new.playUrl;
                        }
                        var item = info.items.first;
                        if res{
                            let index = info.items.firstIndex { (new) -> Bool in
                                return model.playUrl == new.playUrl;
                            }
                            item = info.items[index ?? 0];
                            
                        }
                        self.playVideo(item: item!);
                    }else{
                        let item : AVItem = info.items.first!;
                        self.playVideo(item: item);
                    }
                }
                self.listData.append(contentsOf:info.items);
                self.collectionView.reloadData();
                self.endRefresh(more: false)
            }else{
                self.endRefreshFailure()
                self.dismiss()
                self.tryAgain(title: self.info!.name)
            }
        }else{
            self.endRefreshFailure()
            self.dismiss()
            self.tryAgain(title: self.info!.name)
        }
        
    }
    func playVideo(item:AVItem){
        if self.info != nil {
            self.info!.playUrl = item.playUrl;
            AVBrowseDataQueue.browseData(model: self.info!) { (success) in
                
            }
        }
        self.playItem = item;
        self.player.playUrl(url: item.playUrl);
        self.collectionView.reloadData();
    }
    func tryAgain(title : String){
        ATAlertView.showAlertView(title:title + "无法播放是否重试！", message: nil, normals:["取消"], hights:["重试"]) { (title, index) in
            if index > 0{
                self.loadData();
            }
        }
    }
    func loadDataQueue(){
        AVFavDataQueue.getFavData(movieId: self.movieId!) { (movie) in
            let res = movie.movieId.count > 0 ? true : false;
            self.playView.fav = res;
        }
    }
    @objc func goBackAction() {
        if self.playItem != nil {
            //存下播放进度
            if let info : AVItemInfo = AVItemInfo.deserialize(from:self.playItem?.toJSONString()){
                info.currentTime = self.player.current;
                AVPlayDataQueue.insertData(info: info) { (success) in
                    
                }
            }
        }
        BaseMacro.screen() ? orientations(screen: false) : self.goBack()
    }
    @objc func favAction(sender: UIButton){
        if sender.isSelected {
            AVFavDataQueue.cancleFavData(movieId: self.movieId!) { (success) in
                self.playView.fav = false
            }
        }else{
            if let info = AVMovie.deserialize(from: self.info?.toJSONString()) {
                AVFavDataQueue.favData(model:info) { (success) in
                    self.playView.fav = true;
                }
            }
        }
    }
    func orientations(screen:Bool){
        let delegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate;
        delegate.makeOrientation = screen ? (UIInterfaceOrientation.landscapeRight) : (UIInterfaceOrientation.portrait);
        kAppdelegate?.blockRotation = screen ?.landscapeRight :.portrait;
    }
    func fullScreen(){
        self.playerView.snp.remakeConstraints { (make) in
            make.edges.equalToSuperview();
        }
        self.collectionView.snp.remakeConstraints { (make) in
            make.top.bottom.right.equalToSuperview();
            make.width.equalTo(SCREEN_WIDTH);
        }
        self.playView.screen = true;
        self.collectionView.isHidden = self.playView.screen;
        
        self.collectionView.backgroundColor = Appx333333;
        self.collectionView.backgroundView?.backgroundColor = Appx333333
    }
    func halfScreen(){
        self.playerView.snp.remakeConstraints { (make) in
            make.left.right.equalToSuperview();
            make.top.equalToSuperview().offset(!iPhone_X ? 0 :STATUS_BAR_HIGHT);
            make.height.equalTo(SCREEN_WIDTH/16*9.0);
        }
        self.collectionView.snp.remakeConstraints { (make) in
            make.left.right.bottom.equalToSuperview();
            make.top.equalTo(self.playerView.snp.bottom);
        }
        self.playView.screen = false;
        self.collectionView.isHidden = self.playView.screen;
        self.collectionView.backgroundColor = Appxffffff;
        self.collectionView.backgroundView?.backgroundColor = Appxffffff;
    }
    func show(){
        if SVProgressHUD.isVisible() {
            SVProgressHUD.popActivity();
        }
        SVProgressHUD.setDefaultStyle(.custom)
        SVProgressHUD.setBackgroundColor(UIColor.clear);
        SVProgressHUD.setForegroundColor(Appxdddddd);
        SVProgressHUD.setBackgroundLayerColor(UIColor.clear);
        SVProgressHUD.setContainerView(self.playView);
        SVProgressHUD.show();
    }
    func dismiss(){
        if SVProgressHUD.isVisible() {
            SVProgressHUD.popActivity();
        }
        SVProgressHUD.dismiss();
    }
    //MARK: playerDelegate
    func player(player: BasePlayer, progress: TimeInterval) {
        self.playView.player(player: player, progress: progress);
    }
    func player(player: BasePlayer, cache: TimeInterval) {
        self.playView.player(player: player, cache: cache)
    }
    func player(player: BasePlayer, bufferState: BufferState) {
        switch bufferState {
        case .empty:
            self.show()
            break;
        default:
            self.dismiss();
            break;
        }
    }
    func player(player: BasePlayer, playerstate: PlayerState) {
        self.playView.player(player: player, playerstate: playerstate);
        if playerstate == .ready {
            self.dismiss();
        }
    }
    //MARK: playVideoDelegate
    func playView(playView: AVPlayView, pause: Bool) {
        self.player.playing ? self.player.pause() : self.player.resume();
    }
    func playView(playView: AVPlayView, screen: Bool) {
        self.orientations(screen:screen);
    }
    func playView(playView: AVPlayView, progress: TimeInterval) {
        self.player.seek(time: progress)
    }
    func playView(playView: AVPlayView, list: Bool) {
        if playView.screen {
            self.collectionView.isHidden = !list;
        }
    }
    //MARK: DataSource
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
        let width = (SCREEN_WIDTH - 4*top - 1)/3.0;
        return CGSize.init(width: width, height: 50)
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : AVPlayCell = AVPlayCell.cellForCollectionView(collectionView: collectionView, indexPath: indexPath);
        let item = self.listData[indexPath.row];
        cell.item = item;
        cell.selectCell = (item.itemId == self.playItem?.itemId);
        return cell;
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = self.listData[indexPath.row];
        self.playVideo(item: item)
        self.collectionView.reloadData();
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        self.fd_interactivePopDisabled = size.width > size.height;
        size.width > size.height ? self.fullScreen() : self.halfScreen();
        if SVProgressHUD.isVisible() {
            self.show();
        }
    }
    override var shouldAutorotate: Bool{
        return true;
    }
    override var prefersStatusBarHidden: Bool{
        return true;
    }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        return .all;
    }
    
}
