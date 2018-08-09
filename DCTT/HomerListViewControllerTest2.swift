//
//  HomerListViewControllerTest2.swift
//  DCTT
//
//  Created by wyg on 2018/8/9.
//  Copyright © 2018年 Light.W. All rights reserved.
//

import UIKit

class HomerListViewControllerTest2: HomerListViewController {
    var canScroll:Bool = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(noti(_ :)), name: NSNotification.Name (rawValue: "childCanScrollNotification"), object: nil)
    }
    
    func noti(_ noti:NSNotification) {
        canScroll = true
        print("child can")
    }
    
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !canScroll {
            scrollView.contentOffset = CGPoint.zero
        }
        
        if scrollView.contentOffset.y <= 0 {
            if canScroll {
                canScroll = false
                NotificationCenter.default.post(name: NSNotification.Name (rawValue: "superCanScrollNotification"), object: nil)
                
            }
        }
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
