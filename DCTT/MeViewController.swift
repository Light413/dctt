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

    let _titleArr = ["消息通知","我的发布","我的收藏","我喜欢的","意见反馈","系统设置"]
    override func viewDidLoad() {
        super.viewDidLoad()

//        self.navigationController?.navigationBar.setBackgroundImage(image(UIColor.init(colorLiteralRed: 0.5, green: 0.5, blue: 0.5, alpha: 0)), for: .default)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        _init()
    }

    func _init() {
        automaticallyAdjustsScrollViewInsets = false
        _tableView = UITableView (frame: CGRect (x: 0, y: 0, width: kCurrentScreenWidth, height: kCurrentScreenHeight - 49), style: .grouped);
        _tableView.delegate = self
        _tableView.dataSource = self
        _tableView.register(UINib (nibName: "MePersonInfoCell", bundle: nil), forCellReuseIdentifier: "MePersonInfoCellReuseIdentifier")
        
        _tableView.sectionHeaderHeight = 0
        _tableView.sectionFooterHeight = 10
        _tableView.tableHeaderView = UIView (frame: CGRect (x: 0, y: 0, width: 0, height: CGFloat.leastNormalMagnitude))
        view.addSubview(_tableView)
        _tableView.separatorColor = UIColor (red: 232/255.0, green: 232/255.0, blue: 232/255.0, alpha: 1)
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 10, 0)
        
        let logoutBtn = UIButton (frame: CGRect (x: 0, y: 0, width: _tableView.frame.width, height: 50))
        logoutBtn.setTitle("退出账号", for: .normal)
        logoutBtn.setTitleColor(tt_BarColor, for: .normal)
        logoutBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        logoutBtn.backgroundColor = UIColor.white
        
        _tableView.tableFooterView = logoutBtn
    }
    
    /*override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }*/

    
    func image(_ color:UIColor) -> UIImage {
        let rect = CGRect (x: 0, y: 0, width: 1, height: 1)
        
        UIGraphicsBeginImageContext(rect.size)
        
        let ctx = UIGraphicsGetCurrentContext()

        ctx?.setFillColor(color.cgColor)
        
        ctx?.fill(rect)
        
        let img = UIGraphicsGetImageFromCurrentImageContext()
        
        return img!
    }
    
    //MARK: 
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
            case 0:return 200
            default:return 50
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell!
        
        if indexPath.section == 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: "MePersonInfoCellReuseIdentifier", for: indexPath)
        }else{
            cell = tableView.dequeueReusableCell(withIdentifier: "MeViewControllerCellIdentifier")
            if cell == nil {
                cell = UITableViewCell.init(style: .value1, reuseIdentifier: "MeViewControllerCellIdentifier")
                cell.textLabel?.font = UIFont.systemFont(ofSize: 15)
                cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 15)
                cell.accessoryType = .disclosureIndicator
            }
            cell.textLabel?.text = _titleArr[indexPath.row]
            
            cell.detailTextLabel?.text = indexPath.row < 4 ? "0":""
            
        }
        
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = BaseViewController()

        self.navigationController?.pushViewController(vc, animated: true)

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
