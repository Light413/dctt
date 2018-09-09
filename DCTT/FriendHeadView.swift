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
        
        msg.layer.backgroundColor = UIColor.black.withAlphaComponent(0.2).cgColor;
    }
    
    func fill(_ d : [String:Any]) {
        let text = String.isNullOrEmpty(d["content"])
        let paragraphStyle = NSMutableParagraphStyle.init()
        paragraphStyle.lineSpacing = 2
        paragraphStyle.lineBreakMode = .byCharWrapping
        paragraphStyle.firstLineHeadIndent = 0
        
        let attridic:[String:Any] = [
            NSFontAttributeName:UIFont.boldSystemFont(ofSize: 17) ,
            NSParagraphStyleAttributeName:paragraphStyle,
            NSKernAttributeName:1
        ]
        
        let attriStr = NSAttributedString.init(string: text, attributes: attridic)
        msg.attributedText = attriStr
        
        
        
        let imagePath = String.isNullOrEmpty(d["images"])
        if let url = URL.init(string: imagePath) {
            bgImg.setImage(path: url)
        }
        
        //dateLable.text = "发布于 " + Date.dateFormatterWithString(String.isNullOrEmpty(d["postDate"]))
    }
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
