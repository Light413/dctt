//
//  FriendHeadView.swift
//  DCTT
//
//  Created by wyg on 2018/1/13.
//  Copyright © 2018年 Light.W. All rights reserved.
//

import UIKit

class FriendHeadView: UIView {

    @IBOutlet weak var bgImg: UIImageView!
    
    @IBOutlet weak var msg: UILabel!
    
    @IBOutlet weak var icon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let text = "前女友是我小姨子的上司，小姨子工作犯错要被开除，老婆让我找前女友求求情。于是我打了电话，前女友问明情况后说：“她让你找我，你就找我？你有没脑子的？明摆着在试探！我要是为了你帮这个忙，她一定整死你信不信？”"
        let paragraphStyle = NSMutableParagraphStyle.init()
        paragraphStyle.lineSpacing = 2
        paragraphStyle.lineBreakMode = .byCharWrapping
        paragraphStyle.firstLineHeadIndent = 0
        
        let dic:[String:Any] = [
            NSFontAttributeName:UIFont.systemFont(ofSize: 16) ,
            NSParagraphStyleAttributeName:paragraphStyle,
            NSKernAttributeName:1
        ]
        
        let attriStr = NSAttributedString.init(string: text, attributes: dic)
        msg.attributedText = attriStr
        
    }
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
