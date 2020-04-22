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
            convertFromNSAttributedStringKey(NSAttributedString.Key.font):UIFont.systemFont(ofSize: 16) ,
            convertFromNSAttributedStringKey(NSAttributedString.Key.paragraphStyle):paragraphStyle,
            convertFromNSAttributedStringKey(NSAttributedString.Key.kern):1
        ]
        
        let attriStr = NSAttributedString.init(string: String.isNullOrEmpty(d["event"]), attributes: convertToOptionalNSAttributedStringKeyDictionary(attri))
        e_content.attributedText = attriStr
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
