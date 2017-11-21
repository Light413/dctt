//
//  FriendsCollectonViewCell.swift
//  DCTT
//
//  Created by gener on 17/11/21.
//  Copyright © 2017年 Light.W. All rights reserved.
//

import UIKit

class FriendsCollectonViewCell: UICollectionViewCell {
    @IBOutlet weak var iconimg: UIImageView!

    @IBOutlet weak var nameLable: UILabel!
    
    @IBOutlet weak var age: UILabel!
    
    @IBOutlet weak var commentNum: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        layer.borderWidth = 1
        layer.borderColor = UIColor (red: 232/255.0, green: 232/255.0, blue: 232/255.0, alpha: 1).cgColor
        
        iconimg.image = UIImage (named: "ymtimg2.jpg")
    }

}
