//
//  QiuzhiCell.swift
//  DCTT
//
//  Created by wyg on 2018/9/18.
//  Copyright © 2018年 Light.W. All rights reserved.
//

import UIKit

class QiuzhiCell: ServerBaseCell {
    ///信息类别
    var infoType:String!
    
    @IBOutlet weak var subType: UILabel!
   
    @IBOutlet weak var desTitle: UILabel!
    
    @IBOutlet weak var detailDes: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func fill(_ dic:[String:Any]) {
        let cc = String.isNullOrEmpty(dic["content"])
        if let d = objectFrom(cc) {
            let index = String.isNullOrEmpty(d["type"])
            subType.text = type(dic, subType: index)
            detailDes.text = isHasNewLine(String.isNullOrEmpty(d["content"]))
            
            desTitle.text = String.isNullOrEmpty(d["title"])
        }

    }
    
    func type(_ data:[String:Any] , subType:String) -> String? {
        let type = String.isNullOrEmpty(data["type"])
        
        switch type {
        case "21": return subType == "0" ? "找工作":"招聘"
        case "24": return subType == "0" ? "我是房主":"我要找房"
        case "25": return subType == "0" ? "我是车主":"我要打车";
            
        case "23": return subType == "0" ? "我是男生" : "我是女生";
        default:return nil
        }
    }
}
