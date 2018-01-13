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
        let text = "马克思改变人们的思想，马化腾改变了人们的交流方式，马云改变了我的消费观念"
        let paragraphStyle = NSMutableParagraphStyle.init()
        paragraphStyle.lineSpacing = 3
        paragraphStyle.lineBreakMode = .byCharWrapping
        paragraphStyle.firstLineHeadIndent = 0
        
        let dic:[String:Any] = [
            NSFontAttributeName:UIFont.systemFont(ofSize: 15) ,
            NSParagraphStyleAttributeName:paragraphStyle,
            NSKernAttributeName:1
        ]
        
        let attriStr = NSAttributedString.init(string: text, attributes: dic)
        msgText.attributedText = attriStr
        
        
    }
    
    

    @IBAction func zanBtnAction(_ sender: UIButton) {
        
        
    }
    
    
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
