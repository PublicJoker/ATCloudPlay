//
//  AVPlayView.swift
//  GKGame_Swift
//
//  Created by wangws1990 on 2019/10/14.
//  Copyright © 2019 wangws1990. All rights reserved.
//

import UIKit
let least      : Float = 15;
let screenTime : Float = 90;
enum AVPlayGestures {
    case none
    case progress
    case voice
    case light
}
@objc protocol playVideoDelegate : NSObjectProtocol {
    @objc optional func playView(playView : AVPlayView,pause   : Bool);
    @objc optional func playView(playView : AVPlayView,screen  : Bool);
    @objc optional func playView(playView : AVPlayView,list    : Bool);
    @objc optional func playView(playView : AVPlayView,progress: TimeInterval);
}

class AVPlayView: UIView {

    lazy var tap : UITapGestureRecognizer = {
        let tap : UITapGestureRecognizer = UITapGestureRecognizer.init();
        tap.addTarget(self, action: #selector(tapAction))
        return tap
    }()
    var timer : Timer!;
    weak open var delegate : playVideoDelegate?;
    var slidering : Bool = false;
    var touchBegin : CGPoint = CGPoint.zero;
    var touchBegitValue : Float = 0;
    var hasMove : Bool = false;
    var gestures : AVPlayGestures = .none;
    
    @IBOutlet weak var progressView: UISlider!
    
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var titleLab: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var totalLab: UILabel!
    @IBOutlet weak var currentLab: UILabel!
    @IBOutlet weak var screenBtn: UIButton!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var favBtn: UIButton!
    @IBOutlet weak var listBtn: UIButton!
    @IBOutlet weak var lockBtn: UIButton!
    lazy var toastView : AVPlayToastView = {
        return AVPlayToastView.init();
    }()
    public var fav : Bool{
        set{
            self.favBtn.isSelected = newValue;
        }get{
            return self.favBtn.isSelected;
        }
    }
    public var screen : Bool{
        set{
            self.screenBtn.isSelected = newValue;
            self.listBtn.alpha = newValue ? 1 : 0.0;
        }get{
            return self.screenBtn.isSelected;
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
        self.addSubview(self.toastView);
        self.toastView.snp.makeConstraints { (make) in
            make.width.equalTo(120);
            make.height.equalTo(80);
            make.centerX.centerY.equalToSuperview();
        }
        self.toastView.isHidden = true;
        self.show()
    }
    public func playerTitle(title : String){
        self.titleLab.text = title ;
    }
    public func player(player : BasePlayer,bufferState : BufferState){
        
    }
    public func player(player : BasePlayer,playerstate : PlayerState){
        if  player .isKind(of: TVPlayer.classForCoder()) {
            let videoPlayer = player as! TVPlayer;
            self.isplay(playing: videoPlayer.playing);
        }
    }
    public func player(player : BasePlayer,progress : TimeInterval){
        if  player .isKind(of: TVPlayer.classForCoder()) {
            let videoPlayer = player as! TVPlayer;
            if self.slidering == false {
                self.currentLab.text = self.totalTimeTurnToTime(timeStamp: progress);
                self.slider.value = Float(progress);
            }
            let total = Float(videoPlayer.duration);
            self.progressView.value = Float(progress);
            self.progressView.maximumValue = total;
            self.slider.maximumValue = total;
            self.cacheSlider.maximumValue = total;
            self.totalLab.text = self.totalTimeTurnToTime(timeStamp:TimeInterval(total))
        }
    }
    public func player(player : BasePlayer,cache : TimeInterval){
        if  player .isKind(of: TVPlayer.classForCoder()) {
            let videoPlayer = player as! TVPlayer;
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
    @IBAction func listAction(_ sender: UIButton) {
        if let delegateSure = self.delegate{
            delegateSure.playView?(playView: self, list: true);
        }
        self.statr();
    }
    @IBAction func lockAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected;
        if sender.isSelected{
            self.hidden();
            self.stop();
        }else{
            self.show();
            self.statr();
        }
    }
    @objc func touchUpAction(sender:UISlider){
        self.slidering = true;
        self.statr();
    }
    @objc func outsideAction(sender:UISlider){
        self.slidering = false;
        let progress : TimeInterval = TimeInterval(sender.value);
        self.progressDelegate(progress: progress)
        self.statr();
    }
    @objc func changedAction(sender:UISlider){
        let progress : TimeInterval = TimeInterval(sender.value);
        self.currentLab.text = self.totalTimeTurnToTime(timeStamp: progress);
        self.statr();
    }
    func progressDelegate(progress : TimeInterval){
        if let delegateOk = self.delegate{
            delegateOk.playView?(playView: self, progress: progress)
        }
    }
    @objc func tapAction(){
        if self.lockBtn.isSelected {
             
        }else{
            if self.bottomView.isHidden {
                self.show();
            }else{
                self.hidden();
            }
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
        self.favBtn.isHidden = ap == 0;
        self.listBtn.isHidden = ap == 0;
        self.progressView.isHidden = ap > 0;
        if let delegateSure = self.delegate{
            delegateSure.playView?(playView: self, list: false);
        }
    }
    private func isplay(playing :Bool){
        self.playBtn.isSelected = !playing;
    }
    func totalTimeTurnToTime(timeStamp: TimeInterval) -> String{
        let time :TimeInterval = timeStamp
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
    //MARK: touches
    func touch(_ touches: Set<UITouch>, with event: UIEvent?){
        if self.screen == false{
            return;
        }
        if touches.count == 0 {
            return;
        }
        let touch : UITouch = touches.first!
        if touches.count > 1 || touch.tapCount > 1 || (event?.allTouches!.count)! > 1 {
            return;
        }
        if touch.view != self {
            return;
        }
    }
    func moveProgress(point : CGPoint) -> Float{
        var tempValue = self.touchBegitValue + screenTime * Float(((point.x - self.touchBegin.x)/SCREEN_WIDTH));
        if tempValue > self.slider.maximumValue && self.slider.maximumValue > 10 {
            tempValue = self.slider.maximumValue;
        }else if (tempValue < 0){
            tempValue = 0;
        }
        return Float(tempValue)
    }
    func setToastView(time : Float){
        if time > self.touchBegitValue{
            self.toastView.imageV.image = UIImage.init(named: "progress_icon_r")
        }else if time < self.touchBegitValue{
            self.toastView.imageV.image = UIImage.init(named: "progress_icon_l")
        }
        self.toastView.isHidden = false;
        self.toastView.titleLab.text = self.totalTimeTurnToTime(timeStamp: TimeInterval(time));
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.touch(touches, with: event)
        let touch : UITouch = touches.first!
        self.hasMove = false
        
        self.touchBegin = touch.location(in: self);
        self.touchBegitValue  = self.slider.value;
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.touch(touches, with: event)
        let touch : UITouch = touches.first!
        let point : CGPoint = touch.location(in: self);
        let x = fabsf(Float(point.x - self.touchBegin.x))
        let y = fabsf(Float(point.y - self.touchBegin.y))
        if x < least && y < least{
            return;
        }
        self.hasMove = true;
        let tan : Float = y/x;
        if tan < 1/sqrtf(3.0){
            self.gestures = .progress;
        }else if tan > sqrt(3.0){
            if self.touchBegin.x < self.bounds.size.width/2 {
                self.gestures = .light
            }else{
                self.gestures = .voice;
            }
        }else{
            self.gestures = .none;
            return;
        }
        switch self.gestures {
        case .progress:
            let time = self.moveProgress(point: point);
            self.setToastView(time: time)
            break;
        default:break;
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.hasMove{
            switch self.gestures {
            case .progress:
                let touch : UITouch = touches.first!
                let point  = touch.location(in: self)
                let progress = self.moveProgress(point: point);
                self.progressDelegate(progress: TimeInterval(progress))
                break
            default:
                break
            }
            self.toastView.isHidden = true;
        }
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {

        if self.hasMove{
            switch self.gestures {
            case .progress:
                let touch : UITouch = touches.first!
                let point  = touch.location(in: self)
                let progress = self.moveProgress(point: point);
                self.progressDelegate(progress: TimeInterval(progress))
                break
            default:
                break
            }
            self.toastView.isHidden = true;
        }
        
    }
}
