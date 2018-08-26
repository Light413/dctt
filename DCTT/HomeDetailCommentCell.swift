//
//  HomeDetailCommentCell.swift
//  DCTT
//
//  Created by wyg on 2018/1/11.
//  Copyright © 2018年 Light.W. All rights reserved.
//

import UIKit

class HomeDetailCommentCell: UITableViewCell {
    @IBOutlet weak var icon: UIImageView!

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var zanBtn: UIButton!
    
    @IBOutlet weak var msgText: UILabel!
    @IBOutlet weak var timeLable: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code


    }
    
    func fill(_ d:[String:Any]) {
        let text = String.isNullOrEmpty(d["content"])
        let paragraphStyle = NSMutableParagraphStyle.init()
        paragraphStyle.lineSpacing = 3
        paragraphStyle.lineBreakMode = .byCharWrapping
        paragraphStyle.firstLineHeadIndent = 0
        
        let attriDic:[String:Any] = [
            NSFontAttributeName:UIFont.systemFont(ofSize: 15) ,
            NSParagraphStyleAttributeName:paragraphStyle,
            NSKernAttributeName:1
        ]
        
        let attriStr = NSAttributedString.init(string: text, attributes: attriDic)
        msgText.attributedText = attriStr
        
        //name
        var s = ""
        let _name = String.isNullOrEmpty(d["u_name"]);
        
        if _name.lengthOfBytes(using: String.Encoding.utf8) > 0  {
            s =  "\(_name)";
        }
        else
        if let name = d["u_nickName"] as? String {
            s = "\(name)";
        }

        name.text = s
        
        //avatar
        if let igurl = d["u_avatar"] as? String {
            let url = URL.init(string: igurl)
            icon.kf.setImage(with: url, placeholder: UIImage (named: "avatar_default"), options: nil, progressBlock: nil, completionHandler: nil)
        }
        
        timeLable.text = "发布于 " + Date.dateFormatterWithString(String.isNullOrEmpty(d["date"]))

    }

    @IBAction func zanBtnAction(_ sender: UIButton) {
        
        
    }
    
    
}
