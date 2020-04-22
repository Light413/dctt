//
//  LoginViewController.swift
//  DCTT
//
//  Created by wyg on 2018/3/10.
//  Copyright © 2018年 Light.W. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class LoginViewController: UITableViewController{
    @IBOutlet weak var phoneNumber: UITextField!
    
    @IBOutlet weak var pwd: UITextField!
    
    @IBOutlet weak var loginBtn: UIButton!
    
    
    let disposeBag = DisposeBag.init();

    override func viewDidLoad() {
        super.viewDidLoad()
        
        HUD.dismiss();
        
        let _topBg = UIView .init(frame: CGRect (x: 0, y: 0, width: kCurrentScreenWidth, height: 64))
        
        let backbtn = UIButton (frame: CGRect (x: 15, y: 20, width: 30, height: 30))
        backbtn.setImage(UIImage (named: "leftbackicon_sdk_login"), for: .normal)
        backbtn.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: -10, bottom: 0, right: 10)
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
        
        
        let _phone =  phoneNumber.rx.text.orEmpty.map{($0.lengthOfBytes(using: String.Encoding.utf8)) > 0}.shareReplay(1)
        let _pwd =  pwd.rx.text.orEmpty.map{($0.lengthOfBytes(using: String.Encoding.utf8)) > 0}.shareReplay(1)
        
        Observable.combineLatest(_phone, _pwd) { $0 && $1}.subscribe {[weak self] (e) in
            guard let  ss = self else {return}
            if let b = e.element {
                ss.loginBtn.isEnabled = b
                ss.loginBtn.backgroundColor = b ?  UIColorFromHex(rgbValue: 0xC70F2B) : kTableviewBackgroundColor
            }
            }.addDisposableTo(disposeBag)

        
        
    }

    @objc func dimissKeyboar(_ gesture:UITapGestureRecognizer)  {
        phoneNumber.resignFirstResponder()
        pwd.resignFirstResponder()
    }
    
    
    @IBAction func buttonAction(_ sender: UIButton) {
        switch sender.tag {
        case 1://login
            HUD.show(withStatus: "登录中")
            let d = ["phone_number":String.isNullOrEmpty(phoneNumber.text),
                     "pwd":String.isNullOrEmpty(pwd.text),
                     ]
            
            AlamofireRequest(login_url, parameter: d) {[weak self] (res) in
                if let d = res["body"] as? [String:Any] {
                    do {
                        let data =  try JSONSerialization.data(withJSONObject: d, options: [])
                        
                        UserDefaults.standard.setValue(data, forKey: "userinfo");
                        UserDefaults.standard.synchronize();

                    }catch {
                        print(error.localizedDescription)
                    }
                }
                
                
                HUD.show(successInfo: "登录成功")
                NotificationCenter.default.post(Notification.init(name: userLoginedSuccessNotification))
                
                guard let ss = self else {return}
                ss.dismiss(animated: true, completion: nil)
            }
            
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
    
    
    @objc func navigationBackButtonAction() {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "findpassword" {
                let vc = segue.destination as! RegisterViewController
                vc.isRegisterAction = false
            }
        }
    }
}


extension LoginViewController:UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}





