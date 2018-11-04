//
//  HomeCell.swift
//  DCTT
//
//  Created by gener on 17/11/21.
//  Copyright © 2017年 Light.W. All rights reserved.
//

import UIKit

class HomeCell: HomeListBaseCell {
    @IBOutlet weak var msg: UILabel!
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var dislikeBtn: UIButton!
    
    override func fill(_ d:[String:Any]) {
        fillData(msg: msg, user: name, date: time, data: d)
    }
    
    @IBAction func dislikeAction(_ sender: Any) {
        Tools.showMsg(kNotLikeMsg, title: "确定") { [weak self] in
            guard let  ss = self else {return}
            if let b = ss.dislikeBlock {
                b()
            }
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        disLikeBtnSetStyle(dislikeBtn)
    }
    
}
