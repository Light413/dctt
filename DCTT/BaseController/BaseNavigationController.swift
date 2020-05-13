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

    override var modalPresentationStyle: UIModalPresentationStyle{
        get{
            return .fullScreen
        }
        
        set{
            
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationBar.isTranslucent = false
        navigationBar.titleTextAttributes = convertToOptionalNSAttributedStringKeyDictionary([NSAttributedString.Key.foregroundColor.rawValue:UIColor.black,NSAttributedString.Key.font.rawValue:UIFont.systemFont(ofSize: 17)])

//        navigationBar.setBackgroundImage(UIImage (named: "navigationbar_bg"), for: .default)

        //navigationBar.shadowImage = UIImage();
//        navigationBar.setBackgroundImage(imageWithColor(tt_defafault_barColor), for: .default)
    }
    
    func imageWithColor(_ color:UIColor) -> UIImage? {
        let rect = CGRect (x: 0, y: 0, width: 1, height: 1)
        
        UIGraphicsBeginImageContext(rect.size)
        
        let ctx = UIGraphicsGetCurrentContext()
        
        ctx?.setFillColor(color.cgColor)
        
        ctx?.fill(rect)
        
        let ig = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return ig
        
    }
    
    func leftBarButtonItem() -> UIBarButtonItem {
        let backbtn = UIButton (frame: CGRect (x: 0, y: 0, width: 30, height: 30))
        backbtn.setImage(UIImage (named: "leftbackicon_sdk_login"), for: .normal)
        backbtn.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: -10, bottom: 0, right: 10)
        backbtn.addTarget(self, action: #selector(navigationBackButtonAction), for: .touchUpInside)
        let leftitem = UIBarButtonItem.init(customView: backbtn)

        return leftitem
        
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if self.viewControllers.count > 0 {
            viewController.navigationItem.leftBarButtonItem = leftBarButtonItem()
            
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
    
    
    @objc func navigationBackButtonAction() {
       _ = self.popViewController(animated: true)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}
