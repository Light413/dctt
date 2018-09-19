//
//  ShangjiaCell.swift
//  DCTT
//
//  Created by wyg on 2018/9/18.
//  Copyright © 2018年 Light.W. All rights reserved.
//

import UIKit

class ShangjiaCell: ServerBaseCell {
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var name_w: NSLayoutConstraint!
    
    
    @IBOutlet weak var detailDes: UILabel!
    
    @IBOutlet weak var address: UILabel!
    
    @IBOutlet weak var tel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    override func fill(_ dic:[String:Any]) {
        let cc = String.isNullOrEmpty(dic["content"])
        if let d = objectFrom(cc) {
            name.text = String.isNullOrEmpty(d["name"])
            let size = String.isNullOrEmpty(d["name"]).boundingRect(with: CGSize.init(width: self.frame.width, height: 50), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName:name.font], context: nil)
            name_w.constant = size.width + 20
            
            detailDes.text = String.isNullOrEmpty(d["content"])
            address.text = String.isNullOrEmpty(d["address"])
            tel.text = String.isNullOrEmpty(d["tel"])
        }
        
    }

    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
