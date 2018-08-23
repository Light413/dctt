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
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var time: UILabel!
    
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
        
        guard let u_info = d["user"] as? [String:Any] else {return}
        
        let uname = String.isNullOrEmpty(u_info["name"]).lengthOfBytes(using: String.Encoding.utf8) > 0 ? String.isNullOrEmpty(u_info["name"]) : String.isNullOrEmpty(u_info["name"])
        name.text = uname
        
        time.text = Date.dateFormatterWithString(String.isNullOrEmpty(d["postDate"]))
    }
    
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
