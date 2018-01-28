//
//  PublishFriendController.swift
//  DCTT
//
//  Created by wyg on 2018/1/27.
//  Copyright © 2018年 Light.W. All rights reserved.
//

import UIKit

class PublishFriendController: BaseViewController ,UITableViewDelegate,UITableViewDataSource{

    let PubFriendCellReuseIdentifier = "PubFriendCellReuseIdentifier"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        addNavigationItem()
        initSubviews()
        
    }

    func addNavigationItem() {
        let leftbtn = UIButton (frame: CGRect (x: 0, y: 0, width: 30, height: 30))
        //leftbtn.setTitle("取消", for: .normal)
        leftbtn.setImage(UIImage (named: "close_night"), for: .normal)
        
        leftbtn.setTitleColor(UIColor.darkGray, for: .normal)
        leftbtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        leftbtn.addTarget(self, action: #selector(navigationBackButtonAction), for: .touchUpInside)
        let leftitem = UIBarButtonItem.init(customView: leftbtn)
        navigationItem.leftBarButtonItem = leftitem
        
//        let rightbtn = UIButton (frame: CGRect (x: 0, y: 0, width: 30, height: 30))
//        rightbtn.setTitle("发布", for: .normal)
//        rightbtn.setTitleColor(kAirplaneCell_head_selected_color, for: .normal)
//        rightbtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
//        rightbtn.addTarget(self, action: #selector(navigationBackButtonAction), for: .touchUpInside)
//        let rightitem = UIBarButtonItem.init(customView: rightbtn)
//        //navigationItem.rightBarButtonItem = rightitem
        
    }
    
    
    func navigationBackButtonAction() {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func initSubviews()  {
        let tableview = UITableView.init(frame: CGRect (x: 0, y: 0, width: kCurrentScreenWidth, height: kCurrentScreenHeight - 50), style: .grouped)
        tableview.delegate = self
        tableview.dataSource = self
        tableview.backgroundColor = kTableviewBackgroundColor
        
        view.addSubview(tableview)
        
        tableview.register(UINib (nibName: "PubFriendCell", bundle: nil), forCellReuseIdentifier: PubFriendCellReuseIdentifier)
        tableview.register(UINib (nibName: "PubWriteCell", bundle: nil), forCellReuseIdentifier: "PubWriteCellReuseIdentifier")
        tableview.register(UINib (nibName: "PubCityCell", bundle: nil), forCellReuseIdentifier: "PubCityCellIdentifier")
        
        tableview.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCellReuseIdentifier")
        
        tableview.separatorStyle = .none
        
        //////
        let rightbtn = UIButton (frame: CGRect (x: 0, y: kCurrentScreenHeight - 45, width: kCurrentScreenWidth, height: 45))
        rightbtn.setTitle("发布", for: .normal)
        rightbtn.backgroundColor = UIColor (red: 212/255.0, green: 61/255.0, blue: 61/255.0, alpha: 0.8)//tt_BarColor
        //rightbtn.setBackgroundImage(UIImage (named: "loginbutton_drawer_press"), for: .normal)
        
        rightbtn.setTitleColor(UIColor.white, for: .normal)
        rightbtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        rightbtn.addTarget(self, action: #selector(navigationBackButtonAction), for: .touchUpInside)
        
        view.addSubview(rightbtn)
    }
    
    //MARK:-
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = indexPath.section == 0 ? PubFriendCellReuseIdentifier : (indexPath.section == 1 ? "PubWriteCellReuseIdentifier" : "PubCityCellIdentifier")
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        
        if indexPath.section == 1 {

        }else if indexPath.section == 2 {

        }
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? 280 : 48
    }
    
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return  10
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return  0.01
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
