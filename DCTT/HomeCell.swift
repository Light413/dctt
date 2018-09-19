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
    
    override func fill(_ d:[String:Any]) {
        fillData(msg: msg, user: name, date: time, data: d)
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
