//
//  LoginViewController.swift
//  DCTT
//
//  Created by wyg on 2018/3/10.
//  Copyright © 2018年 Light.W. All rights reserved.
//

import UIKit

class LoginViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        

        let _topBg = UIView .init(frame: CGRect (x: 0, y: 0, width: kCurrentScreenWidth, height: 64))
        
        let backbtn = UIButton (frame: CGRect (x: 15, y: 20, width: 30, height: 30))
        backbtn.setImage(UIImage (named: "leftbackicon_sdk_login"), for: .normal)
        backbtn.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 10)
        _topBg.addSubview(backbtn)
        backbtn.addTarget(self, action: #selector(navigationBackButtonAction), for: .touchUpInside)
        
        let leftItme = UIBarButtonItem (customView: backbtn)
        navigationItem.leftBarButtonItem = leftItme
        
        tableView.tableFooterView = UIView()
        
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(getImage(), for: .default)
    }

    
    func getImage() -> UIImage?  {
       let rect = CGRect (x: 0, y: 0, width: 5, height: 5)
        
        UIGraphicsBeginImageContext(rect.size)
        
       let ctx =  UIGraphicsGetCurrentContext()
        
        ctx?.setFillColor(UIColor(red: 46/255.0, green: 182/255.0, blue: 106/255.0, alpha: 0).cgColor)
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
