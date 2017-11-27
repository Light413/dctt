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

        let _v = UIView .init(frame: CGRect (x: 0, y: 0, width: kCurrentScreenWidth, height: 64))
        _v.backgroundColor = UIColor.white
        //view.addSubview(_v)
        
    }
    

    /*override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        
    }*/

    
    
    
    
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
