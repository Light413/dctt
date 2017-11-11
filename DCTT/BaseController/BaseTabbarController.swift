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

        // Do any additional setup after loading the view.
        
        initTabar()
        
    }

    func initTabar() {
        tabBar.barTintColor = UIColor.white //kBartintColor
        
        let itemtitleArr = [
            "Airplane Selector",
            "Publications",
            "TOC",
            "Viewer",
            "History",
            "Bookmarks",
            "Manager"]
        let itemimg = [
            "tabicon_airplane_selector",
            "tabicon_publications",
            "tabicon_toc",
            "tabicon_viewer",
            "tabicon_history",
            "tabicon_bookmarks",
            "tabicon_manager"]
        
        let vcname =
            [
                "HomeViewController",
                "FriendsViewController",
                "PublishViewController",
                "AllViewController",
                "MeViewController"]
        
        var viewControllerArr:Array = [UIViewController]()

        for i in 0...vcname.count{
            let appname = Bundle.main.infoDictionary!["CFBundleExecutable"] as! String
            let cls  =  NSClassFromString(appname + "." + vcname[i]) as! BaseViewController.Type
            let vc = cls.init()
            
            vc.tabBarItem = UITabBarItem (title: itemtitleArr[i], image: UIImage (named: itemimg[i]), tag: 0)
            let navigationvc = BaseNavigationController(rootViewController:vc)
            viewControllerArr.append(navigationvc)
        }

        
        viewControllers = viewControllerArr
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
