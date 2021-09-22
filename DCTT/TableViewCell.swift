//
//  TableViewCell.swift
//  DCTT
//
//  Created by wyg on 2021/2/26.
//  Copyright © 2021 Light.W. All rights reserved.
//

import UIKit
import SkeletonView
class TableViewCell: UITableViewCell {
    @IBOutlet weak var avatarImg: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        avatarImg.layer.cornerRadius = 17.5;
        avatarImg.layer.masksToBounds = true;
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
