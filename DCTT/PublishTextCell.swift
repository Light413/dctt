//
//  PublishTextCell.swift
//  DCTT
//
//  Created by gener on 2017/12/5.
//  Copyright © 2017年 Light.W. All rights reserved.
//

import UIKit

class PublishTextCell: UICollectionViewCell,UITextViewDelegate {
    @IBOutlet weak var textview: UITextView!

    var msg:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        textview.delegate = self
        
        msg = UILabel (frame: CGRect (x: 8, y: 0, width: 100, height: 30))
        msg.text = "请输入内容..."
        msg.font = UIFont.systemFont(ofSize: 15)
        msg.textColor = UIColor.lightGray

        self.addSubview(msg)
        
    }
    

    func textViewDidChange(_ textView: UITextView) {
        msg.isHidden = textView.text.lengthOfBytes(using: String.Encoding.utf8) > 0 ? true : false

        /*let paragraphStyle = NSMutableParagraphStyle.init()
        paragraphStyle.lineSpacing = 3
        paragraphStyle.lineBreakMode = .byCharWrapping
        //paragraphStyle.firstLineHeadIndent = 0
        
        let dic:[String:Any] = [
            NSFontAttributeName:UIFont.systemFont(ofSize: 16) ,
            NSParagraphStyleAttributeName:paragraphStyle,
            NSKernAttributeName:1
        ]
        
        let attriStr = NSAttributedString.init(string: textView.text, attributes: dic)
        textView.attributedText = attriStr*/
        
        
        
        /*let w = textView.frame.width
        let h = textView.frame.height
        
        let newsize = textView.sizeThatFits(CGSize (width: w, height: CGFloat(MAXFLOAT)))
        var newframe = textView.frame
        newframe.size = CGSize (width: fmax(w, newsize.width), height: fmax(h, newsize.height))
        
        textView.frame = newframe*/
        
    }
    
    
}
