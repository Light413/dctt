//
//  HomeCell.swift
//  DCTT
//
//  Created by gener on 17/11/21.
//  Copyright © 2017年 Light.W. All rights reserved.
//

import UIKit
import Kingfisher
class HomeCell: HomeListBaseCell {
    @IBOutlet weak var msg: UILabel!
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var avatarImg: UIImageView!
    
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var dislikeBtn: UIButton!
    
    @IBOutlet weak var readCnt: UILabel!
    
    @IBOutlet weak var itemType: UILabel!
    
    override func fill(_ d:[String:Any]) {
        fillData(msg: msg, user: name, date: time, data: d)
        
        var _type = "新鲜事"
        if let t = d["type"]{
            _type = kPublishTypeInfo["\(t)"]!;
        }
        
        readCnt.text = "阅读" +  String.isNullOrEmpty(d["readCnt"]);
        itemType.text = _type
        
        if let u = d["user"] as? [String:Any]{
            if let u_avatar = u["avatar_thumb"] as? String{
                avatarImg.kf.setImage(with: URL.init(string: u_avatar));
            }
        }
    }
    
    @IBAction func dislikeAction(_ sender: Any) {
        Tools.showMsg(kNotLikeMsg, title: "确定") { [weak self] in
            guard let  ss = self else {return}
            if let b = ss.dislikeBlock {
                b()
            }
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        disLikeBtnSetStyle(dislikeBtn)
    }
    
}
