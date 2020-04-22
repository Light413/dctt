//
//  TTSearchBarView.swift
//  DCTT
//
//  Created by gener on 17/11/28.
//  Copyright © 2017年 Light.W. All rights reserved.
//

import UIKit

protocol TTSearchBarDelegate : NSObjectProtocol{
    
    func textFieldDidEndEditing(_ textField: UITextField)
    
    func textFieldShouldReturn(_ textField: UITextField)
    
    func cancle()
}

class TTSearchBarView: UIView ,UITextFieldDelegate{

    private var tf:UITextField!
    var delegate:TTSearchBarDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        tf = UITextField (frame: CGRect (x: 0, y: 0, width: frame.width - 70, height: 30))
        tf.backgroundColor = UIColor (red: 244/255.0, green: 245/255.0, blue: 246/255.0, alpha: 1)
        tf.borderStyle = .roundedRect
        tf.placeholder = "请输入搜索关键字"
        tf.textColor = UIColor.darkGray
        tf.font = UIFont .systemFont(ofSize: 14)
        tf.delegate = self
        tf.leftViewMode = .always
        tf.clearButtonMode = .whileEditing
        tf.returnKeyType = .search
        let leftview = UIView (frame: CGRect (x: 0, y: 0, width: 25, height: 20))
        let img = UIImageView (image: UIImage (named: "search_subscibe_titilebar_press_night"))
        img.frame = CGRect (x: 10, y: 4, width: 12, height: 12)
        leftview.addSubview(img)
        tf.leftView = leftview
        self.addSubview(tf)
        
        let cancleBtn = UIButton (frame: CGRect (x: tf.frame.maxX + 15, y: 0, width: 40, height: 30))
        cancleBtn.setTitle("取消", for: .normal)
        cancleBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        cancleBtn.setTitleColor(UIColor (red: 42/255.0, green: 144/255.0, blue: 215/255.0, alpha: 1), for: .normal)
        cancleBtn.addTarget(self, action: #selector(cancleBtnAction), for: .touchUpInside)
        self.addSubview(cancleBtn)
        
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChanged(_ :)), name: UITextField.textDidChangeNotification, object: nil)
    }
    
    
    func _init() {
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:
    @objc func cancleBtnAction() {
        delegate?.cancle()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        delegate?.textFieldShouldReturn(textField)
        return true
    }
    
    @objc func textDidChanged(_ noti:Notification)  {
        if let textfield = noti.object as? UITextField {
            delegate?.textFieldDidEndEditing(textfield)
        }
        
    }
    
    
    
}
