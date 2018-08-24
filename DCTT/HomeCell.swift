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
            var s = ""
            let name = String.isNullOrEmpty(dic["name"]);
            if name.lengthOfBytes(using: String.Encoding.utf8) > 0  {
                s = name;
            }
            else
                if let name = dic["nickName"] as? String {
                    s = name;
            }
            
            name.text = s
            
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
