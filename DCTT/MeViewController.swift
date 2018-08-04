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
    
    let _titleArr = ["我的动态","消息通知",/*"关注",*/"收藏","粉丝关注",/*"意见反馈",*/"设置"]
    let _imgArr = ["uc_account",
                   "uc_message",
                   /*"uc_danzi",*/
                "uc_shouc",
                "uc_app",
                //"uc_add",
                "uc_system"]

    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationController?.navigationBar.shadowImage = UIImage()

        _init()

        _topBgView = topView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(loginSuccessNoti(_ :)), name: userLoginedSuccessNotification, object: nil)
    }

    func loginSuccessNoti(_ noti:Notification) {
        user_has_logined = User.isLogined()
        
        print("name: \(User.name()) , token: \(User.token()) , uid: \(User.uid())")
        _tableView.reloadData()

    }
    
    
    
    
    func topView() -> UIView {
        let _l = UILabel .init(frame: CGRect (x: 0, y: 20, width: kCurrentScreenWidth, height: 44))
        _l.text = "正儿八经的程序员GG"
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
        _tableView.sectionFooterHeight = 10
        _tableView.tableHeaderView = UIView (frame: CGRect (x: 0, y: 0, width: 0, height: CGFloat.leastNormalMagnitude))
        view.addSubview(_tableView)
        _tableView.separatorColor = UIColor (red: 232/255.0, green: 232/255.0, blue: 232/255.0, alpha: 1)
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 10, 0)
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
        
        _topBgView.alpha = _y > 64 ? 1 : 0
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
        case 0:return user_has_logined ? 180 : 150
            default:return 70
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell!
        
        if indexPath.section == 0 {
            let identifier =  user_has_logined ? "MePersonInfoCellReuseIdentifier":"MeNotRegisterCellIdentifier"
            cell = tableView.dequeueReusableCell(withIdentifier: identifier , for: indexPath)
            
            if user_has_logined {
                (cell as! MePersonInfoCell).fill();
            }
            
            
            if true {
                return cell;
            }
            
            
        }else{
            cell = tableView.dequeueReusableCell(withIdentifier: "MeViewControllerCellIdentifier")
            if cell == nil {
                cell = UITableViewCell.init(style: .value1, reuseIdentifier: "MeViewControllerCellIdentifier")
                cell.textLabel?.font = UIFont.systemFont(ofSize: 16)
                cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 15)
            }
            cell.textLabel?.text = _titleArr[indexPath.row]
            cell.imageView?.image = UIImage (named: _imgArr[indexPath.row])
            
            
        }
        
        //cell.detailTextLabel?.text = indexPath.row < 4 ? "0":""
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
            var vc:UIViewController!
            
            switch indexPath.row {
            case 0:
                vc = MeHomePageController.init(style:.grouped)
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

            case 4://意见反馈
                vc =  UIStoryboard (name: "me", bundle: nil).instantiateViewController(withIdentifier: "me_setter_sbid");
                
                //vc = FackBackViewController();
                break
//
            default:break
            }
        
            self.navigationController?.pushViewController(vc, animated: true);
            
        }
        
        
        
//        if indexPath.row == 0{
//            TTDatePickerView.show { (age) in
//                print(age)
//            }
//
//        } else if indexPath.row == 1{
//        TTDataPickerView.show({ (str) in
//            print(str)
//        })
//
//
//        }
        
        


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
