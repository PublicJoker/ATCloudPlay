//
//  BasePlayer.swift
//  GKGame_Swift
//
//  Created by wangws1990 on 2020/4/15.
//  Copyright © 2020 wangws1990. All rights reserved.
//

import UIKit
@objc enum PlayerState : Int {
    case prepare;
    case ready;
    case played;
    case paused;
    case stoped;
    case error;
    case finish;
    case empty;
    case full;
}
@objc enum BufferState : Int {
    case empty;
    case full;
}
@objc protocol playerDelegate : NSObjectProtocol {
    @objc optional func player(player : BasePlayer,bufferState : BufferState);
    @objc optional func player(player : BasePlayer,playerstate : PlayerState);
    @objc optional func player(player : BasePlayer,cache : TimeInterval);
    @objc optional func player(player : BasePlayer,progress : TimeInterval);
}
@objc class BasePlayer: NSObject {
    weak var delegate : playerDelegate? = nil;
    var _current : TimeInterval = 0;
    var _duration: TimeInterval = 0;
    var _playing : Bool = false;
    lazy var contentView: UIView = {
        return UIView.init();
    }()
    func playUrl(url : String) {
        
    }
    func seek(time : TimeInterval){
        
    }
    func play(){
        
    }
    func stop(){
        
    }
    func pause(){
        
    }
    func resume(){
        
    }
}
