//
//  LoginViewController.swift
//  DCTT
//
//  Created by wyg on 2018/3/10.
//  Copyright © 2018年 Light.W. All rights reserved.
//

import UIKit

class LoginViewController: UITableViewController {
    @IBOutlet weak var phoneNumber: UITextField!
    
    @IBOutlet weak var pwd: UITextField!
    
    @IBOutlet weak var loginBtn: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        HUD.dismiss();
        
        let _topBg = UIView .init(frame: CGRect (x: 0, y: 0, width: kCurrentScreenWidth, height: 64))
        
        let backbtn = UIButton (frame: CGRect (x: 15, y: 20, width: 30, height: 30))
        backbtn.setImage(UIImage (named: "leftbackicon_sdk_login"), for: .normal)
        backbtn.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 10)
        _topBg.addSubview(backbtn)
        backbtn.addTarget(self, action: #selector(navigationBackButtonAction), for: .touchUpInside)
        
        let leftItme = UIBarButtonItem (customView: backbtn)
        navigationItem.leftBarButtonItem = leftItme
        tableView.tableFooterView = UIView()
        
        //self.navigationController?.navigationBar.isTranslucent = true
        //self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(getImage(), for: .default)
        self.title = "手机号登陆"
        
        view.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(dimissKeyboar(_ :))))
        
    }

    func dimissKeyboar(_ gesture:UITapGestureRecognizer)  {
        phoneNumber.resignFirstResponder()
        pwd.resignFirstResponder()
    }
    
    
    @IBAction func buttonAction(_ sender: UIButton) {
        switch sender.tag {
        case 1://login
            
            break
        case 2://register
            
            break
        case 3://forgor pwd
            
            break

        default:
            break
        }
        
        
    }
    
    
    
    
    
    func getImage() -> UIImage?  {
       let rect = CGRect (x: 0, y: 0, width: 5, height: 5)
        
        UIGraphicsBeginImageContext(rect.size)
        
       let ctx =  UIGraphicsGetCurrentContext()
        
        ctx?.setFillColor(UIColor.white.cgColor)
        ctx?.fill(rect)
        
        let ig = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return ig
        
        
    }
    
    
    func navigationBackButtonAction() {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source


}


extension LoginViewController:UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}





