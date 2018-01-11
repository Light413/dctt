//
//  HomeDetailHeadView.swift
//  DCTT
//
//  Created by gener on 2018/1/10.
//  Copyright © 2018年 Light.W. All rights reserved.
//

import UIKit

class HomeDetailHeadView: UIView {

    @IBOutlet weak var iconImg: UIImageView!
    
    @IBOutlet weak var nameLable: UILabel!
    
    @IBOutlet weak var dateLable: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        iconImg.layer.cornerRadius = 20
        iconImg.layer.masksToBounds = true
        
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(tapIconAction))
        iconImg.addGestureRecognizer(tapGesture)
        
    }
    
    func tapIconAction()  {
        print("jump to user profile")
    }
    
    
    //点击关注
    @IBAction func watchButtonAction(_ sender: Any) {
    }
    
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
