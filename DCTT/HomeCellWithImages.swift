//
//  HomeCellWithImages.swift
//  DCTT
//
//  Created by wyg on 2017/12/18.
//  Copyright © 2017年 Light.W. All rights reserved.
//

import UIKit
import Kingfisher

class HomeCellWithImages: UITableViewCell {
    @IBOutlet weak var msg: UILabel!
    
    @IBOutlet weak var ig1: UIImageView!
    @IBOutlet weak var ig2: UIImageView!
    @IBOutlet weak var ig3: UIImageView!
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    func fill(_ d:[String:Any]) {
        msg.text = d["content"] as? String
        
        let images = String.isNullOrEmpty(d["images"])
        let arr = images.components(separatedBy: ",")
        guard arr.count > 0 else { return}
        
        for i in 0..<3 {
            let url = URL.init(string: arr[i])
            
            if let igv = self.contentView.viewWithTag(10 + i) as? UIImageView {
                igv.kf.setImage(with: url)
            }
            
        }
        
        
    }

    
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
