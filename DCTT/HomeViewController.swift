//
//  HomeViewController.swift
//  DCTT
//
//  Created by wyg on 2017/11/11.
//  Copyright © 2017年 Light.W. All rights reserved.
//

import UIKit

class HomeViewController: BaseViewController ,TTPageViewControllerDelegate,TTHeadTitleDelegate{
    var vcArr = [BaseTableViewController]()
    var pagevc :TTPageViewController!
    var topview : TTHeadTitleView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false;

        _init()
    }

    func _init() {
        //head
        let titles = ["关注","推荐","热点","科技","视频","段子","问答","社会","国际"]
        topview  = TTHeadTitleView (frame: CGRect (x: 0, y: 0, width: kCurrentScreenWidth, height: 40), titles: titles, delegate: self)
        view.addSubview(topview)
        
        ////pagevc
        let _h = kCurrentScreenHeight - 64 - 49 - 40
        for _ in 0..<titles.count {
            let v = BaseTableViewController();
            v.view.frame =  CGRect (x: 0, y: 0, width: kCurrentScreenWidth, height: _h)
            vcArr.append(v)
        }
        
        let rec = CGRect (x: 0, y: 40, width: kCurrentScreenWidth, height: _h)
        pagevc = TTPageViewController(controllers:vcArr, frame: rec, delegate:self)
        self.addChildViewController(pagevc)
        view.addSubview(pagevc.view)
    }
    
    
    //MARK: -
    func titleClickedAtIndex(_ index: Int) {
        pagevc.scrollToPageAtIndex(index)
    }
    
    func pageViewControllerScrollTo(_ index: Int) {
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
