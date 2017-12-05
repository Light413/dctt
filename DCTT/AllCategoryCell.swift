//
//  AllCategoryCell.swift
//  DCTT
//
//  Created by gener on 17/11/27.
//  Copyright © 2017年 Light.W. All rights reserved.
//

import UIKit

class AllCategoryCell: UICollectionViewCell {

    @IBOutlet weak var img: UIImageView!
    
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var numberLab: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        layer.borderWidth = 1
        layer.borderColor = UIColor (red: 232/255.0, green: 232/255.0, blue: 232/255.0, alpha: 1).cgColor
        
    }
    
    
    

}
