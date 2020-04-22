//
//  HomerListViewControllerTest2.swift
//  DCTT
//
//  Created by wyg on 2018/8/9.
//  Copyright © 2018年 Light.W. All rights reserved.
//

import UIKit

class MeHomeListController: UITableViewController  , ShowAlertControllerAble {
    var uid:String!
    
    private var canScroll:Bool = false;
    private var dataArray = [[String:Any]]()
    var viewM:MeHomeViewM!//必须定义为全局变量
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib (nibName: "MeHomeCell", bundle: nil), forCellReuseIdentifier: "MeHomeCellIdentifier")
        tableView.estimatedRowHeight = 80;
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView();
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        
        NotificationCenter.default.addObserver(self, selector: #selector(noti(_ :)), name: NSNotification.Name (rawValue: "childCanScrollNotification"), object: nil)

        loadProfile()
    }
    
    func loadProfile() {
        guard let u = uid else {return}
        let d:[String:Any] = ["uid":u, "type":3]
        
        AlamofireHelper.post(url: update_profile_url, parameters: d, successHandler: { [weak self](res) in
            guard String.isNullOrEmpty(res["status"]) == "200" else { return;}
            guard let user = res["body"] as? [String:Any] else {return}
            guard let ss = self else {return}
            let uid = String.isNullOrEmpty(user["user_id"])
            ss.vm(uid)
            
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: NSNotification.Name.init("updateProfileNotification"), object: nil, userInfo: user)
            }
        }) { [weak self] (err) in
            guard let ss = self else {return}
            ss.showMsg("加载用户资料失败,请点击重试", title: "重试", handler: {
                ss.loadProfile()
            })
        }
    }
    
    func vm(_ uid:String) {
        viewM = MeHomeViewM.init(self)
        viewM.isFromHomePage = true
        viewM.noDataTipMsg = "还没有发布过动态"
        viewM._scrollViewDidScroll = { [weak self] scrollView in
            guard let ss = self else {return}
            if !ss.canScroll && kchildViewCanScroll == false {
                scrollView.contentOffset = CGPoint.zero
            }
            
            if scrollView.contentOffset.y <= 0 {
                if ss.canScroll || kchildViewCanScroll {
                    ss.canScroll = false
                    NotificationCenter.default.post(name: NSNotification.Name (rawValue: "superCanScrollNotification"), object: nil)
                }
            }
        }
        
        viewM.user_id = uid
        tableView = viewM.tableview
    }
    
    
    //MARK:- 控制滑动
    @objc func noti(_ noti:NSNotification) {
        canScroll = true
        //print("child can")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !canScroll && kchildViewCanScroll == false {
            scrollView.contentOffset = CGPoint.zero
        }
        
        if scrollView.contentOffset.y <= 0 {
            if canScroll || kchildViewCanScroll {
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
