//
//  TTPostCommentView.swift
//  DCTT
//
//  Created by wyg on 2018/8/24.
//  Copyright © 2018年 Light.W. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
class TTPostCommentView: UIView {

    var _textView:UITextView!
    var _maskView:UIView!
    var _bgView:UIView!
    let bg_h:CGFloat = 80

    var msg:UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        _maskView = UIView.init(frame: frame)
        _maskView.backgroundColor = UIColor.black
        _maskView.alpha = 0.2
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
        
        _bgView.addSubview(postBtn)
        
        self.addSubview(_bgView)
        
        _textView.becomeFirstResponder()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_ :)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_ :)), name: Notification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    func keyboardWillShow(_ noti:Notification) {
        guard let info = noti.userInfo else {return}//UIKeyboardAnimationDurationUserInfoKey
        guard let rect = info[UIKeyboardFrameEndUserInfoKey] as? CGRect else{
            return
        }
       
        UIView.animate(withDuration: 0.25) {[weak self] in
            guard let  ss = self else {return}
            ss._bgView.transform = CGAffineTransform.init(translationX: 0, y: -rect.height - ss.bg_h)
        }
        
        //let duration = (info[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        //print("\(info["UIKeyboardAnimationDurationUserInfoKey"])")
    }
    
    func keyboardWillHide(_ noti:Notification)  {

        dismiss()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func dismiss() {
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
        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().enableAutoToolbar = true
        print("deiinit")
    }
}

extension TTPostCommentView:UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        msg.isHidden = textView.text.lengthOfBytes(using: String.Encoding.utf8) > 0 ? true : false
        
    }
}


