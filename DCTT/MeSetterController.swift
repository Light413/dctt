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
    
    
    @IBAction func pushSwitch(_ sender: UISwitch) {
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ImageCache.default.calculateDiskCacheSize { size in
            let cache = Double.init(size) / 1024.0 / 1024.0
            let s = size == 0 ? "0" : NSString.init(format: "%.2f", cache)
            self.cacheSize.text = "\(s)MB"
            
            print("Used disk size by bytes: \(size)")
        }

    }

    deinit {
        print(self.description)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        if User.isLogined() {
            return 4
        }
        
        return 2
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (indexPath.section,indexPath.row) {
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
            
            break
            
        case (1,2)://appstore

            break
        case (1,3)://分享好友
            
            break
        case (2,_):
            showMsg("退出会清除用户登录信息", title: "确定退出", handler: { [unowned self] in
                self._logout()
            })

            break
            
        case (3,_):
            showMsg("注销会清除用户信息及发布内容", title: "确定注销", handler: { [unowned self] in
                
            })

            break
            
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
