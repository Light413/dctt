//
//  MeViewController.swift
//  DCTT
//
//  Created by wyg on 2017/11/11.
//  Copyright © 2017年 Light.W. All rights reserved.
//

import UIKit

class MeViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {

    var _tableView:UITableView!

    var _topBgView:UIView!
    
    let _titleArr = ["我的主页",
                     "消息",
                     "收藏",
                     "粉丝关注",
                     "分享给好友",
                     //"意见反馈",
                     "设置"]
    let _imgArr = ["uc_account",
                   "uc_message",
                   /*"uc_danzi",*/
                "uc_shouc",
                "uc_app",
                "uc_zhaop",
                //"uc_feedback",
                "uc_system"]

    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationController?.navigationBar.shadowImage = UIImage()

        _init()

//        _topBgView = topView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(loginSuccessNoti(_ :)), name: userLoginedSuccessNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadUserInfo), name: updateUserInfoNotification, object: nil)
        
        loadUserInfo()
        
    }

    
    ///获取用户最新信息
    @objc func loadUserInfo()  {
        guard let uid = User.uid() else {
            _tableView.reloadData();
            _tableView.selectRow(at: IndexPath.init(row: 0, section: 0), animated: false, scrollPosition: .top); return
        }
        
        let d = ["uid":uid, "type":"3"]
        
        AlamofireHelper.post(url: update_profile_url, parameters: d, successHandler: {[weak self] (res) in
            if let d = res["body"] as? [String:Any] {
                do {
                    let data =  try JSONSerialization.data(withJSONObject: d, options: [])
                    UserDefaults.standard.setValue(data, forKey: "userinfo");
                    UserDefaults.standard.synchronize();
                }catch {
                    print(error.localizedDescription)
                }
                
                guard let ss = self else {return}
                ss._tableView.reloadData()
            }

        }) { (err) in
            
        }
    }
    
    func updateScore() {
        guard let uid = User.uid() else {
            _tableView.reloadData();  return
        }
        
        let d = ["uid":uid, "type":"1","score":5] as [String : Any]
        
        AlamofireHelper.post(url: update_profile_url, parameters: d, successHandler: {[weak self] (res) in
                HUD.showText("积分+5", view: UIApplication.shared.keyWindow!)
                guard let ss = self else {return}
                ss.loadUserInfo()
        }) { (err) in
            
        }

    }
    
    
    @objc func loginSuccessNoti(_ noti:Notification) {
        user_has_logined = User.isLogined()
        
        //print("name: \(User.name()) , token: \(User.token()) , uid: \(User.uid())")
        
        _tableView.reloadData()
        
        ///更新设备信息
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else {return}
        guard let token = delegate.myDeviceToken else {return}
        delegate.upDeviceInfo(token)
    }
    
    func topView() -> UIView {
        let _l = UILabel .init(frame: CGRect (x: 0, y: 20, width: kCurrentScreenWidth, height: 44))
        _l.text = "用户GG"
        _l.textAlignment = .center
        _l.font = UIFont.systemFont(ofSize: 17)
        
        let _topBgView = UIView .init(frame: CGRect (x: 0, y: 0, width: kCurrentScreenWidth, height: 64))
        _topBgView.backgroundColor = tt_defafault_barColor
        _topBgView.alpha = 0
        
        _topBgView.addSubview(_l)

        return _topBgView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        //view.addSubview(_topBgView)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        //_topBgView.removeFromSuperview()
    }
    
    
    func _init() {
        automaticallyAdjustsScrollViewInsets = false
        _tableView = UITableView (frame: CGRect (x: 0, y: 0, width: kCurrentScreenWidth, height: kCurrentScreenHeight - 49), style: .grouped);
        _tableView.delegate = self
        _tableView.dataSource = self
        _tableView.register(UINib (nibName: "MePersonInfoCell", bundle: nil), forCellReuseIdentifier: "MePersonInfoCellReuseIdentifier")
        _tableView.register(UINib (nibName: "MeNotRegisterCell", bundle: nil), forCellReuseIdentifier: "MeNotRegisterCellIdentifier")
        
        _tableView.sectionHeaderHeight = 0
        _tableView.sectionFooterHeight = 6
        _tableView.tableHeaderView = UIView (frame: CGRect (x: 0, y: 0, width: 0, height: CGFloat.leastNormalMagnitude))
        view.addSubview(_tableView)
        _tableView.separatorColor = UIColor (red: 232/255.0, green: 232/255.0, blue: 232/255.0, alpha: 1)
        _tableView.contentInset = UIEdgeInsets.init(top: -20, left: 0, bottom: 10, right: 0)
        _tableView.showsVerticalScrollIndicator = false
        
        //_tableView.backgroundColor = UIColor.white
        
        /*let logoutBtn = UIButton (frame: CGRect (x: 0, y: 0, width: _tableView.frame.width, height: 50))
        logoutBtn.setTitle("退出账号", for: .normal)
        logoutBtn.setTitleColor(tt_BarColor, for: .normal)
        logoutBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        logoutBtn.backgroundColor = UIColor.white
        
        _tableView.tableFooterView = logoutBtn*/
    }
    

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let _y = scrollView.contentOffset.y
        
//        _topBgView.alpha = _y > 64 ? 1 : 0
    }

    
    //MARK:  -
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            return _titleArr.count
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:return user_has_logined ? 200 : 120
            default:return 60
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell!
        
        if indexPath.section == 0 {
            let identifier =  user_has_logined ? "MePersonInfoCellReuseIdentifier":"MeNotRegisterCellIdentifier"
            cell = tableView.dequeueReusableCell(withIdentifier: identifier , for: indexPath)
            
            if user_has_logined {
                (cell as! MePersonInfoCell).fill();
                (cell as! MePersonInfoCell).cellBtnClickedAction = {[weak self] in
                    guard let ss = self else {return}
                    let vc = BaseWebViewController(baseUrl:usehelp_url)
                    vc.title = "使用帮助"
                    
                    ss.navigationController?.pushViewController(vc, animated: true)
                    
                }
            }
            
            return cell;
        }else{
            cell = tableView.dequeueReusableCell(withIdentifier: "MeViewControllerCellIdentifier")
            if cell == nil {
                cell = UITableViewCell.init(style: .value1, reuseIdentifier: "MeViewControllerCellIdentifier")
                cell.textLabel?.font = UIFont.systemFont(ofSize: 15)
                cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 15)
            }
            cell.textLabel?.text = _titleArr[indexPath.row]
            cell.imageView?.image = UIImage (named: _imgArr[indexPath.row])
            
            
        }
        
        cell.selectionStyle = .none
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if !user_has_logined {
               HUD.show()
              let vc = UIStoryboard.init(name: "Login", bundle: nil).instantiateInitialViewController()
                self.navigationController?.present(vc!, animated: true, completion: nil)
            }else{
               let vc = UIStoryboard.init(name: "me", bundle: nil).instantiateViewController(withIdentifier: "me_personInfo_id")
                self.navigationController?.pushViewController(vc, animated: true)
            }


            return
        } else if indexPath.section == 1 {
            if indexPath.row < 4 {
                guard User.isLogined() else {
                    HUD.showText(kPleaseToLogin, view: UIApplication.shared.keyWindow!)
                    return
                }
            }


            var vc:UIViewController!
            
            switch indexPath.row {
            case 0:
                vc = MeHomePageController.init(style:.plain)
                if let uid = User.uid() {
                    (vc as! MeHomePageController).uid = uid;
                }
                //vc = MeHomePageControllerNew()
                break
            case 1:
                vc = MessageViewController()
                break
            case 2:
                vc = MeCollectController()
                break
            case 3:
                vc = FensiBaseController()
                break
                
            case 4://分享
                _share2()
                //vc = HistoryViewController()
                return
            /*case 5:
                vc =  UIStoryboard (name: "me", bundle: nil).instantiateViewController(withIdentifier: "feedback_id");
                
                break*/
                
            case 5://设置
                vc =  UIStoryboard (name: "me", bundle: nil).instantiateViewController(withIdentifier: "me_setter_sbid");
                break
            default:break
            }
        
            self.navigationController?.pushViewController(vc, animated: true);
            
        }

    }
    
    let share_titles = ["朋友圈","微信好友","QQ","QQ空间"]
    
    ///分享操作
    func _share2() {
        
        TTPublishView.show({[weak self] (index) in
            guard let ss = self else {return}

            switch index {
            case 1,2:
                guard  ShareSDK.isClientInstalled(SSDKPlatformType.typeQQ) else {
                    HUD.showText("没有安装微信客户端", view: UIApplication.shared.keyWindow!)
                    return
                }
                break;
                
            case 3, 4:
                guard  ShareSDK.isClientInstalled(SSDKPlatformType.typeWechat) else {
                    HUD.showText("没有安装QQ客户端", view: UIApplication.shared.keyWindow!)
                    return
                }
                break;

            default:break;
                
            }
            
            // 1.创建分享参数
            let shareParames = NSMutableDictionary()
            shareParames.ssdkSetupShareParams(byText: "专注老家生活信息服务，关注分享家乡身边新动态，赶快告诉身边的小伙伴吧!",
                                              images : UIImage(named: "app_logo"),
                                              url : URL.init(string: "http://dancheng0394.com/a/d/downloadapk.html"),
                                              title : "咱郸城人自己的APP",
                                              type : SSDKContentType.auto)

            let platType = [SSDKPlatformType.subTypeWechatTimeline , SSDKPlatformType.subTypeWechatSession , SSDKPlatformType.subTypeQQFriend,SSDKPlatformType.subTypeQZone]
            
            //2.进行单个分享
            ShareSDK.share(platType[index - 1], parameters: shareParames) {[weak self] (state : SSDKResponseState, nil, entity : SSDKContentEntity?, error :Error?) in
    
                switch state{
                    case SSDKResponseState.success:
                        HUD.showText("分享成功", view: UIApplication.shared.keyWindow!)
                        guard let ss = self else {return}
                        
                        guard User.isLogined() else {
                            HUD.showText("感谢您的分享", view: UIApplication.shared.keyWindow!)
                            return
                        }
                        
                        ///登录添加积分
                        ss.updateScore()
                    case SSDKResponseState.fail:
                        HUD.showText("授权失败", view: UIApplication.shared.keyWindow!)
                    
                    case SSDKResponseState.cancel:
                        HUD.showText("操作取消", view: UIApplication.shared.keyWindow!);
                    default:HUD.showText("无效操作", view: UIApplication.shared.keyWindow!);
                    break
                }
    
            }

        })

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
