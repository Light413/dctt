//
//  TTPostCommentView.swift
//  DCTT
//
//  Created by wyg on 2018/8/24.
//  Copyright © 2018年 Light.W. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

let TTPostCommentSuccessNotification = NSNotification.Name.init(rawValue: "TTPostCommentSuccessNotification");

class TTPostCommentView: UIView {

    var pid:String!
    var category:String!
    
    private var _textView:UITextView!
    private var _maskView:UIView!
    private var _bgView:UIView!
    private let bg_h:CGFloat = 80
    fileprivate var msg:UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        _maskView = UIView.init(frame: frame)
        _maskView.backgroundColor = UIColor.black
        _maskView.alpha = 0.1
        self.addSubview(_maskView)
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(dismiss))
        _maskView.addGestureRecognizer(tap)
        
        _bgView = UIView (frame: CGRect (x: 0, y: frame.height, width: UIScreen.main.bounds.width, height: bg_h))
        _bgView.backgroundColor = UIColor.white
        
        _textView = UITextView (frame: CGRect (x: 15, y: 5, width: _bgView.frame.width - 70, height: bg_h - 10))
        _textView.layer.borderColor = kTableviewBackgroundColor.cgColor
        _textView.layer.borderWidth = 1
        _textView.font = UIFont.systemFont(ofSize: 16)
        _textView.delegate = self
        
        msg = UILabel (frame: CGRect (x: 8, y: 0, width: 200, height: 30))
        msg.text = "认真评论是一种生活态度..."
        msg.font = UIFont.systemFont(ofSize: 15)
        msg.textColor = UIColor.lightGray
        _textView.addSubview(msg)
        
        _bgView.addSubview(_textView)
        
        let postBtn = UIButton (frame: CGRect (x: _textView.frame.maxX, y: 10, width: 50, height: 40))
        postBtn.setTitle("发布", for: .normal)
        postBtn.setTitleColor(kButtonTitleColor, for: .normal)
        postBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        postBtn.addTarget(self, action: #selector(postAction), for: .touchUpInside)
        _bgView.addSubview(postBtn)
        
        self.addSubview(_bgView)
        
        _textView.becomeFirstResponder()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_ :)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_ :)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    @objc func keyboardWillShow(_ noti:Notification) {
        guard let info = noti.userInfo else {return}//UIKeyboardAnimationDurationUserInfoKey
        guard let rect = info[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else{
            return
        }
       
        UIView.animate(withDuration: 0.25) {[weak self] in
            guard let  ss = self else {return}
            ss._bgView.transform = CGAffineTransform.init(translationX: 0, y: -rect.height - ss.bg_h)
        }
        
        //let duration = (info[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        //print("\(info["UIKeyboardAnimationDurationUserInfoKey"])")
    }
    
    @objc func keyboardWillHide(_ noti:Notification)  {

        dismiss()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc func dismiss() {
        _textView.resignFirstResponder()
        
        UIView.animate(withDuration: 0.25, animations: {
            [weak self] in
            guard let  ss = self else {return}
            
            ss._bgView.transform = CGAffineTransform.identity
            
        }) {[weak self] (b) in
            guard b else {return}
            guard let  ss = self else {return}
            ss._maskView.removeFromSuperview();
            ss.removeFromSuperview()
        }
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
//        IQKeyboardManager.sharedManager().enable = true
//        IQKeyboardManager.sharedManager().enableAutoToolbar = true
    }
    
    
    @objc func postAction() {
        guard String.isNullOrEmpty(_textView.text).lengthOfBytes(using: String.Encoding.utf8) > 0 else {
            HUD.showText("输入内容不能为空", view: kAPPKeyWindow)
            return
        }
        
        HUD.show(withStatus: "发布中")
        
        guard let uid = User.uid() else {return}
        
        let d = ["type":"add",
                 "pid":pid!,
                 "uid":uid ,
                 "category":category!,
                 "content":String.isNullOrEmpty(_textView.text)]
        
        AlamofireHelper.post(url: comment_url, parameters: d, successHandler: {[weak self] (res) in
            print(res)
            HUD.show(successInfo: "发布成功")
            guard let ss = self else {return}
            
            NotificationCenter.default.post(name: TTPostCommentSuccessNotification, object: nil)
            ss.dismiss()
        }) { (err) in
            HUD.show(info: "发布失败,请稍后重试")
        }
        
    }
}

extension TTPostCommentView:UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        msg.isHidden = textView.text.lengthOfBytes(using: String.Encoding.utf8) > 0 ? true : false
        
    }
}


