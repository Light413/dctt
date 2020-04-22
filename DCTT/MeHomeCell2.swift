//
//  MeHomeCell2.swift
//  DCTT
//
//  Created by wyg on 2018/8/9.
//  Copyright © 2018年 Light.W. All rights reserved.
//

import UIKit

class MeHomeCell2: UITableViewCell {

    weak var superVC:MeHomePageController?
    var pagevc:UIViewController!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    func addWithController(_ controller:UIViewController) {
        pagevc = controller
        
        self.addSubview(pagevc.view)
//        self.superVC?.addChildViewController(pagevc)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
