//
//  GKVideoPlayer.swift
//  GKGame_Swift
//
//  Created by wangws1990 on 2020/4/15.
//  Copyright © 2020 wangws1990. All rights reserved.
//

import UIKit
import AVFoundation
enum PathVideo : String {
    case rate = "rate";
    case status = "status";
    case bounds = "bounds";
    case loadedTimeRanges = "loadedTimeRanges";
    case playbackBufferEmpty = "playbackBufferEmpty";
    case playbackLikelyToKeepUp = "playbackLikelyToKeepUp";
}
class GKVideoPlayer: BasePlayer {
    
    var state : PlayerState?{
        didSet{
            let playerState  = state;
            if let delegate = self.delegate {
                delegate.player?(player: self, playerstate: playerState!);
            }
        }
    };
    var player : AVPlayer? = nil;
    var playerItem : AVPlayerItem? = nil;
    var playerLayer : AVPlayerLayer? = nil;
    var observer :Any? = nil;
    
    var seek : Bool = false;
    var userPause : Bool = false;
    deinit {
        self.releasePlayer()
    }
    func initData(){
        self.state = .prepare
    }
    func releasePlayer(){
        NotificationCenter.default.removeObserver(self);
        if self.playerItem != nil {
            self.playerItem?.removeObserver(self, forKeyPath: PathVideo.status.rawValue);
            self.playerItem?.removeObserver(self, forKeyPath: PathVideo.loadedTimeRanges.rawValue);
            self.playerItem?.removeObserver(self, forKeyPath: PathVideo.playbackBufferEmpty.rawValue);
            self.playerItem?.removeObserver(self, forKeyPath: PathVideo.playbackLikelyToKeepUp.rawValue);
        }
        if self.player != nil {
            self.player?.removeObserver(self, forKeyPath: PathVideo.rate.rawValue);
            self.player?.removeTimeObserver(observer as Any)
            self.contentView.removeObserver(self, forKeyPath: PathVideo.bounds.rawValue);
        }
        if self.playerLayer?.superlayer != nil{
            self.playerLayer?.removeFromSuperlayer();
        }
        self.playerLayer = nil;
        self.playerItem = nil;
        self.observer = nil;
    }
    func addNotification(){
        self.playerItem?.addObserver(self, forKeyPath: PathVideo.status.rawValue, options: .new, context: nil);
        self.playerItem?.addObserver(self, forKeyPath: PathVideo.loadedTimeRanges.rawValue, options: .new, context: nil);
        self.playerItem?.addObserver(self, forKeyPath: PathVideo.playbackBufferEmpty.rawValue, options: .new, context: nil);
        self.playerItem?.addObserver(self, forKeyPath: PathVideo.playbackLikelyToKeepUp.rawValue, options: .new, context: nil);
        self.player?.addObserver(self, forKeyPath: PathVideo.rate.rawValue, options: .new, context: nil);
        self.contentView.addObserver(self, forKeyPath:PathVideo.bounds.rawValue, options: .new, context: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidPlayToEnd), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.playerItem)
        NotificationCenter.default.addObserver(self, selector: #selector(appDidEnterBackground), name: UIApplication.willResignActiveNotification, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(appDidEnterPlayGround), name: UIApplication.didBecomeActiveNotification, object: nil);
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        DispatchQueue.main.async {
            switch keyPath {
            case PathVideo.loadedTimeRanges.rawValue:
                let item : AVPlayerItem = object as! AVPlayerItem;
                self.playerItem = item;
                self.progressCache(item: item);
                break;
            case PathVideo.bounds.rawValue:
                let view : UIView  = object as! UIView
                self.playerLayer?.frame = CGRect.init(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height);
                break;
            case PathVideo.playbackBufferEmpty.rawValue:
                if self.playerItem!.isPlaybackBufferEmpty {
                    if let delegate = self.delegate{
                        delegate.player?(player: self, bufferState: .empty)
                    }
                }
                break;
            case PathVideo.playbackLikelyToKeepUp.rawValue:
                if self.playerItem!.isPlaybackLikelyToKeepUp {
                    if let delegate = self.delegate{
                        delegate.player?(player: self, bufferState: .full)
                    }
                }
                break;
            case PathVideo.rate.rawValue:
                let player : AVPlayer = object as! AVPlayer;
                self.player = player;
                if (player.error != nil) {
                    self.state = .error;
                }else if(player.timeControlStatus == .paused){
                    if self.userPause {
                        self.state = .paused;
                    }
                }else if(player.timeControlStatus == .playing){
                    self.state = .played;
                }else if (player.timeControlStatus == .waitingToPlayAtSpecifiedRate){
                    self.state = .empty;
                }
                break;
            case PathVideo.status.rawValue:
                let item : AVPlayerItem = object as! AVPlayerItem;
                self.playerItem = item;
                if item.status == .readyToPlay {
                    self.state = .ready;
                    if self.userPause == false {
                        self.play();
                    }
                }else{
                    self.state = .error;
                }
                break;
            default:
                break;
            }
        }
    }
    func progressCache(item : AVPlayerItem){
        let loadedTimeRanges : [NSValue] = playerItem!.loadedTimeRanges;
        if loadedTimeRanges.count > 0 {
            let timeRange = loadedTimeRanges.first?.timeRangeValue;
            let startSeconds = CMTimeGetSeconds(timeRange!.start);
            let durationSeconds = CMTimeGetSeconds(timeRange!.duration);
            var timeInterval = startSeconds + durationSeconds;
            timeInterval = timeInterval.isNaN ? 0 : timeInterval
            let duration = CMTimeGetSeconds(playerItem!.duration);
            if let delegate  = self.delegate{
                if duration > 0 {
                    delegate.player?(player: self, cache: (timeInterval));
                }
            }
        }
        
    }
    @objc func playerItemDidPlayToEnd(){
        self.state = .finish;
    }
    @objc func appDidEnterBackground(){
        if (self.player != nil) {
            self.player?.pause();
        }
    }
    @objc func appDidEnterPlayGround(){
        if self.userPause == false {
            self.resume();
        }
    }
    func readyPlay(){
        if self.player != nil {
            weak var weakSelf = self;
            observer = self.player?.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(0.1, preferredTimescale: Int32(NSEC_PER_SEC)), queue: DispatchQueue.main, using: { (time) in
                if weakSelf != nil{
                    if weakSelf!.seek == false{
                        var progress = CMTimeGetSeconds(time);
                        progress = progress.isNaN ? 0 : progress;
                        if let delegate  = weakSelf!.delegate{
                            delegate.player?(player: weakSelf!, progress:progress);
                        }
                    }
                }
            });
        }
    }
    override func playUrl(url: String) {
        assert(url.count != 0);
        self.releasePlayer();
        let string : NSString = url as NSString;
        let loc = string.range(of: "/").location;
        
        let urlPath : URL = (loc == 0) ? URL.init(fileURLWithPath: url) : URL.init(string: url)!;
       // let urlAsset  = AVURLAsset.init(url: urlPath);
        self.playerItem = AVPlayerItem.init(url: urlPath)
        if self.player == nil {
            self.player = AVPlayer.init(playerItem: self.playerItem);
        }else{
            self.player?.replaceCurrentItem(with: self.playerItem);
        }
        self.player?.automaticallyWaitsToMinimizeStalling = false;
        self.playerLayer = AVPlayerLayer.init(player: self.player);
        self.playerLayer?.videoGravity = .resizeAspect;
        self.contentView.layer.insertSublayer(self.playerLayer!, at: 0);
        self.playerLayer?.frame = self.contentView.frame;
        self.readyPlay();
        self.addNotification();
        self.play();
    }
    override func play() {
        if self.userPause == false {
            self.playVideo();
        }
    }
    func playVideo(){
        if self.player != nil {
            self.player?.play();
            self.player?.rate = 1.0;
        }
    }
    override func stop() {
        self.pause();
        self.releasePlayer();
        self.state = .stoped;
    }
    override func resume() {
        self.userPause = false;
        self.play();
    }
    override func pause() {
        self.userPause = true;
        self.pauseVideo();
    }
    func pauseVideo(){
        if self.player != nil {
            self.player?.pause();
            self.player?.rate = 0.0;
        }
    }
    override func seek(time: TimeInterval) {
        if self.player != nil {
          let  time1 = time >= self.duration ? 0 : time;
          let  time2 = time1 < 0 ? 0 : time1;
            self.seek = true;
            self.player?.pause();
            weak var weakSelf = self;
            self.player?.seek(to: CMTimeMake(value: Int64(time2), timescale: 1), toleranceBefore:CMTime.zero, toleranceAfter: CMTime.zero, completionHandler: { (finish) in
                weakSelf?.seek = !finish;
                if (weakSelf?.userPause == false){
                    weakSelf?.playVideo();
                }
            })
        }
    }
    public var playing: Bool{
        get{
            if self.player != nil {
                let res = self.player?.timeControlStatus == .playing
                return res;
            }
            return false;
        }
    }
    public var duration: TimeInterval{
        get{
            if self.playerItem != nil {
                let time = CMTimeGetSeconds(self.playerItem!.duration);
                return time.isNaN ? 0 : time;
            }
            return 0
        }
    }
    public var current: TimeInterval{
        get{
            if self.playerItem != nil {
                let time = CMTimeGetSeconds((self.playerItem?.currentTime())!);
                return time.isNaN ? 0 : time;
            }
            return 0
        }
    }
}
