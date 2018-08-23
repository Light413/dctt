//
//  MeHomeHeadView.swift
//  DCTT
//
//  Created by wyg on 2018/3/18.
//  Copyright © 2018年 Light.W. All rights reserved.
//

import UIKit

class MeHomeHeadView: UIView {

    @IBOutlet weak var name: UILabel!
    
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
        
        var s = ""
        let _name = String.isNullOrEmpty(dic["name"]);
        if _name.lengthOfBytes(using: String.Encoding.utf8) > 0  {
            s = _name;
        }
        else
            if let name = dic["nickName"] as? String {
                s = name;
        }
        name.text = s

        let sexigname = String.isNullOrEmpty(dic["sex"]) == "1" ? "boy":"girl"
        sex.image = UIImage (named:  sexigname)
        age.text =  String.isNullOrEmpty(dic["age"]) + "岁"
        
        city.text = (dic["location"] as? String) ?? "未知"
        
        let notes = String.isNullOrEmpty(dic["notes"])
        let notesStr = "签名: " + (notes.lengthOfBytes(using: String.Encoding.utf8) > 0 ? notes : "暂无介绍")
        
//        let paragraphStyle = NSMutableParagraphStyle.init()
//        paragraphStyle.lineSpacing = 5
//        paragraphStyle.lineBreakMode = .byCharWrapping
//        paragraphStyle.firstLineHeadIndent = 15
//
//        let dic:[String:Any] = [NSFontAttributeName:UIFont.systemFont(ofSize: 17) , NSParagraphStyleAttributeName:paragraphStyle,NSKernAttributeName:1]
        
        let attriStr = NSMutableAttributedString.init(string: notesStr)
        attriStr.addAttributes([NSFontAttributeName:UIFont.systemFont(ofSize: 14) , NSForegroundColorAttributeName:UIColor.darkGray], range: NSRange.init(location: 0, length: 3));
        
        mark.attributedText = attriStr
        
        praise.text = String.isNullOrEmpty(dic["praise"])
        fans.text = String.isNullOrEmpty(dic["fans"])
        score.text = String.isNullOrEmpty(dic["score"])
    }

}
