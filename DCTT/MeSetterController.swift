//
//  MeSetterController.swift
//  DCTT
//
//  Created by wyg on 2018/4/15.
//  Copyright © 2018年 Light.W. All rights reserved.
//

import UIKit

class MeSetterController: MeBaseTableViewController , ShowAlertControllerAble {

    @IBOutlet weak var apnsStatus: UILabel!
    @IBOutlet weak var cacheSize: UILabel!
    @IBOutlet weak var appVersion: UILabel!
    
    
    @IBAction func pushSwitch(_ sender: UISwitch) {
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (indexPath.section,indexPath.row) {
        case (1,0)://清除缓存
            
            break
        case (1,1)://appstore
            
            break
            
        case (1,2):
            let vc = BaseWebViewController(baseUrl:aboutus_url)
            vc.title = "关于"
            self.navigationController?.pushViewController(vc, animated: true)
            break
            
        default: break
        }
        if indexPath.section == 2 {
            showMsg("退出登录会清除当前用户信息", title: "退出", handler: { [unowned self] in
                self._logout()
            })
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
