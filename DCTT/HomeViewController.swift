//
//  HomeViewController.swift
//  DCTT
//
//  Created by wyg on 2017/11/11.
//  Copyright © 2017年 Light.W. All rights reserved.
//

import UIKit

class HomeViewController: BaseViewController ,TTPageViewControllerDelegate,TTHeadTitleClickDelegate{
    var vcArr = [BaseTableViewController]()
    let pagevc = TTPageViewController()
    var topview : TTHeadTitleView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false;

        _init()
    }

    func _init() {
        //head
        topview = TTHeadTitleView.init(frame: CGRect (x: 0, y: 0, width: kCurrentScreenWidth, height: 40))
        topview.titles = ["关注","推荐","热点","科技","视频"]
        topview.delegate  = self
        view.addSubview(topview)
        
        ////pagevc
        let _h = kCurrentScreenHeight - 64 - 49 - 40
        for _ in 0..<5 {
            let v = BaseTableViewController();
            v.view.frame =  CGRect (x: 0, y: 0, width: kCurrentScreenWidth, height: _h)
            vcArr.append(v)
        }
        
        pagevc.viewControllers = vcArr
        pagevc.delegate = self
        pagevc.view.frame =  CGRect (x: 0, y: 40, width: kCurrentScreenWidth, height: _h)
        
        self.addChildViewController(pagevc)
        view.addSubview(pagevc.view)
    }
    
    
    //MARK: -
    func titleClickedAtIndex(_ index: Int) {
        pagevc.scrollToPageAtIndex(index)
    }
    
    func pageViewControllerScrollTo(_ index: Int) {
        topview.scrollToPageAtIndex(index);
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
