//
//  _TodayDetailCell.swift
//  DCTT
//
//  Created by wyg on 2018/10/23.
//  Copyright © 2018年 Light.W. All rights reserved.
//

import UIKit

class _TodayDetailCell: UITableViewCell {

    @IBOutlet weak var e_title: UILabel!
    
    
    @IBOutlet weak var e_content: UILabel!
    
    
    func fill(_ d :[String:Any]) {
        e_title.text =  String.isNullOrEmpty(d["title"])
        
        let paragraphStyle = NSMutableParagraphStyle.init()
        paragraphStyle.lineSpacing = 5
        paragraphStyle.lineBreakMode = .byCharWrapping
        //paragraphStyle.firstLineHeadIndent = 0
        
        let attri:[String:Any] = [
            NSFontAttributeName:UIFont.systemFont(ofSize: 16) ,
            NSParagraphStyleAttributeName:paragraphStyle,
            NSKernAttributeName:1
        ]
        
        let attriStr = NSAttributedString.init(string: String.isNullOrEmpty(d["event"]), attributes: attri)
        e_content.attributedText = attriStr
    }
}
