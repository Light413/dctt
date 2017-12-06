//
//  BaseViewController.swift
//  Toolbox
//
//  Created by gener on 17/6/26.
//  Copyright © 2017年 Light. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    var t_barTintColor:UIColor?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = kTableviewBackgroundColor;

        if let ishide = self.navigationController?.navigationBar.isHidden {
            if ishide {
                let _topBg = UIView .init(frame: CGRect (x: 0, y: 0, width: kCurrentScreenWidth, height: 64))
                _topBg.backgroundColor = tt_defafault_barColor
                view.addSubview(_topBg)
                
                let backbtn = UIButton (frame: CGRect (x: 15, y: 27, width: 30, height: 30))
                backbtn.setImage(UIImage (named: "leftbackicon_sdk_login"), for: .normal)
                backbtn.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 10)
                
                _topBg.addSubview(backbtn)
                //backbtn.addTarget(self, action: #selector(navigationBackButtonAction), for: .touchUpInside)
                
            }
        }

        
    }


    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
