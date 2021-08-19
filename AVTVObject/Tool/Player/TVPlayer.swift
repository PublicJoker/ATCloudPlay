//
//  GKVideoPlayer.swift
//  GKGame_Swift
//
//  Created by Tony-sg on 2020/4/15.
//  Copyright © 2020 Tony-sg. All rights reserved.
//

import UIKit
import AVFoundation
public enum PathVideo : String {
    case rate = "rate";
    case status = "status";
    case bounds = "bounds";
    case loadedTimeRanges = "loadedTimeRanges";
    case playbackBufferEmpty = "playbackBufferEmpty";
    case playbackLikelyToKeepUp = "playbackLikelyToKeepUp";
}
class TVPlayer: BasePlayer {
    
    private var state : PlayerState?{
        didSet{
            let playerState  = state;
            if let delegate = self.delegate {
                delegate.player?(player: self, playerstate: playerState!);
            }
        }
    };
    private var player : AVPlayer? = nil;
    private var playerItem : AVPlayerItem? = nil;
    private var playerLayer : AVPlayerLayer? = nil;
    private var observer :Any? = nil;
    
    private var seek : Bool = false;
    private var userPause : Bool = false;
    deinit {
        print(self.classForCoder,"deinit")
        self.releasePlayer()
    }
    private func releasePlayer(){
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
    private func addNotification(){
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
                print(item.status)
                if item.status == .failed {
                    self.state = .error;
                }else{
                    self.state = .ready;
                    if self.userPause == false {
                        self.play();
                    }
                }
                break;
            default:
                break;
            }
        }
    }
    private func progressCache(item : AVPlayerItem){
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
    @objc private func playerItemDidPlayToEnd(){
        self.state = .finish;
    }
    @objc private func appDidEnterBackground(){
        guard let player = self.player else { return  }
        player.pause()
    }
    @objc private func appDidEnterPlayGround(){
        if self.userPause == false {
            self.resume();
        }
    }
    private func readyPlay(){
        guard let player = self.player else { return  }
        weak var weakSelf = self;
        observer = player.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(0.1, preferredTimescale: Int32(NSEC_PER_SEC)), queue: DispatchQueue.main, using: { (time) in
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
    override func playUrl(url: String) {
        self.playUrl(url: url, time:0)
    }
    public func playUrl(url: String,time : TimeInterval) {
         assert(url.count != 0);
         self.releasePlayer();
         let string : NSString = url as NSString;
         let loc = string.range(of: "/").location;
         
         let urlPath : URL = (loc == 0) ? URL(fileURLWithPath: url) : URL.init(string: url)!;
         self.playerItem = AVPlayerItem(url: urlPath)
        if time > 0 {
            weak var weakSelf = self;
            self.playerItem?.seek(to:CMTimeMake(value: Int64(time), timescale: 1), completionHandler: { (success) in
                if success{
                    weakSelf?.play();
                }
            })
        }
         if self.player == nil {
             self.player = AVPlayer(playerItem: self.playerItem);
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
    private func playVideo(){
        guard let player = self.player else { return  }
        player.play()
        player.rate = 1.0
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
    private func pauseVideo(){
        guard let player = self.player else { return  }
        player.pause()
        player.rate = 0;
    }
    override func seek(time: TimeInterval) {
        guard let player = self.player else { return }
        let  time1 = time >= self.duration ? 0 : time;
        let  time2 = time1 < 0 ? 0 : time1;
           self.seek = true;
           player.pause();
          weak var weakSelf = self;
          player.seek(to: CMTimeMake(value: Int64(time2), timescale: 1), toleranceBefore:CMTime.zero, toleranceAfter: CMTime.zero, completionHandler: { (finish) in
              weakSelf?.seek = !finish;
              if (weakSelf?.userPause == false){
                  weakSelf?.playVideo();
              }
          })
    }
    public var playing: Bool{
        get{
            guard let player = self.player else { return false }
            let res = player.timeControlStatus == .playing
            return res;
        }
    }
    public var duration: TimeInterval{
        get{
            guard let item = self.playerItem else { return 0 }
            let time = CMTimeGetSeconds(item.duration);
            return time.isNaN ? 0 : time;
        }
    }
    public var current: TimeInterval{
        get{
            guard let item = self.playerItem else { return 0 }
            
            let time = CMTimeGetSeconds(item.currentTime())
            return time.isNaN ? 0 : time;
        }
    }
}
