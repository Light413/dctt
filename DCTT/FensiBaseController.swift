//
//  FensiBaseController.swift
//  DCTT
//
//  Created by wyg on 2018/4/11.
//  Copyright © 2018年 Light.W. All rights reserved.
//

import UIKit
import SwiftTTPageController

class FensiBaseController: UIViewController,TTPageViewControllerDelegate,TTHeadViewDelegate {
    var t_barTintColor:UIColor?;
    
    var vcArr = [UIViewController]()
    var pagevc :TTPageViewController!
    var topview : TTHeadView!
    
    var _tableView:UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        _initSubviews()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (self.navigationController?.navigationBar.isHidden)! {
            self.navigationController?.setNavigationBarHidden(false, animated: animated)
        }
        
    }
    
    func _initSubviews()  {
        
        let titles = ["关注","粉丝"]
        topview  = TTHeadView (frame: CGRect (x: 0, y: 0, width: 100, height: 40), titles: titles, delegate: self)
        //view.addSubview(topview)
        topview.backgroundColor = UIColor.white

        navigationItem.titleView = topview
        
        ////pagevc
        for i in 0..<titles.count {
            let v = GuanzhuController(i);
            vcArr.append(v)
        }
        
        let rec = CGRect (x: 0, y: 0, width: kCurrentScreenWidth, height: kCurrentScreenHeight - 0)
        pagevc = TTPageViewController(controllers:vcArr, frame: rec, delegate:self)
        
        self.addChild(pagevc)
        view.addSubview(pagevc.view)
    }
    

    
    //MARK: -
    func tt_headViewSelectedAt(_ index: Int) {
        pagevc.scrollToPageAtIndex(index)
    }
    
    func tt_pageControllerSelectedAt(_ index: Int) {
        topview.scrollToItemAtIndex(index);
    }
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
