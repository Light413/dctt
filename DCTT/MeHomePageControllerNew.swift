//
//  MeHomePageControllerNew.swift
//  DCTT
//
//  Created by wyg on 2019/2/18.
//  Copyright © 2019年 Light.W. All rights reserved.
//  deprecated

import UIKit

class MeHomePageControllerNew: MeBaseTableViewController {

    var viewM:MeHomeViewM!
    var _meInfoView:MeHomeHeadView!
    private var kuserName:String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _initSubviews()
        
        loadProfile()
    }
    
    func _initSubviews() {
        let bg = UIView (frame: CGRect (x: 0, y: 0, width: tableView.frame.width, height: _kTableViewHeaderHeight ))
//        imgv = UIImageView (frame: CGRect (x: 0, y: 0, width: tableView.frame.width, height: 0))
//        imgv.image = UIImage (named: "back_bg@2x")
//        imgv.contentMode = .scaleToFill
//        bg.addSubview(imgv)
        
        /////meinfo
        let meinfo = Bundle.main.loadNibNamed("MeHomeHeadView", owner: nil, options: nil)?.first as! MeHomeHeadView
        meinfo.frame = CGRect  (x: 0, y:_kTableViewHeaderHeight - _kTableViewMeInfoHeight, width: bg.frame.width, height: _kTableViewMeInfoHeight)
        meinfo.backgroundColor = tt_defafault_barColor //UIColor.white
        bg.addSubview(meinfo)
        _meInfoView = meinfo;
        
        viewM = MeHomeViewM.init(self)
        viewM.user_id = User.uid()
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

    func loadProfile() {
        guard let u = User.uid() else {return}
        let d:[String:Any] = ["uid":u, "type":3]
        
        AlamofireHelper.post(url: update_profile_url, parameters: d, successHandler: { [weak self](res) in
            guard String.isNullOrEmpty(res["status"]) == "200" else { return;}
            guard let user = res["body"] as? [String:Any] else {return}
//            guard let ss = self else {return}
//            let uid = String.isNullOrEmpty(user["user_id"])
//            ss.vm(uid)
            
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: NSNotification.Name.init("updateProfileNotification"), object: nil, userInfo: user)
            }
        }) { [weak self] (err) in
            guard let ss = self else {return}
//            ss.showMsg("加载用户资料失败,请点击重试", title: "重试", handler: {
                ss.loadProfile()
//            })
        }
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
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

  
}
