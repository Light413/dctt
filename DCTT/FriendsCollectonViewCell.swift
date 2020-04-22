//
//  FriendsCollectonViewCell.swift
//  DCTT
//
//  Created by gener on 17/11/21.
//  Copyright © 2017年 Light.W. All rights reserved.
//

import UIKit

class FriendsCollectonViewCell: UICollectionViewCell {
    @IBOutlet weak var iconimg: UIImageView!

    @IBOutlet weak var nameLable: UILabel!
    
    @IBOutlet weak var avatar: UIImageView!
    
    
    @IBOutlet weak var msg: UILabel!
    
    
    @IBOutlet weak var age: UILabel!
    
    @IBOutlet weak var commentNum: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        layer.borderWidth = 1
        layer.borderColor = UIColor (red: 232/255.0, green: 232/255.0, blue: 232/255.0, alpha: 1).cgColor
        
        msg.layer.backgroundColor = UIColor.black.withAlphaComponent(0.2).cgColor
        nameLable.layer.backgroundColor = UIColor.black.withAlphaComponent(0.5).cgColor
    }

    
    func fill(_ d:[String:Any]) {
        guard let dic = d["user"] as? [String:Any] else {return}
        if let igurl = dic["avatar"] as? String {
            let url = URL.init(string: igurl)
            avatar.setImage(path: url!)
            
        }
        
        let igurl = URL.init(string: String.isNullOrEmpty(d["images"]))
        iconimg.setImage(path: igurl!)
        
        var s = ""
        let name = String.isNullOrEmpty(dic["name"]);
        if name.lengthOfBytes(using: String.Encoding.utf8) > 0  {
            s = name;
        }
        else
            if let name = dic["nickName"] as? String {
                s = name;
        }
        nameLable.text = s

        /////////////msg
        let paragraphStyle = NSMutableParagraphStyle.init()
        paragraphStyle.lineSpacing = 3
        paragraphStyle.lineBreakMode = .byCharWrapping
        paragraphStyle.firstLineHeadIndent = 15
        
        let attri:[String:Any] = [
            convertFromNSAttributedStringKey(NSAttributedString.Key.font):UIFont.boldSystemFont(ofSize: 17) ,
            convertFromNSAttributedStringKey(NSAttributedString.Key.paragraphStyle):paragraphStyle,
            convertFromNSAttributedStringKey(NSAttributedString.Key.kern):1
        ]
        
        let content = String.isNullOrEmpty(d["content"])
        let attriStr = NSAttributedString.init(string: content, attributes: convertToOptionalNSAttributedStringKeyDictionary(attri))
        msg.attributedText = attriStr

        
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
