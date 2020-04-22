//
//  TableViewCellTextView.swift
//  DCTT
//
//  Created by wyg on 2018/2/4.
//  Copyright © 2018年 Light.W. All rights reserved.
//

import UIKit

class TableViewCellTextView: UITableViewCell,UITextViewDelegate {

    @IBOutlet weak var msgTextView: UITextView!

    var msg:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        msgTextView.delegate = self
        
        msg = UILabel (frame: CGRect (x: 8, y: 0, width: 100, height: 30))
        msg.text = "请输入内容..."
        msg.font = UIFont.systemFont(ofSize: 15)
        msg.textColor = UIColor.lightGray
        
        self.addSubview(msg)
        
    }
    
    
    func textViewDidChange(_ textView: UITextView) {
        msg.isHidden = textView.text.lengthOfBytes(using: String.Encoding.utf8) > 0 ? true : false
        
        let paragraphStyle = NSMutableParagraphStyle.init()
        paragraphStyle.lineSpacing = 3
        paragraphStyle.lineBreakMode = .byCharWrapping
        //paragraphStyle.firstLineHeadIndent = 0
        
        let dic:[String:Any] = [
            convertFromNSAttributedStringKey(NSAttributedString.Key.font):UIFont.systemFont(ofSize: 16) ,
            convertFromNSAttributedStringKey(NSAttributedString.Key.paragraphStyle):paragraphStyle,
            convertFromNSAttributedStringKey(NSAttributedString.Key.kern):1
        ]
        
        let attriStr = NSAttributedString.init(string: textView.text, attributes: convertToOptionalNSAttributedStringKeyDictionary(dic))
        textView.attributedText = attriStr
        
        
    }

    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
	return input.rawValue
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}
