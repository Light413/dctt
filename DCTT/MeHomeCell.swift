//
//  MeHomeCell.swift
//  DCTT
//
//  Created by wyg on 2018/3/18.
//  Copyright © 2018年 Light.W. All rights reserved.
//

import UIKit

class MeHomeCell: UITableViewCell {

    @IBOutlet weak var postDate: UILabel!
    
    @IBOutlet weak var msg: UILabel!
    
    @IBOutlet weak var readCnt: UILabel!
    
    @IBOutlet weak var praiseCnt: UILabel!
    
    @IBOutlet weak var commentCnt: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func fill(_ d:[String:Any]) {
        postDate.text = "发布于" + String.isNullOrEmpty(d["postDate"])//...日期
        msg.text = String.isNullOrEmpty(d["content"])
        
        readCnt.text = "阅读" + String.isNullOrEmpty(d["readCnt"])
        praiseCnt.text = "赞" + String.isNullOrEmpty(d["praiseCnt"])
        
        let comm = String.isNullOrEmpty(d["comment"])
        commentCnt.text = "评论" + (comm.lengthOfBytes(using: String.Encoding.utf8) > 0 ? comm : "0")
    }
    
}
