//
//  HomerListViewControllerTest2.swift
//  DCTT
//
//  Created by wyg on 2018/8/9.
//  Copyright © 2018年 Light.W. All rights reserved.
//

import UIKit

class MeHomeListController: UITableViewController {
    var canScroll:Bool = false;
    var dataArray = [[String:Any]]()
    
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
        
    }
    
    func noti(_ noti:NSNotification) {
        canScroll = true
        //print("child can")
    }
    
    func loadData() {
        //HUD.show(withStatus: NSLocalizedString("Loading", comment: ""))
        guard let uid = User.uid() else {return}
        let d = ["type":"1" , "uid": uid]
        
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
            print(res);
        }) { (error) in
            HUD.dismiss()
        }
        
        
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
