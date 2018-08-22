//
//  MeSetterController.swift
//  DCTT
//
//  Created by wyg on 2018/4/15.
//  Copyright © 2018年 Light.W. All rights reserved.
//

import UIKit

class MeSetterController: MeBaseTableViewController {

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
        if indexPath.section == 2 {
            
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
