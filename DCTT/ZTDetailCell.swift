//
//  ZTDetailCell.swift
//  DCTT
//
//  Created by wyg on 2018/9/19.
//  Copyright © 2018年 Light.W. All rights reserved.
//

import UIKit

class ZTDetailCell: ServerBaseCell{

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var content: UILabel!
    
    override func fill(_ dic:[String:Any]) {
        let cc = String.isNullOrEmpty(dic["content"])
        if let d = objectFrom(cc) {
            title.text = "\"" + String.isNullOrEmpty(d["title"]) + "\""
            content.text = isHasNewLine(String.isNullOrEmpty(d["content"]))
        }
        
    }

    
}
