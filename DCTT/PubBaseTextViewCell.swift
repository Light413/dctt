//
//  PubBaseTextViewCell.swift
//  DCTT
//
//  Created by wyg on 2018/3/4.
//  Copyright © 2018年 Light.W. All rights reserved.
//

import UIKit

class PubBaseTextViewCell: UITableViewCell ,UITextViewDelegate{
    var _text:String?

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    //MARK: - UITextViewDelegate
    func textViewDidChange(_ textView: UITextView) {
        for _v in self.contentView.subviews {
            if _v is UILabel {
                _v.isHidden = textView.text.lengthOfBytes(using: String.Encoding.utf8) > 0 ?   true : false
            }
        }
        
//        let paragraphStyle = NSMutableParagraphStyle.init()
//        paragraphStyle.lineSpacing = 3
//        paragraphStyle.lineBreakMode = .byCharWrapping
//        //paragraphStyle.firstLineHeadIndent = 0
//        
//        let dic:[String:Any] = [
//            NSFontAttributeName:UIFont.systemFont(ofSize: 16) ,
//            NSParagraphStyleAttributeName:paragraphStyle,
//            NSKernAttributeName:1
//        ]
//        
//        let attriStr = NSAttributedString.init(string: textView.text, attributes: dic)
//        textView.attributedText = attriStr
        
        _text = textView.text
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
