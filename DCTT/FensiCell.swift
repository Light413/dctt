//
//  FensiCell.swift
//  DCTT
//
//  Created by wyg on 2018/4/12.
//  Copyright © 2018年 Light.W. All rights reserved.
//

import UIKit

class FensiCell: UITableViewCell {

    @IBOutlet weak var guanzhu_btn: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        guanzhu_btn.layer.borderWidth = 1
        guanzhu_btn.layer.borderColor = UIColor.init(red: 216 / 255.0, green: 61 / 255.0, blue: 52 / 255.0, alpha: 1).cgColor
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
