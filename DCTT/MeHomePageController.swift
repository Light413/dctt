//
//  MeHomePageController.swift
//  DCTT
//
//  Created by wyg on 2018/3/17.
//  Copyright © 2018年 Light.W. All rights reserved.
//

import UIKit
let _kTableViewHeaderHeight : CGFloat = 220//350
let _kTableViewMeInfoHeight:CGFloat = 170

import SwiftTTPageController

enum HomePageType:Int {
    case me
    case other
}

class MeHomePageController: MeBaseTableViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    var type:HomePageType = .me
    var uid:String!
    var imgv:UIImageView!
    let sectionHeight:CGFloat = 35
    var canScroll:Bool = true

    //////////
    var _cellPageController:TTPageViewController!
    var _cellSectionHeadView:TTHeadView!
    let sectionHeadTitles = ["动态"]
    var _meInfoView:MeHomeHeadView!
    
    var viewM:MeHomeViewM!
    private var kuserName:String = ""
    
    //MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        _initSubview()
        
        loadProfile()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
    }
    
    func _initSubview()  {
        let bg = UIView (frame: CGRect (x: 0, y: 0, width: tableView.frame.width, height: _kTableViewHeaderHeight ))
        imgv = UIImageView (frame: CGRect (x: 0, y: 0, width: tableView.frame.width, height: 0))
        imgv.image = UIImage (named: "back_bg@2x")
        imgv.contentMode = .scaleToFill
        bg.addSubview(imgv)

        /////meinfo
        let meinfo = Bundle.main.loadNibNamed("MeHomeHeadView", owner: nil, options: nil)?.first as! MeHomeHeadView
        meinfo.frame = CGRect  (x: 0, y:_kTableViewHeaderHeight - _kTableViewMeInfoHeight, width: bg.frame.width, height: _kTableViewMeInfoHeight)
        meinfo.backgroundColor = tt_defafault_barColor //UIColor.white
        bg.addSubview(meinfo)
        _meInfoView = meinfo;
        
        viewM = MeHomeViewM.init(self)
        viewM.user_id = uid
        viewM.isFromHomePage = true
        viewM.noDataTipMsg = "还没有发布过动态"
        
        viewM._scrollViewDidScroll = { [weak self] scrollView in
            guard let ss = self else {return}
            let _y = scrollView.contentOffset.y + 0
            if _y <= 0 {
                ss.title = "";
            }else{
                ss.title = ss.kuserName
            }
        }
        
        tableView = viewM.tableview
        
        tableView.separatorStyle = .none
        tableView.tableHeaderView = bg
        tableView.tableFooterView = UIView()
        bg.backgroundColor = UIColor.clear
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateProfile(_ :)), name: NSNotification.Name.init("updateProfileNotification"), object: nil)
        
    }
    
    @objc func updateProfile(_ noti:Notification) {
        if let d = noti.userInfo as? [String:Any] {
            _meInfoView.fill(d)
            _meInfoView.avatarClickerAction = {[weak self] in
                guard let ss = self else {return}
                guard let avatar_url = d["avatar"] as? String else {return}
                
                let vc  = TTImagePreviewController2()
                vc.index = 0
                vc.dataArry = [avatar_url]
                
                ss.navigationController?.present(vc, animated: false, completion: nil)
            }
            
            let name = String.isNullOrEmpty(d["name"]);
            if name.lengthOfBytes(using: String.Encoding.utf8) > 0  {
                kuserName = name
            }else{
                kuserName = String.isNullOrEmpty(d["nickName"])
            }
            
        }
    }
    
    func noti(_ noti:NSNotification) {
        canScroll = true
        kchildViewCanScroll = false
        //print("super can")
    }

    //MARK: -
    let _offset_y:CGFloat = 55 - 64
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let _y = scrollView.contentOffset.y + 0
        if _y <= 0 {
            title = "";
        }else{
            title = kuserName
        }
        
    }
    
    func loadProfile() {
        guard let u = uid else {return}
        let d:[String:Any] = ["uid":u, "type":3]
        
        AlamofireHelper.post(url: update_profile_url, parameters: d, successHandler: { [weak self](res) in
            guard String.isNullOrEmpty(res["status"]) == "200" else { return;}
            guard let user = res["body"] as? [String:Any] else {return}
            //guard let ss = self else {return}
            //let uid = String.isNullOrEmpty(user["user_id"])
            //            ss.vm(uid)
            
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: NSNotification.Name.init("updateProfileNotification"), object: nil, userInfo: user)
            }
        }) { [weak self] (err) in
            HUD.showText("加载用户资料失败")
            guard let ss = self else {return}
            ss.loadProfile()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        //_cellPageController.removeFromParentViewController()
        //print(self.description)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}

// MARK: - Table view data source
class MeInfoTableView: UITableView ,UIGestureRecognizerDelegate{
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        /*
         <UIScreenEdgePanGestureRecognizer: 0x15f5afdc0; state = Began; delaysTouchesBegan = YES; view = <UILayoutContainerView 0x15f5ac7e0>; target= <(action=panGestureRec:, target=<DCTT.BaseNavigationController 0x15f893a00>)>>
         */
        //判断手势是否是NavigationController的侧滑返回手势
        if otherGestureRecognizer.isMember(of: UIScreenEdgePanGestureRecognizer.self) {
            return false
        }
        
        //判断是否UICollectionView侧滑手势
        if (otherGestureRecognizer.view?.isMember(of: UICollectionView.self))!{
            return false
        }
        
        return true
    }
    
    
}



