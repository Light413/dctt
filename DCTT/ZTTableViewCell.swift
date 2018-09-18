//
//  ZTTableViewCell.swift
//  DCTT
//
//  Created by wyg on 2018/9/8.
//  Copyright © 2018年 Light.W. All rights reserved.
//

import UIKit

class ZTTableViewCell: UITableViewCell ,HomeCellFillDateAble{

    @IBOutlet weak var bg: UIView!
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var user: UILabel!
    @IBOutlet weak var user_avatar: UIImageView!
    
    
    
    @IBOutlet weak var date: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        bg.layer.borderColor = kTableviewBackgroundColor.cgColor
        bg.layer.borderWidth = 2
        bg.layer.cornerRadius = 5        
        bg.layer.masksToBounds = true
        
    }

    func fill(_ d:[String:Any]) {
        
        fillData(msg: content, user: user, date: date, data: d)
        
        date.text = "发布于 \(date.text!)"
        let cc = String.isNullOrEmpty(d["content"])
        do{
            let jsonObject = try JSONSerialization.jsonObject(with: cc.data(using: String.Encoding.utf8)!, options: JSONSerialization.ReadingOptions.allowFragments)
            let obj = jsonObject as! [String:String]
            title.text = "#" +  String.isNullOrEmpty(obj["title"])
        }catch {
            
        }
        
        
        
        /////////////msg
        let paragraphStyle = NSMutableParagraphStyle.init()
        paragraphStyle.lineSpacing = 5
        paragraphStyle.lineBreakMode = .byTruncatingTail //byCharWrapping
        paragraphStyle.firstLineHeadIndent = 5
        
        let attri:[String:Any] = [
            NSFontAttributeName:UIFont.systemFont(ofSize: 16) ,
            NSParagraphStyleAttributeName:paragraphStyle,
            //NSKernAttributeName:1
        ]
        
        let str = content.text 
        content.text = nil
        
        let attriStr = NSAttributedString.init(string: str!, attributes: attri)
        content.attributedText = attriStr
        
        
        guard let dic = d["user"] as? [String:Any] else {return}
        if let igurl = dic["avatar"] as? String {
            let url = URL.init(string: igurl)
            user_avatar.kf.setImage(with: url, placeholder: UIImage (named: "avatar_default"), options: nil, progressBlock: nil, completionHandler: nil)
        }
    }
    
    override func prepareForReuse() {
        title.text = nil
        content.text = nil
    }
    
}
