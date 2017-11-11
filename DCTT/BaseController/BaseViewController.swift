//
//  BaseViewController.swift
//  Toolbox
//
//  Created by gener on 17/6/26.
//  Copyright © 2017年 Light. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let settingItem  = UIBarButtonItem (image: UIImage (named: "gear_(settings)_icon"), style: .plain, target: self, action: #selector(rightItemButtonAction(_:)))
        let fiexditem = UIBarButtonItem.init(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        fiexditem.width = 20
        
        navigationItem.rightBarButtonItems = [fiexditem,settingItem]
    }

    
    func rightItemButtonAction(_ button:UIBarButtonItem)
    {
        /*let rect = CGRect (x: 0, y: 0, width: 480, height: 320)
        let vc :SetterViewController = SetterViewController.init(nibName: "SetterViewController", bundle: nil)
        
        let nav:BaseNavigationController = BaseNavigationController(rootViewController:vc)
        nav.navigationBar.barTintColor = UIColor.white
        nav.navigationBar.tintColor = UIColor.black
        
        nav.view.frame = rect
        nav.modalPresentationStyle = .popover
        nav.popoverPresentationController?.barButtonItem = button
        
        nav.preferredContentSize = rect.size

        self.present(nav, animated: true, completion: nil)
*/
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
