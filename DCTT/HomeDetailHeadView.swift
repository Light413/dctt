//
//  HomeDetailHeadView.swift
//  DCTT
//
//  Created by gener on 2018/1/10.
//  Copyright © 2018年 Light.W. All rights reserved.
//

import UIKit

class HomeDetailHeadView: UIView {

    @IBOutlet weak var iconImg: UIImageView!
    
    @IBOutlet weak var nameLable: UILabel!
    
    @IBOutlet weak var dateLable: UILabel!
    
    var avatarClickedAction:(() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        iconImg.layer.cornerRadius = 20
        iconImg.layer.masksToBounds = true
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(tapIconAction))
        iconImg.addGestureRecognizer(tapGesture)
    }
    
    @objc func tapIconAction()  {
        if let iconAction = avatarClickedAction {
            iconAction()
        }
    }
    
    
    //点击关注
    @IBAction func watchButtonAction(_ sender: Any) {
        
        
    }
    
    func fill(_ d:[String:Any]) {
        guard let dic = d["user"] as? [String:Any] else {return}
        if let igurl = dic["avatar"] as? String {
            let url = URL.init(string: igurl)
            iconImg.kf.setImage(with: url, placeholder: UIImage (named: "avatar_default"), options: nil, progressBlock: nil)
        }
        
        var s = ""
        let name = String.isNullOrEmpty(dic["name"]);
        if name.lengthOfBytes(using: String.Encoding.utf8) > 0  {
            s = name;
        }
        else
        if let name = dic["nickName"] as? String {
            s = name;
        }
        nameLable.text = s
        
        
        dateLable.text = "发布于 " + Date.dateFormatterWithString(String.isNullOrEmpty(d["postDate"]))
    }
}
