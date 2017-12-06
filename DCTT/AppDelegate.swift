//
//  AppDelegate.swift
//  DCTT
//
//  Created by wyg on 2017/11/11.
//  Copyright © 2017年 Light.W. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate ,UITabBarControllerDelegate{

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow (frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white
        let tabBarController = BaseTabbarController()
        tabBarController.delegate = self
        window?.rootViewController =  tabBarController
        window?.makeKeyAndVisible()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    
    var pop:TTPublishView!
    
    //MARK:
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController.tabBarItem.tag == 2 {
            //
            /*let vc = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
            let action1 = UIAlertAction.init(title: "action1", style: .default, handler: { (action) in
                
            })
            let action2 = UIAlertAction.init(title: "action2", style: .default, handler: { (action) in
                
            })

            let action3 = UIAlertAction.init(title: "action3", style: .cancel, handler: { (action) in
                
            })
            vc.addAction(action1)
            vc.addAction(action2)
            vc.addAction(action3)
            
            UIApplication.shared.keyWindow?.rootViewController?.present(vc, animated: true, completion: nil)*/
            
            TTPublishView.show({ (index) in
                switch index {
                    case 1:
                        let vc = PublishViewController()
                        let nav = UINavigationController (rootViewController:vc)
                        UIApplication.shared.keyWindow?.rootViewController?.present(nav, animated: true, completion: nil)
                        
                        break;
                    case 2:
                        
                        break;
                    case 3:
                        
                        break;
                    default:break;
                    
                }
                
                
            })

            
            return false
        }
        
        return true
    }

}

