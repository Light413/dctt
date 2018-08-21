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
        topview  = TTHeadView (frame: CGRect (x: 0, y: 0, width: 130, height: 40), titles: titles, delegate: self)
        //view.addSubview(topview)
        topview.backgroundColor = UIColor.white
//        topview.textAttribute = TTHeadTextAttribute.init(defaultColor: UIColor.lightGray, defaultSize: 16, selectedColor: UIColor.black, selectedSize: 16)
        
        navigationItem.titleView = topview
        
        ////pagevc
        for _ in 0..<titles.count {
            let v = GuanzhuController();
            vcArr.append(v)
        }
        
        let rec = CGRect (x: 0, y: 0, width: kCurrentScreenWidth, height: kCurrentScreenHeight - 0)
        pagevc = TTPageViewController(controllers:vcArr, frame: rec, delegate:self)
        
        self.addChildViewController(pagevc)
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
