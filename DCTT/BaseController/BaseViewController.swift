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
                backbtn.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: -10, bottom: 0, right: 10)
                
                _topBg.addSubview(backbtn)
                //backbtn.addTarget(self, action: #selector(navigationBackButtonAction), for: .touchUpInside)
                
            }
        }

        
    }


    //more_toolbar_press
     func addRightNavigationItem()  {
        let backbtn = UIButton (frame: CGRect (x: 0, y: 0, width: 40, height: 30))
        backbtn.setImage(UIImage (named: "more_toolbar_press"), for: .normal)
        backbtn.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        backbtn.addTarget(self, action: #selector(_rightItemAction) , for: .touchUpInside)
        let leftitem = UIBarButtonItem.init(customView: backbtn)
        navigationItem.rightBarButtonItem = leftitem
    }
    
    @objc func _rightItemAction()  {
//        let alertViewContronller = UIAlertController.init(title: "是否举报该作者发布的这条动态?", message: nil, preferredStyle: .actionSheet)
//
//        
//        let action2 = UIAlertAction.init(title: "举报", style: .default, handler: { (action) in
//            
//        })
//        
//        let action3 = UIAlertAction.init(title: "取消", style: .cancel, handler: nil)
//        
//        alertViewContronller.addAction(action2)
//        alertViewContronller.addAction(action3)
//        
//        self.navigationController?.present(alertViewContronller, animated: true, completion: nil)
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
