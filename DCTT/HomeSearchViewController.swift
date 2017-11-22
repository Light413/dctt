//
//  HomeSearchViewController.swift
//  DCTT
//
//  Created by gener on 17/11/22.
//  Copyright © 2017年 Light.W. All rights reserved.
//

import UIKit

class HomeSearchViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = kTableviewBackgroundColor
        
        //hidesBottomBarWhenPushed = true
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setToolbarHidden(true, animated: animated)
        super.viewWillAppear(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillDisappear(animated)
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
