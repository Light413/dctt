//
//  HistoryViewController.swift
//  DCTT
//
//  Created by wyg on 2018/9/17.
//  Copyright © 2018年 Light.W. All rights reserved.
//

import UIKit

class HistoryViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false;

        let vc = HomerListViewController.init("0")
        title = "历史记录"

        vc.view.frame = CGRect (x: 0, y: 0, width: kCurrentScreenWidth, height: kCurrentScreenHeight - 0)
        
        self.addChild(vc)
        self.view.addSubview(vc.view)

    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (self.navigationController?.navigationBar.isHidden)! {
            self.navigationController?.setNavigationBarHidden(false, animated: animated)
        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
