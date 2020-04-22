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
            convertFromNSAttributedStringKey(NSAttributedString.Key.font):UIFont.boldSystemFont(ofSize: 17) ,
            convertFromNSAttributedStringKey(NSAttributedString.Key.paragraphStyle):paragraphStyle,
            convertFromNSAttributedStringKey(NSAttributedString.Key.kern):1
        ]
        
        let attriStr = NSAttributedString.init(string: text, attributes: convertToOptionalNSAttributedStringKeyDictionary(attridic))
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

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
	return input.rawValue
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}
