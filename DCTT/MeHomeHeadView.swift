//
//  MeHomeHeadView.swift
//  DCTT
//
//  Created by wyg on 2018/3/18.
//  Copyright © 2018年 Light.W. All rights reserved.
//

import UIKit

class MeHomeHeadView: UIView {

    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var sex: UIImageView!
    @IBOutlet weak var age: UILabel!
    @IBOutlet weak var city: UILabel!
    
    @IBOutlet weak var mark: UILabel!
    @IBOutlet weak var praise: UILabel!
    @IBOutlet weak var fans: UILabel!
    @IBOutlet weak var score: UILabel!

    var avatarClickerAction:(() -> Void)?
    
    override func awakeFromNib() {
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(iconTap(_ :)))
        
        avatar.addGestureRecognizer(tap)
    }
    
    func iconTap(_ gesture:UITapGestureRecognizer)  {
        if let action = avatarClickerAction {
            action()
        }
    }
    
    func fill(_ dic:[String:Any]) {
        
        if let igurl = dic["avatar"] as? String {
            let url = URL.init(string: igurl)
            avatar.kf.setImage(with: url, placeholder: UIImage (named: "avatar_default"), options: nil, progressBlock: nil, completionHandler: nil)
        }
        
        let sexigname = String.isNullOrEmpty(dic["sex"]) == "1" ? "boy":"girl"
        sex.image = UIImage (named:  sexigname)
        age.text =  String.isNullOrEmpty(dic["age"]) + "岁"
        
        city.text = (dic["location"] as? String) ?? "未知"
        
        let notes = String.isNullOrEmpty(dic["notes"])
        mark.text =  notes.lengthOfBytes(using: String.Encoding.utf8) > 0 ? notes : "暂无介绍"
        
        praise.text = String.isNullOrEmpty(dic["praise"])
        fans.text = String.isNullOrEmpty(dic["fans"])
        score.text = String.isNullOrEmpty(dic["score"])
    }

}
