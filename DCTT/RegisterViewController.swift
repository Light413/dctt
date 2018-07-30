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
        let d = ["phone_number":"18016373661",
                 "pwd":"123012",
                 ]
        
        AlamofireHelper.post(url: register_url, parameters: d, successHandler: { (res) in
            print(res)
        }) { (error) in
            print(error?.localizedDescription);
        }
        
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
