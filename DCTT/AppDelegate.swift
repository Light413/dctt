//
//  AppDelegate.swift
//  DCTT
//
//  Created by wyg on 2017/11/11.
//  Copyright © 2017年 Light.W. All rights reserved.
//

import UIKit
//import CoreLocation
import IQKeyboardManagerSwift
import Alamofire
import UserNotifications

let bugly_app_id = "6b7becdcc1"
let bugly_app_key = "c80a1d4b-8a8f-44b7-9734-99c95ba61e53"

///微信开放平台ID
let wxAppId = "wx99c8b9a7590b0c04"
let wxAppSecret = "01554d9297c4f65b6094a00cf6ef1f3e"
///QQ开发平台
let qqAppId = "101511561"
let qqAppKey = "b08bacb33bc8d4cd6ad00ce8ebbdf662"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate ,UITabBarControllerDelegate{

    var myDeviceToken:String?
    
    var window: UIWindow?
    //private let _locationManager = CLLocationManager.init();
    var _networkReachabilityManager:NetworkReachabilityManager!;
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow (frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white
        let tabBarController = BaseTabbarController()
        tabBarController.delegate = self
        window?.rootViewController =  tabBarController
        window?.makeKeyAndVisible()
        
        _initSys()
        
        let local = Locale.current
        let n = local.localizedString(forRegionCode: local.regionCode!);
        print(n!);
        
        return true
    }

    //MARK:- init
    func _initSys()  {
        HUD.config()

        _networkReachabilityManager = NetworkReachabilityManager(host: "www.baidu.com")
        _networkReachabilityManager.startListening{ status in
            print("Network Status Changed: \(status)")
        }
    
//        IQKeyboardManager.sharedManager().enable = true
//        IQKeyboardManager.sharedManager().enable = true
        UIApplication.shared.applicationIconBadgeNumber = 0
        sleep(1)
        
        //_initLocationServices()
        _initNotification()

        _initShare()
        
        ///bugly
#if !DEBUG
        Bugly.start(withAppId: bugly_app_id)
#endif

        //...
//        PgyManager.shared().isFeedbackEnabled = false
//        PgyManager.shared().start(withAppId: "9c9fb0ff56e817a981d4140ac9f949ba")
    }
    
    ///分享初始化
    func _initShare() {
        ShareSDK.registerActivePlatforms(
            [
                //SSDKPlatformType.typeWechat.rawValue,
                SSDKPlatformType.typeQQ.rawValue,
                
                SSDKPlatformType.subTypeWechatSession.rawValue,
                
                SSDKPlatformType.subTypeWechatTimeline.rawValue,
                
                ],
            onImport: {(platform : SSDKPlatformType) -> Void in
                switch platform
                {
                case SSDKPlatformType.typeWechat:
                    ShareSDKConnector.connectWeChat(WXApi.classForCoder())
                    
                case SSDKPlatformType.typeQQ:
                    ShareSDKConnector.connectQQ(QQApiInterface.classForCoder(), tencentOAuthClass: TencentOAuth.classForCoder())
                default:
                    break
                }
        },
            onConfiguration: {(platform : SSDKPlatformType , appInfo : NSMutableDictionary?) -> Void in
                switch platform
                {
                case SSDKPlatformType.typeWechat:
                    //设置微信应用信息
                    appInfo?.ssdkSetupWeChat(byAppId: wxAppId,
                                             appSecret: wxAppSecret)
                case SSDKPlatformType.typeQQ:
                    //设置QQ应用信息
                    appInfo?.ssdkSetupQQ(byAppId: qqAppId,
                                         appKey: qqAppKey,
                                         authType: SSDKAuthTypeWeb)
                default:
                    break
                }
        })
        
        
    }
    
    ///开启定位
    /*func _initLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            if CLLocationManager.authorizationStatus() == .denied {
                let vc = UIAlertController.init(title: nil, message: nil, preferredStyle: .alert)
                let action1 = UIAlertAction.init(title: "取消", style: .default, handler: nil)
                vc.title = "请在设置-定位中允许访问位置信息"
                let action2 = UIAlertAction.init(title: "去设置", style: .default, handler: { (action) in
                    let url = URL.init(string: UIApplicationOpenSettingsURLString);
                    if  UIApplication.shared.canOpenURL(url!){
                        UIApplication.shared.openURL(url!)
                    }
                })
                
                vc.addAction(action1)
                vc.addAction(action2)
                UIApplication.shared.keyWindow?.rootViewController?.present(vc, animated: true, completion: nil);
                return
            }
            
            _locationManager.delegate  = self
            _locationManager.desiredAccuracy = 10.0
            _locationManager.distanceFilter = kCLLocationAccuracyHundredMeters
            //_locationManager.allowsBackgroundLocationUpdates = true
            
            _locationManager.requestWhenInUseAuthorization();
            _locationManager.startUpdatingLocation()

        }else{
                let vc = UIAlertController.init(title: nil, message: nil, preferredStyle: .alert)
                let action1 = UIAlertAction.init(title: "取消", style: .default, handler: nil)
                vc.title = "请在系统设置中开启定位功能"
                let action2 = UIAlertAction.init(title: "去设置", style: .default, handler: { (action) in
                    let url = URL.init(string: "prefs:root=LOCATION_SERVICES");
                    if  UIApplication.shared.canOpenURL(url!){
                        UIApplication.shared.openURL(url!)
                    }
                })
                
                vc.addAction(action1)
                vc.addAction(action2)
                UIApplication.shared.keyWindow?.rootViewController?.present(vc, animated: true, completion: nil);
            }
            
    }*/
 
    func _initNotification() {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound, .badge]) { (b,error) in
                if b {
                    print("ios10 授权通知成功")
                }
            }

        } else {
            // Fallback on earlier versions
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings.init(types: [.alert,.sound,.badge], categories: nil))
        }
        
    }
    
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        print(#function)
        
        application.registerForRemoteNotifications()
    }
 
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print(#function)
        //AEFD81A8308B15169F992900A85C9CBCA29BF8E8549A154955765A94BE947E99
        let token = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        
        print(token)
        
        ///上传token
        myDeviceToken = token
        self.upDeviceInfo(token)
    }
 
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        print("didReceiveRemoteNotification: \(userInfo)")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(#function)
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
        let settings = UIApplication.shared.currentUserNotificationSettings
        let open = Int((settings?.types)!.rawValue) != 0
        
        NotificationCenter.default.post(name: NSNotification.Name.init("setter_notification_status"), object: nil, userInfo: ["is":open])
    }


    ///更新设备信息，忽略模拟器
    func upDeviceInfo(_ token:String) {
        #if arch(i386) || arch(x86_64)
            return;
        #endif        
        guard let uid = User.uid() else {return}
        AlamofireHelper.post(url: update_deviceInfo_url, parameters: ["uid":uid , "deviceType":1 , "token":token], successHandler: { (res) in
            //print(res)
        })
        
    }
    
    
    
    //MARK: -
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController.tabBarItem.tag == 2 {
            #if true
            guard User.isLogined() else {
                HUD.showText(kPleaseToLogin, view: UIApplication.shared.keyWindow!)
                return false
            }
            
            let typevc = PubSelectTypeController()
            let navi = BaseNavigationController(rootViewController: typevc)
            UIApplication.shared.keyWindow?.rootViewController?.present(navi, animated: true, completion: nil)
                
            #else
            TTPublishView.show({ (index) in
                var vc:UIViewController
                
                switch index {
                    case 1:
                         vc = PublishViewController()
                        
                        break;
                    case 2:
                        vc = PublishFriendController()
                        break;
                    case 3:
                        vc = PublishServerController()
                        break;
                default:return;//break;
                    
                }
                
                let nav = UINavigationController (rootViewController:vc)
                UIApplication.shared.keyWindow?.rootViewController?.present(nav, animated: true, completion: nil)
                
            })

            #endif
 
            return false
        }
        
        return true
    }

    
    
    //MARK: - CLLocationManagerDelegate
    /*func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(#function)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations.last)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
            case .authorizedWhenInUse:
                print("authorizedWhenInUse")
                break
            case .notDetermined:
                print("notDetermined")
                break
            case .restricted :
                print("restricted")
                break
            default:break
        }
    }*/
    
    
}

