//
//  AboutUsViewController.swift
//  DCTT
//
//  Created by gener on 2018/9/7.
//  Copyright © 2018年 Light.W. All rights reserved.
//

import UIKit

class AboutUsViewController: MeBaseTableViewController {
    @IBOutlet weak var appversion: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let info = Bundle.main.infoDictionary {
            appversion.text = "郸城头条" + String.isNullOrEmpty(info["CFBundleShortVersionString"]) + "(\(String.isNullOrEmpty(info["CFBundleVersion"])))"
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var vc:BaseWebViewController!
        
        switch (indexPath.section,indexPath.row) {
        case (1,0):
            vc = BaseWebViewController(baseUrl:aboutus_url)
            vc.title = "简介"
            break
        case (1,1):
            vc = BaseWebViewController(baseUrl:usehelp_url)
            vc.title = "使用帮助"
            break
        case (1,2):
            vc = BaseWebViewController(baseUrl:user_agreement_url)
            vc.title = "用户协议"
            break
        case (1,3):
            vc = BaseWebViewController(baseUrl:privacy_agreement_url)
            vc.title = "隐私政策"

            break
        case (1,4):
            vc = BaseWebViewController(baseUrl:disclaimer_url)
            vc.title = "免责声明"
            break
            
        case (1,5):
            vc = BaseWebViewController(baseUrl:contactus_url)
            vc.title = "联系我们"
            break

        default:return
        }
        
       self.navigationController?.pushViewController(vc, animated: true)
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
