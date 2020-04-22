//
//  FriendRootController.swift
//  DCTT
//
//  Created by wyg on 2018/8/12.
//  Copyright © 2018年 Light.W. All rights reserved.
//

import UIKit
import SwiftTTPageController

class FriendRootController: BaseViewController {
    //////////
    var _cellPageController:TTPageViewController!
    var _cellSectionHeadView:TTHeadView!
    let sectionHeadTitles = ["最新","热门"]

    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false;
        
        // Do any additional setup after loading the view.
        navigationItem.titleView = title_v()
        
       _cellPageController = addCellPageController()
        
        ///
        let item = getBarButtonItem(title: "创建", action: #selector(publishZtAction))
        self.navigationItem.rightBarButtonItem = item
    }

    func rightNavigationItem() -> UIBarButtonItem{
        let rightbtn = UIButton (frame: CGRect (x: 0, y: 0, width: 40, height: 30))
        rightbtn.setTitle("发布话题", for: .normal)
        rightbtn.setTitleColor(tt_BarColor , for: .normal)
        rightbtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        rightbtn.addTarget(self, action: #selector(publishZtAction), for: .touchUpInside)
        let rightitem = UIBarButtonItem.init(customView: rightbtn)
        
        return rightitem
    }
    
    func title_v() -> UIView {
        var attri = TTHeadTextAttribute()
        attri.itemWidth = 50
        attri.defaultFontSize = 17
        attri.selectedFontSize = 17

        let topview  = TTHeadView (frame: CGRect (x: 0, y: 0, width: 100, height: 35), titles: sectionHeadTitles, delegate: self ,textAttributes:attri)
        _cellSectionHeadView = topview
        
        return topview
    }
    
    
    
    func addCellPageController() -> TTPageViewController {
        ////pagevc
        var vcArr = [UIViewController]()
        
//        for _ in 0..<sectionHeadTitles.count {
//            let v = FriendsViewController();
//
//            vcArr.append(v)
//        }
        
        let v1 = ZTTableViewController("0")
        vcArr.append(v1)
        
        let v2 = ZTTableViewController("1")
        vcArr.append(v2)
        
        let rec = CGRect (x: 0, y: 0, width: kCurrentScreenWidth, height:kCurrentScreenHeight - 49 )
        let pagevc = TTPageViewController(controllers:vcArr, frame: rec, delegate:self)
        
        view.backgroundColor = UIColor.red
        
        self.addChild(pagevc)
        self.view.addSubview(pagevc.view)
        
        return pagevc
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

extension FriendRootController:TTHeadViewDelegate,TTPageViewControllerDelegate {
    func tt_headViewSelectedAt(_ index: Int) {
        _cellPageController.scrollToPageAtIndex(index)
    }
    
    func tt_pageControllerSelectedAt(_ index: Int) {
        _cellSectionHeadView.scrollToItemAtIndex(index)
    }
}

extension FriendRootController:AddButtonItemProtocol {
    @objc func publishZtAction() {
        
        guard User.isLogined() else {
            HUD.showText(kPleaseToLogin, view: UIApplication.shared.keyWindow!)
            return
        }
        
        let vc = UIStoryboard.init(name: "Publish", bundle: nil).instantiateViewController(withIdentifier: "pub_zt_id");
        let nav = BaseNavigationController (rootViewController:vc)
                UIApplication.shared.keyWindow?.rootViewController?.present(nav, animated: true, completion: nil)
    }
    
    
}
