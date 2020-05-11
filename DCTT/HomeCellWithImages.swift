//
//  HomeCellWithImages.swift
//  DCTT
//
//  Created by wyg on 2017/12/18.
//  Copyright © 2017年 Light.W. All rights reserved.
//

import UIKit
import Kingfisher

class HomeCellWithImages: HomeListBaseCell {
    @IBOutlet weak var msg: UILabel!
    
    @IBOutlet weak var ig1: UIImageView!
    @IBOutlet weak var ig2: UIImageView!
    @IBOutlet weak var ig3: UIImageView!
    
    @IBOutlet weak var avatarImg: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var time: UILabel!
    
    @IBOutlet weak var image_h: NSLayoutConstraint!
    
    @IBOutlet weak var dislikeBtn: UIButton!
    @IBOutlet weak var readCnt: UILabel!
    
    @IBOutlet weak var Itemtype: UILabel!
    
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
        
        let w = (kCurrentScreenWidth - 20) / 3.0
        image_h.constant = w;
        
        disLikeBtnSetStyle(dislikeBtn)
    }

    
    override func fill(_ d:[String:Any]) {
        fillData(msg: msg, user: name, date: time, data: d)
        
        var _type = "新鲜事"
        if let t = d["type"]{
            _type = kPublishTypeInfo["\(t)"]!;
        }
        
        readCnt.text = "阅读" +  String.isNullOrEmpty(d["readCnt"]);
        Itemtype.text = _type
        
        if let u = d["user"] as? [String:Any]{
            if let u_avatar = u["avatar_thumb"] as? String{
                avatarImg.kf.setImage(with: URL.init(string: u_avatar));
            }
        }
        
        let images = String.isNullOrEmpty(d["images"])

        let arr = images.components(separatedBy: ",")
        guard arr.count > 0 else { return}        
        for i in 0..<3 {
            let url = URL.init(string: arr[i])
            
            if let igv = self.contentView.viewWithTag(10 + i) as? UIImageView {
                igv.kf.setImage(with: url, placeholder: UIImage (named: "default_image2"))
            }
            
        }
        
        
    }

    
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
