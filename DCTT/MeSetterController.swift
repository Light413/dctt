//
//  MeSetterController.swift
//  DCTT
//
//  Created by wyg on 2018/4/15.
//  Copyright © 2018年 Light.W. All rights reserved.
//

import UIKit
import Kingfisher

class MeSetterController: MeBaseTableViewController , ShowAlertControllerAble {

    @IBOutlet weak var apnsStatus: UILabel!
    @IBOutlet weak var cacheSize: UILabel!
    @IBOutlet weak var appVersion: UILabel!
    
    @IBOutlet weak var sw: UISwitch!
    
    @IBAction func pushSwitch(_ sender: UISwitch) {
        guard let url = URL.init(string: UIApplication.openSettingsURLString) else {return}
        guard UIApplication.shared.canOpenURL(url) else {return}
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:]) {[weak self] (res) in
                guard let ss = self else {return}
                ss._displayNotificationStatus(res)
            }
        } else {
            // Fallback on earlier versions
           UIApplication.shared.openURL(url)
        }
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(setter_notification(_ :)), name: NSNotification.Name.init("setter_notification_status"), object: nil)
        
        let settings = UIApplication.shared.currentUserNotificationSettings
        let open = Int((settings?.types)!.rawValue) != 0
        _displayNotificationStatus(open);
        
        ImageCache.default.calculateDiskCacheSize { size in
            let cache = Double.init(size) / 1024.0 / 1024.0
            let s = size == 0 ? "0" : NSString.init(format: "%.2f", cache)
            self.cacheSize.text = "\(s)MB"
        }

        
    }

    @objc func setter_notification(_ noti:Notification)  {
        if let u  = noti.userInfo!["is"] as? Bool {
            _displayNotificationStatus(u)
        }
    }
    
    
    ///显示通知开关状态
    func _displayNotificationStatus(_ b:Bool) {
        apnsStatus.text = b ? "已开启" :"已关闭"
        sw.isOn = b
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        if User.isLogined() {
            return 3
        }
        
        return 2
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (indexPath.section,indexPath.row) {
        case (0,0):
            guard User.isLogined() else {
                HUD.showText(kPleaseToLogin, view: UIApplication.shared.keyWindow!)
                return
            }

            self.performSegue(withIdentifier: "showProfileSegueId", sender: nil)
            break
        case (0,1):
            guard User.isLogined() else {
                HUD.showText(kPleaseToLogin, view: UIApplication.shared.keyWindow!)
                return
            }
            
            self.performSegue(withIdentifier: "showBlackListSegueId", sender: nil)
            break
        case (1,0)://清除缓存
            showMsg("清除图片及缓存数据", title: "确定", handler: { [unowned self] in
                HUD.show(withStatus: "清除缓存")
                ImageCache.default.clearDiskCache(completion: {
                    HUD.show(successInfo: "清除完成")
                    self.cacheSize.text = "0MB"
                })
            })
            
            break
        case (1,1)://意见反馈
            guard User.isLogined() else {
                HUD.showText(kPleaseToLogin, view: UIApplication.shared.keyWindow!)
                return
            }

            ///https://support.qq.com/product/41118
            let vc =  UIStoryboard (name: "me", bundle: nil).instantiateViewController(withIdentifier: "feedback_id");
            
                //BaseWebViewController(baseUrl:"https://support.qq.com/product/41118",isFullUrl:true)
            
            vc.title = "意见反馈"
            self.navigationController?.pushViewController(vc, animated: true)
            break
            
        case (1,2)://appstore
            //给我评分 ////qq-444934666  dyt-1093404718
            let str = "itms-apps://itunes.apple.com/app/id\(1440109512)";
            UIApplication.shared.openURL(URL.init(string: str)!)
            break

        case (2,_):
            showMsg("\n此操作会清除用户相关信息,确定退出？", title: "确定", handler: { [unowned self] in
                self._logout()
            })

            break
            
        case (3,_): break
        default: break
        }
        if indexPath.section == 2 {
        }
        
        
    }

    
    
    
    func _logout(){
        UserDefaults.standard.setValue(nil, forKey: "userinfo")
        UserDefaults.standard.synchronize()
        HUD.showText("已退出登录", view: self.view)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {[weak self] in
            NotificationCenter.default.post(name: updateUserInfoNotification, object: nil)
            
            guard let ss = self else {return}
            user_has_logined = false
            
            
            ss.navigationController?.popViewController(animated: true)
            })
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
