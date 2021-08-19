//
//  AVSearchView.swift
//  AVTVObject
//
//  Created by wangws1990 on 2020/4/26.
//  Copyright © 2020 wangws1990. All rights reserved.
//

import UIKit
@objc protocol searchDelegate : NSObjectProtocol {
    @objc optional func searchView(searchView : AVSearchView,keyWord:String);
}
class AVSearchView: UIView,UITextFieldDelegate {
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var textField: UITextField!
    weak var delegate : searchDelegate? = nil;
    var keyWord : String?{
        didSet{
            let text = keyWord ?? ""
            self.textField.text = text ;
            self.textFieldAction(sender:self.textField)
        }
    }
    var _searchEnable: Bool?
    var searchEnable : Bool?{
        set{
            _searchEnable = newValue ?? false;
            self.searchBtn.isUserInteractionEnabled = _searchEnable!;
            self.searchBtn.backgroundColor = _searchEnable! ? AppColor : UIColor.init(hex: "ededed");
        }get{
            return _searchEnable;
        }
    }
    override func awakeFromNib() {
        self.backgroundColor = Appxffffff;
        self.searchBtn.layer.masksToBounds = true;
        self.searchBtn.layer.cornerRadius = AppRadius;
        self.mainView.layer.masksToBounds = true;
        self.mainView.layer.cornerRadius = 15;
        self.textField.delegate = self;
        self.textField.addTarget(self, action: #selector(textFieldAction(sender:)), for: .editingChanged)
        self.searchBtn.addTarget(self, action: #selector(searchAction), for: .touchUpInside)
        self.textFieldAction(sender: self.textField)
    }
    @objc private func textFieldAction(sender:UITextField){
        var text : String = sender.text ?? "";
        text = text.trimmingCharacters(in: .whitespacesAndNewlines)
        self.searchEnable = text.count > 0
        if text.count == 0 {
            if let delegate = self.delegate{
                delegate.searchView?(searchView: self, keyWord:"");
            }
        }
    }
    @objc private func searchAction(){
        if textField.text?.count == 0 {
            return;
        }
        if let delegate = self.delegate{
            delegate.searchView?(searchView: self, keyWord:self.textField.text!);
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text?.count == 0 {
            self.resignFirstResponders()
            return false;
        }
        self.searchAction();
        return true;
    }
    func resignFirstResponders(){
        if self.textField.isFirstResponder {
            self.textField.resignFirstResponder();
        }
    }
    func becomeFirstResponders(){
        if self.textField.canBecomeFirstResponder {
            self.textField.becomeFirstResponder();
        }
    }

}

class AVSearchTopView : UIView{
    lazy var topLabel : UILabel = {
        return UILabel.init();
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadUI()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadUI()
    }
    func loadUI(){
        self.addSubview(self.topLabel);
        self.topLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview();
        }
        self.topLabel.backgroundColor = UIColor.red;
        self.topLabel.textColor = UIColor.white;
        self.topLabel.text = "hello world";
        self.backgroundColor = UIColor.red
    }
}
