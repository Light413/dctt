//
//  HomeCell.swift
//  DCTT
//
//  Created by gener on 17/11/21.
//  Copyright © 2017年 Light.W. All rights reserved.
//

import UIKit

class HomeCell: UITableViewCell {
    @IBOutlet weak var msg: UILabel!
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var time: UILabel!
    
    func fill(_ d:[String:Any]) {
        msg.text = String.isNullOrEmpty(d["content"])
        
        if let u_info = d["user"] as? [String:Any]  {
            let uname = String.isNullOrEmpty(u_info["name"]).lengthOfBytes(using: String.Encoding.utf8) > 0 ? String.isNullOrEmpty(u_info["name"]) : String.isNullOrEmpty(u_info["name"])
            name.text = uname
            
            time.text = Date.dateFormatterWithString(String.isNullOrEmpty(d["postDate"]))
            
            
        }

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
