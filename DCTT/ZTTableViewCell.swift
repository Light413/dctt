//
//  ZTTableViewCell.swift
//  DCTT
//
//  Created by wyg on 2018/9/8.
//  Copyright © 2018年 Light.W. All rights reserved.
//

import UIKit

class ZTTableViewCell: UITableViewCell {

    @IBOutlet weak var bg: UIView!
    
    @IBOutlet weak var content: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        bg.layer.borderColor = kTableviewBackgroundColor.cgColor
        bg.layer.borderWidth = 2
        bg.layer.cornerRadius = 5        
        bg.layer.masksToBounds = true
        
        
        /////////////msg
        let paragraphStyle = NSMutableParagraphStyle.init()
        paragraphStyle.lineSpacing = 5
        paragraphStyle.lineBreakMode = .byCharWrapping
        paragraphStyle.firstLineHeadIndent = 30
        
        let attri:[String:Any] = [
            NSFontAttributeName:UIFont.systemFont(ofSize: 16) ,
            NSParagraphStyleAttributeName:paragraphStyle,
            //NSKernAttributeName:1
        ]
        
        let str = "前女友是我小姨子的上司，小姨子工作犯错要被开除，老婆让我找前女友求求情。于是我打了电话，前女友问明情况后说：“她让你找我，你就找我？你有没脑子的？明摆着在试探！我要是为了你帮这个忙，她一定整死你信不信？”"//String.isNullOrEmpty(d["content"])
        let attriStr = NSAttributedString.init(string: str, attributes: attri)
        content.attributedText = attriStr
        content.lineBreakMode = .byTruncatingTail;
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
