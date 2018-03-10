//
//  BaseNavigationController.swift
//  Toolbox
//
//  Created by gener on 17/6/26.
//  Copyright © 2017年 Light. All rights reserved.
//

import UIKit

class BaseNavigationController: KLTNavigationController,UINavigationControllerDelegate {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get{
            return .default
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //navigationBar.barTintColor = tt_BarColor //kBartintColor
        navigationBar.isTranslucent = false
        //navigationBar.tintColor = UIColor.white
        //navigationBar.barStyle = .black
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.black,NSFontAttributeName:UIFont.systemFont(ofSize: 15)]

//        navigationBar.setBackgroundImage(UIImage (named: "navigationbar_bg"), for: .default)
        //UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent;

    }
    
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if self.viewControllers.count > 0 {
        let backbtn = UIButton (frame: CGRect (x: 0, y: 0, width: 30, height: 30))
            backbtn.setImage(UIImage (named: "leftbackicon_sdk_login"), for: .normal)
            backbtn.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 10)
            backbtn.addTarget(self, action: #selector(navigationBackButtonAction), for: .touchUpInside)
            let leftitem = UIBarButtonItem.init(customView: backbtn)
            viewController.navigationItem.leftBarButtonItem = leftitem
            
            viewController.hidesBottomBarWhenPushed = true
        }

        self.navigationBar.barTintColor = colorWith(viewController) //(viewController.value(forKey: "t_barTintColor") as? UIColor ) ?? tt_defafault_barColor
        super.pushViewController(viewController, animated: animated)
    }

    func colorWith(_ controller:UIViewController) -> UIColor {
       let b =  controller.responds(to: Selector.init(("t_barTintColor")))
        var color = tt_defafault_barColor
        
        if b {
            color = (controller.value(forKey: "t_barTintColor") as? UIColor ) ?? tt_defafault_barColor
        }
        
       return color
    }
    
    override func popViewController(animated: Bool) -> UIViewController? {
        let cnt = self.viewControllers.count
        let last = self.viewControllers[cnt - 2]
        self.navigationBar.barTintColor = colorWith(last)//(last.value(forKey: "t_barTintColor") as? UIColor ) ?? tt_defafault_barColor

        return super.popViewController(animated: animated)
        
    }
    
    
    func navigationBackButtonAction() {
       _ = self.popViewController(animated: true)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
