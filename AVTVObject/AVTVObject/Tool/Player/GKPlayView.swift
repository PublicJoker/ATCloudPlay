//
//  GKPlayView.swift
//  GKGame_Swift
//
//  Created by wangws1990 on 2019/10/14.
//  Copyright © 2019 wangws1990. All rights reserved.
//

import UIKit

@objc protocol playVideoDelegate : NSObjectProtocol {
    @objc optional func playView(playView : GKPlayView,pause   : Bool);
    @objc optional func playView(playView : GKPlayView,screen  : Bool);
    @objc optional func playView(playView : GKPlayView,progress: TimeInterval);
}

class GKPlayView: UIView {

    lazy var tap : UITapGestureRecognizer = {
        let tap : UITapGestureRecognizer = UITapGestureRecognizer.init();
        tap.addTarget(self, action: #selector(tapAction))
        return tap
    }()
    var timer : Timer!;
    weak open var delegate : playVideoDelegate?;
    var slidering : Bool = false;
    
    @IBOutlet weak var progressView: UISlider!
    
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var titleLab: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var totalLab: UILabel!
    @IBOutlet weak var currentLab: UILabel!
    @IBOutlet weak var screenBtn: UIButton!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var favBtn: UIButton!
    
    public var fav : Bool{
        set{
            self.favBtn.isSelected = newValue;
        }get{
            return self.favBtn.isSelected;
        }
    }
    lazy var cacheSlider: UISlider = {
        let slider = UISlider.init();
        slider.thumbTintColor = UIColor.clear;
        slider.minimumTrackTintColor = Appx999999;
        slider.maximumTrackTintColor = Appxffffff;
        slider.isUserInteractionEnabled = false;
        return slider
    }()
    deinit {

    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.screenBtn.setImage(UIImage.init(named: "icon_screen"), for:.normal)
        self.screenBtn.setImage(UIImage.init(named: "icon_screen"), for:UIControl.State(rawValue: UIControl.State.normal.rawValue | UIControl.State.highlighted.rawValue))
        
        self.screenBtn.setImage(UIImage.init(named: "icon_small"), for:.selected)
        self.screenBtn.setImage(UIImage.init(named: "icon_small"), for:UIControl.State(rawValue: UIControl.State.selected.rawValue | UIControl.State.highlighted.rawValue))
        
        
        self.currentLab.font = UIFont .monospacedDigitSystemFont(ofSize: 12, weight: .regular);
        self.totalLab.font = UIFont.monospacedDigitSystemFont(ofSize: 12, weight: .regular);
        self.slider.addTarget(self, action: #selector(touchUpAction(sender:)), for: .touchDown);
        self.slider.addTarget(self, action: #selector(outsideAction(sender:)), for: UIControl.Event(rawValue: UIControl.Event.touchUpInside.rawValue|UIControl.Event.touchUpOutside.rawValue|UIControl.Event.touchCancel.rawValue));
        self.slider.addTarget(self, action: #selector(changedAction(sender:)), for: .valueChanged);
        self.slider.setThumbImage(UIImage.init(named: "icon_slider"), for: .normal);
        self.addGestureRecognizer(self.tap);
        self.progressView.isHidden = true;
        self.slider.addSubview(self.cacheSlider);
        self.cacheSlider.snp.makeConstraints { (make) in
            make.edges.equalToSuperview();
        }
        self.show()
    }
    public func playerTitle(title : String){
        self.titleLab.text = title ;
    }
    public func player(player : BasePlayer,bufferState : BufferState){
        
    }
    public func player(player : BasePlayer,playerstate : PlayerState){
        if  player .isKind(of: GKVideoPlayer.classForCoder()) {
            let videoPlayer = player as! GKVideoPlayer;
            self.isplay(playing: videoPlayer.playing);
        }
    }
    public func player(player : BasePlayer,progress : TimeInterval){
        if  player .isKind(of: GKVideoPlayer.classForCoder()) {
            let videoPlayer = player as! GKVideoPlayer;
            if self.slidering == false {
                self.currentLab.text = self.totalTimeTurnToTime(timeStamp: String(progress));
                self.slider.value = Float(progress);
            }
            let total = Float(videoPlayer.duration);
            self.progressView.value = Float(progress);
            self.progressView.maximumValue = total;
            self.slider.maximumValue = total;
            self.cacheSlider.maximumValue = total;
            self.totalLab.text = self.totalTimeTurnToTime(timeStamp:String(total))
        }
    }
    public func player(player : BasePlayer,cache : TimeInterval){
        if  player .isKind(of: GKVideoPlayer.classForCoder()) {
            let videoPlayer = player as! GKVideoPlayer;
            self.cacheSlider.value = Float(cache);
            if self.cacheSlider.value >= Float(videoPlayer.duration - 2) {
                self.cacheSlider.maximumTrackTintColor = Appx999999;
            }else{
                self.cacheSlider.maximumTrackTintColor = Appxffffff;
            }
        }
    }
    @IBAction func playAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected;
        if let delegateSure = self.delegate{
            delegateSure.playView?(playView: self, pause: sender.isSelected);
        }
        self.statr();
    }
    @IBAction func screenAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected;
        if let delegateSure = self.delegate{
            delegateSure.playView?(playView: self, screen: sender.isSelected);
        }
        self.statr();
    }
    @objc func touchUpAction(sender:UISlider){
        self.slidering = true;
        self.statr();
    }
    @objc func outsideAction(sender:UISlider){
        self.slidering = false;
        let progress : TimeInterval = TimeInterval(sender.value);
        if let delegateOk = self.delegate{
            delegateOk.playView?(playView: self, progress: progress)
        }
        self.statr();
    }
    @objc func changedAction(sender:UISlider){
        let progress : TimeInterval = TimeInterval(sender.value);
        self.currentLab.text = self.totalTimeTurnToTime(timeStamp: String(progress));
        self.statr();
    }
    @objc func tapAction(){
        if self.bottomView.isHidden {
            self.show();
        }else{
            self.hidden();
        }
    }
    @objc func statr(){
        self.stop();
        self.perform(#selector(hidden), with: nil, afterDelay: 5)
    }
    private func stop(){
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(hidden), object: nil);
    }
    private func show(){
        self.subViewAlpha(ap: 1)
        self.statr();
    }
    @objc func hidden(){
        self.subViewAlpha(ap: 0)
    }
    private func subViewAlpha(ap:CGFloat){
        self.bottomView.isHidden = ap == 0
        self.titleLab.isHidden = ap == 0;
        self.progressView.isHidden = ap > 0;
    }
    private func isplay(playing :Bool){
        self.playBtn.isSelected = !playing;
    }
    func totalTimeTurnToTime(timeStamp:String) -> String{
        let time :TimeInterval = (TimeInterval(timeStamp))!
        if time/3600 > 1 {
            let date:NSDate = NSDate.init(timeIntervalSince1970: time)
            let formatter:DateFormatter = DateFormatter.init();
            formatter.dateFormat = "HH:mm:ss"
            formatter.timeZone = TimeZone.init(identifier: "GMT")
            return formatter.string(from: date as Date);
        }else{
            let date:NSDate = NSDate.init(timeIntervalSince1970: time)
            let formatter:DateFormatter = DateFormatter.init();
            formatter.dateFormat = "mm:ss"
            formatter.timeZone = TimeZone.init(identifier: "GMT")
            return formatter.string(from: date as Date);
        }
    }
}
