//
//  AVPlayController.swift
//  AVTVObject
//
//  Created by wangws1990 on 2020/4/27.
//  Copyright © 2020 wangws1990. All rights reserved.
//

import UIKit

class AVPlayController: BaseViewController,playerDelegate,playVideoDelegate {

    var info : AVMovieInfo? = nil;
    class func vcWithMoveId(movieId : String) -> Self{
        let vc = AVPlayController.init();
        vc.movieId = movieId;
        return vc as! Self
    }
    var movieId : String? = nil;
    lazy var player : GKVideoPlayer = {
        let player = GKVideoPlayer();
        player.delegate = self;
        return player
    }()
    lazy var playerView: UIView = {
        let view : UIView = UIView.init();
        view.backgroundColor = UIColor.black;
        return view;
    }()
    lazy var playView : GKPlayView = {
        let playView = GKPlayView.instanceView();
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
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUI()
        loadData()
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
    }
    func loadData(){
        self.show();
        if self.movieId != nil {
            ApiMoya.apiMoyaRequest(target: .apiShow(movieId: self.movieId!), sucesss: { (json) in
                print(json);
                if let info = AVMovieInfo.deserialize(from: json.rawString()){
                    self.info = info;
                    self.playVideo();
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
    func playVideo(){
        self.playView.titleLab.text = self.info?.name;
        if (self.info?.zu.count)! > 0 {
            let info : AVItemInfo = (self.info?.zu.first)!;
            if info.ji.count > 0 {
                let item : AVItem = info.ji.first!;
                self.player.playUrl(url: item.playUrl);
            }else{
                self.dismiss()
                self.tryAgain(title: self.info!.name)
            }
        }else{
            self.dismiss()
            self.tryAgain(title: self.info!.name)
        }
        
    }
    func tryAgain(title : String){
        ATAlertView.showAlertView(title:title + "无法播放是否重试！", message: nil, normals:["取消"], hights:["重试"]) { (title, index) in
            if index > 0{
                self.loadData();
            }
        }
    }
    @objc func goBackAction() {
        BaseMacro.screen() ? orientations(screen: false) : self.goBack()
    }
    @objc func favAction(sender: UIButton){
        
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
    }
    func halfScreen(){

        self.playerView.snp.remakeConstraints { (make) in
            make.left.right.equalToSuperview();
            make.top.equalToSuperview().offset(!iPhone_X ? 0 :STATUS_BAR_HIGHT);
            make.height.equalTo(SCREEN_WIDTH/16*9.0);
        }
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
    //mark playerDelegate
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
    //mark playVideoDelegate
    func playView(playView: GKPlayView, pause: Bool) {
        self.player.playing ? self.player.pause() : self.player.resume();
    }
    func playView(playView: GKPlayView, screen: Bool) {
        self.orientations(screen:screen);
    }
    func playView(playView: GKPlayView, progress: TimeInterval) {
        self.player.seek(time: progress)
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
