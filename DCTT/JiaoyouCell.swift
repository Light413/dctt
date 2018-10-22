//
//  JiaoyouCell.swift
//  DCTT
//
//  Created by wyg on 2018/9/18.
//  Copyright © 2018年 Light.W. All rights reserved.
//

import UIKit

class JiaoyouCell: ServerBaseCell {

    @IBOutlet weak var sex: UILabel!
    
    @IBOutlet weak var meInfo: UILabel!
    
    @IBOutlet weak var wantYou: UILabel!
    
    ///信息类别
    var infoType:String!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
//        sex.layer.cornerRadius = 8
//        sex.layer.masksToBounds = true
        
    }

    override func fill(_ dic:[String:Any]) {
        let cc = String.isNullOrEmpty(dic["content"])
        if let d = objectFrom(cc) {
            sex.text = String.isNullOrEmpty(d["type"]) == "0" ? "我是男生" : "我是女生"
            meInfo.text = isHasNewLine(String.isNullOrEmpty(d["content"]))
            wantYou.text = String.isNullOrEmpty(d["hope"])
        }

    }
 
}
