//
//  HomerListViewControllerTest2.swift
//  DCTT
//
//  Created by wyg on 2018/8/9.
//  Copyright © 2018年 Light.W. All rights reserved.
//

import UIKit

class MeHomeListController: UITableViewController {
    var uid:String!
    
    private var canScroll:Bool = false;
    private var dataArray = [[String:Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib (nibName: "MeHomeCell", bundle: nil), forCellReuseIdentifier: "MeHomeCellIdentifier")
        tableView.estimatedRowHeight = 80;
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView();
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        
        NotificationCenter.default.addObserver(self, selector: #selector(noti(_ :)), name: NSNotification.Name (rawValue: "childCanScrollNotification"), object: nil)

        //////
        loadData();
        loadProfile()
    }
    
    func loadProfile() {
        //"cdbd1bd27dbf0fe4ae76b08f9462c983"
        guard let u = uid else {return}
        let d:[String:Any] = ["uid":u, "type":3]
        
        AlamofireHelper.post(url: update_profile_url, parameters: d, successHandler: { (res) in
            guard String.isNullOrEmpty(res["status"]) == "200" else { return;}
            guard let user = res["body"] as? [String:Any] else {return}
            
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: NSNotification.Name.init("updateProfileNotification"), object: nil, userInfo: user)
            }
        }) { (err) in
            
        }
    }
    
    func loadData() {
        //HUD.show(withStatus: NSLocalizedString("Loading", comment: ""))
        guard let uid = uid else {return}
        let d = ["category":"sy" , "uid": uid]
        
        HUD.show()
        AlamofireHelper.post(url: home_list_url, parameters: d, successHandler: {[weak self] (res) in
            HUD.dismiss()
            
            guard let ss = self else {return}
            
            if let arr = res["body"] as? [[String:Any]] {
                ss.dataArray = ss.dataArray + arr;
//                if arr.count < 20 {
//                    ss.tableView.mj_footer.state = .noMoreData
//                }else{
//                    ss.tableView.mj_footer.isHidden = false
//                }
            }else {
//                ss.tableView.mj_footer.state = .noMoreData
            }
            
            
            ss.tableView.reloadData()
        }) { (error) in
            HUD.dismiss()
        }
        
        
    }
    
    
    //MARK:- 控制滑动
    func noti(_ noti:NSNotification) {
        canScroll = true
        //print("child can")
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
    
    //MARK:-
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier :String = "MeHomeCellIdentifier"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! MeHomeCell
        
        let d = dataArray[indexPath.row]
        cell.fill(d)
        cell.selectionStyle = .none
        
        return cell
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
