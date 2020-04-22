//
//  BaseTabbarController.swift
//  Toolbox
//
//  Created by gener on 17/6/26.
//  Copyright © 2017年 Light. All rights reserved.
//

import UIKit

class BaseTabbarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        initTabar()
    }

    func initTabar() {
        tabBar.barTintColor = UIColor.white //kBartintColor
        
        let itemtitleArr = [
            "首页",
            "话题",
            "",
            "生活",
            "个人中心"]

        let icon_normal:Array = [
            "tabbar_icon_home",
            "tabbar_icon_friend",
            "tabbar_icon_publish" ,
            "tabbar_icon_all",
            "tabbar_icon_me" ]
        let icon_selected = [
            "tabbar_icon_home_selected",
            "tabbar_icon_friend_selected",
            "tabbar_icon_publish" ,
            "tabbar_icon_all_selected",
            "tabbar_icon_me_selected" ]
        
        let vcname = [
                "HomeViewController",
                "FriendRootController",
                "BaseViewController",
                "AllViewController",
                "MeViewController"]
        
        var viewControllerArr:Array = [UIViewController]()
        for i in 0..<vcname.count {
            let appname = Bundle.main.infoDictionary!["CFBundleExecutable"] as! String
            let cls  =  NSClassFromString(appname + "." + vcname[i]) as! BaseViewController.Type
            var vc:UIViewController!
            
            if i < vcname.count {
                vc = cls.init()
            }else{
                vc = UIStoryboard.init(name: "me", bundle: nil).instantiateViewController(withIdentifier: "me_stroryboar_identity")
            }
            
            let barItem = UITabBarItem (title: itemtitleArr[i], image: UIImage (named: icon_normal[i])?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage (named: icon_selected[i])?.withRenderingMode(.alwaysOriginal))
            barItem.tag = i
            if i == 2 {
                barItem.imageInsets = UIEdgeInsets.init(top: 5, left: 0, bottom: -5, right: 0)
            }
            
            barItem.setTitleTextAttributes(convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor):UIColor.black]), for: .selected)
            vc.tabBarItem = barItem
            vc.title = itemtitleArr[i]
            
            let navigationvc = BaseNavigationController(rootViewController:vc)
            viewControllerArr.append(navigationvc)
        }

        
        viewControllers = viewControllerArr
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

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
	return input.rawValue
}
