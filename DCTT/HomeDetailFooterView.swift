//
//  HomeDetailFooterView.swift
//  DCTT
//
//  Created by wyg on 2018/1/25.
//  Copyright © 2018年 Light.W. All rights reserved.
//

import UIKit

class HomeDetailFooterView: UIView {

    @IBOutlet weak var zanBtn: UIButton!
    
    
    override func awakeFromNib() {
        zanBtn.contentHorizontalAlignment = .center
        zanBtn.layer.cornerRadius = 12.5
        zanBtn.layer.masksToBounds = true
        zanBtn.layer.borderWidth = 0.5
        zanBtn.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    @IBAction func zanBtnAction(_ sender: UIButton) {
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
