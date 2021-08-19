//
//  BasePlayer.swift
//  GKGame_Swift
//
//  Created by Tony-sg on 2020/4/15.
//  Copyright © 2020 Tony-sg. All rights reserved.
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
    @objc optional func player(player : BasePlayer,cache       : TimeInterval);
    @objc optional func player(player : BasePlayer,progress    : TimeInterval);
}
@objc class BasePlayer: NSObject {
    public weak var delegate : playerDelegate? = nil;
    public lazy var contentView: UIView = {
        return UIView.init();
    }()
    public func playUrl(url : String) {
        
    }
    public func seek(time : TimeInterval){
        
    }
    public func play(){
        
    }
    public func stop(){
        
    }
    public func pause(){
        
    }
    public func resume(){
        
    }
}
