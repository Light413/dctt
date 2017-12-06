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
        msg.text = "发表新动态..."
        msg.font = UIFont.systemFont(ofSize: 15)
        msg.textColor = UIColor.lightGray

        self.addSubview(msg)
        
    }
    
    
    func textViewDidChange(_ textView: UITextView) {
        msg.isHidden = textView.text.lengthOfBytes(using: String.Encoding.utf8) > 0 ? true : false

    }
    
    
}
