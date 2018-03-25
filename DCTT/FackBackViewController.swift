//
//  FackBackViewController.swift
//  DCTT
//
//  Created by wyg on 2018/3/25.
//  Copyright © 2018年 Light.W. All rights reserved.
//

import UIKit

class FackBackViewController: PublishViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = leftBarButtonItem()
        navigationItem.rightBarButtonItem = nil
        
        title = "意见反馈"
    }

    func leftBarButtonItem() -> UIBarButtonItem {
        let backbtn = UIButton (frame: CGRect (x: 0, y: 0, width: 30, height: 30))
        backbtn.setImage(UIImage (named: "leftbackicon_sdk_login"), for: .normal)
        backbtn.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 10)
        backbtn.addTarget(self, action: #selector(navigationBackButtonAction), for: .touchUpInside)
        let leftitem = UIBarButtonItem.init(customView: backbtn)
        
        return leftitem
        
    }

   override func navigationBackButtonAction() {
        self.navigationController?.popViewController(animated: true)
    }

    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (self.navigationController?.navigationBar.isHidden)! {
            self.navigationController?.setNavigationBarHidden(false, animated: animated)
        }
        
    }

    
    
    
    
}
