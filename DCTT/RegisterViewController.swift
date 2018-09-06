//
//  RegisterViewController.swift
//  DCTT
//
//  Created by wyg on 2018/3/10.
//  Copyright © 2018年 Light.W. All rights reserved.
//

import UIKit

class RegisterViewController: UITableViewController {
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var code: UITextField!
    @IBOutlet weak var pwd: UITextField!
    @IBOutlet weak var getCodeBtn: UIButton!
    @IBOutlet weak var registerBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "用户注册";
        
    }

    @IBAction func buttonAction(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            
            break
            
        case 2:
            let d = ["phone_number":String.isNullOrEmpty(phone.text),
                     "pwd":String.isNullOrEmpty(pwd.text),
                     ]
            
            //
            HUD.show()
            AlamofireRequest(register_url, parameter: d , successHandler : { [weak self](res) in
                print(res)
                HUD.show(successInfo: "注册成功")
                
                guard let ss = self else {return}
                ss.navigationController?.popViewController(animated: true)
            })
            
            break
            
        case 3:
            let vc = BaseWebViewController(baseUrl:user_agreement_url)
            vc.title = "用户服务协议"
            self.navigationController?.pushViewController(vc, animated: true)
            
            break
        default:break
        }

        
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
