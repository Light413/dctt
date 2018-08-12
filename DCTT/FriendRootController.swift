//
//  FriendRootController.swift
//  DCTT
//
//  Created by wyg on 2018/8/12.
//  Copyright © 2018年 Light.W. All rights reserved.
//

import UIKit

class FriendRootController: BaseViewController {
    //////////
    var _cellPageController:TTPageViewController!
    var _cellSectionHeadView:TTHeadTitleView!
    let sectionHeadTitles = ["最新","最热"]

    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false;
        
        // Do any additional setup after loading the view.
        navigationItem.titleView = title_v()
        
       _cellPageController = addCellPageController()
    }

    func title_v() -> UIView {
        var attri = TTHeadTextAttribute()
        attri.itemWidth = 50
        let topview  = TTHeadTitleView (frame: CGRect (x: 0, y: 0, width: 100, height: 35), titles: sectionHeadTitles, delegate: self ,textAttributes:attri)
        _cellSectionHeadView = topview
        
        return topview
    }
    
    
    
    func addCellPageController() -> TTPageViewController {
        ////pagevc
        var vcArr = [UIViewController]()
        
        for _ in 0..<sectionHeadTitles.count {
            let v = FriendsViewController();
            
            vcArr.append(v)
        }
        
        let rec = CGRect (x: 0, y: 0, width: kCurrentScreenWidth, height:kCurrentScreenHeight - 49 )
        let pagevc = TTPageViewController(controllers:vcArr, frame: rec, delegate:self)
        
        view.backgroundColor = UIColor.red
        
        self.addChildViewController(pagevc)
        self.view.addSubview(pagevc.view)
        
        return pagevc
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

extension FriendRootController:TTHeadTitleDelegate,TTPageViewControllerDelegate {
    func titleClickedAtIndex(_ index: Int) {
        _cellPageController.scrollToPageAtIndex(index)
    }
    
    func pageViewControllerScrollTo(_ index: Int) {
        _cellSectionHeadView.scrollToItemAtIndex(index)
    }
    
}

