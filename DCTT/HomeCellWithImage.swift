//
//  HomeCellWithImage.swift
//  DCTT
//
//  Created by wyg on 2017/12/18.
//  Copyright © 2017年 Light.W. All rights reserved.
//

import UIKit
import Kingfisher

class HomeCellWithImage: HomeListBaseCell {

    @IBOutlet weak var msg: UILabel!
    
    @IBOutlet weak var avatarImg: UIImageView!
    
    @IBOutlet weak var igv: UIImageView!
    
    @IBOutlet weak var igv_w: NSLayoutConstraint!
    
    @IBOutlet weak var igv_h: NSLayoutConstraint!
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var time: UILabel!
    
    @IBOutlet weak var dislikeBtn: UIButton!
    
    @IBOutlet weak var readCnt: UILabel!
    
    @IBOutlet weak var itemType: UILabel!
    
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
        
        let w = kCurrentScreenWidth / 3.0;
        igv_w.constant = w;
        igv_h.constant = w
    }

    
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
            }else{
                avatarImg.image = UIImage.init(named: "avatar_default")
            }
        }
        
        let images = String.isNullOrEmpty(d["images"])
        let arr = images.components(separatedBy: ",")
        guard arr.count > 0 else { return}
        
        let url = URL.init(string: arr.first!)
        igv.kf.setImage(with: url, placeholder: UIImage (named: "default_image2"))
    }
    
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
