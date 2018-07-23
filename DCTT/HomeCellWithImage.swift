//
//  HomeCellWithImage.swift
//  DCTT
//
//  Created by wyg on 2017/12/18.
//  Copyright © 2017年 Light.W. All rights reserved.
//

import UIKit
import Kingfisher

class HomeCellWithImage: UITableViewCell {

    @IBOutlet weak var msg: UILabel!
    
    @IBOutlet weak var igv: UIImageView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    func fill(_ d:[String:Any]) {
        msg.text = d["content"] as? String
        
        let images = String.isNullOrEmpty(d["images"])
        let arr = images.components(separatedBy: ",")
        guard arr.count > 0 else { return}
        
        let url = URL.init(string: arr.first!)
        igv.kf.setImage(with: url)
    }
    
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
