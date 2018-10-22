//
//  TodayViewCell.swift
//  DCTT
//
//  Created by wyg on 2018/10/22.
//  Copyright © 2018年 Light.W. All rights reserved.
//

import UIKit

class TodayViewCell: UITableViewCell {

    @IBOutlet weak var date: UILabel!
    
    @IBOutlet weak var content: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    
    func fill(_ d :[String:Any]) {
        let _date = Tools.stringToDate(String.isNullOrEmpty(d["date"]), formatter: "yyyyMMdd")
        let _str = Tools.dateToString(_date, formatter: "yyyy年MM月dd日")
        date.text = _str + ": " + String.isNullOrEmpty(d["title"])
        
        let paragraphStyle = NSMutableParagraphStyle.init()
         paragraphStyle.lineSpacing = 3
         paragraphStyle.lineBreakMode = .byCharWrapping
         //paragraphStyle.firstLineHeadIndent = 0
         
         let attri:[String:Any] = [
         NSFontAttributeName:UIFont.systemFont(ofSize: 15) ,
         NSParagraphStyleAttributeName:paragraphStyle,
         NSKernAttributeName:1
         ]
         
         let attriStr = NSAttributedString.init(string: String.isNullOrEmpty(d["event"]), attributes: attri)
         content.attributedText = attriStr
    }
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
