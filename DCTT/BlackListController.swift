//
//  BlackListController.swift
//  DCTT
//
//  Created by wyg on 2018/11/3.
//  Copyright © 2018年 Light.W. All rights reserved.
//

import UIKit

class BlackListController: MeBaseTableViewController {
    var pageNumber:Int = 1;
    var dataArray = [[String:Any]]();

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "黑名单"
        
        tableView.register(UINib (nibName: "FensiCell", bundle: nil), forCellReuseIdentifier: "FensiCellIdentifier");
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCellReuseIdentifier")
        tableView.backgroundColor = UIColor.white
        
        tableView.rowHeight = 80;
        
        //refresh
        let header = TTRefreshHeader.init(refreshingBlock: {[weak self] in
            guard let strongSelf = self else{return}
            strongSelf.pageNumber = 1
            strongSelf.tableView.mj_footer.state = .idle
            strongSelf.loadData()
        })
        
        tableView.mj_header = header;
        
        let footer = TTRefreshFooter  {  [weak self] in
            guard let strongSelf = self else{return}
            strongSelf.pageNumber = strongSelf.pageNumber + 1
            strongSelf.loadData();
        }
        
        tableView.mj_footer = footer
        tableView.mj_footer.isHidden = true
        
        
        tableView.tableFooterView = UIView()
        
        tableView.mj_header.beginRefreshing()
        
    }

    func loadData() {
        _watchAction(1, msg: "加载完成")
    }
    
    
    ///0:检测是否关注 1://查询我的粉丝 2://查询我的关注
    func _watchAction(_ type:Int , msg:String?) {
        guard let myid = User.uid() else {return}
        let d = ["uid":myid , "auhorId":"_author" , "type":type] as [String : Any]
        
        HUD.show()
        AlamofireHelper.post(url: blackList_url, parameters: d, successHandler: {[weak self] (res) in
            HUD.dismiss()
            guard let ss = self else {return}
            //ss.loadDataSuccess = true
            
            if ss.pageNumber == 1{ ss.dataArray.removeAll()}
            
            if ss.tableView.mj_header.isRefreshing(){
                ss.tableView.mj_header.endRefreshing()
            }else if ss.tableView.mj_footer.isRefreshing() {
                ss.tableView.mj_footer.endRefreshing()
            }
            
            
            if let arr = res["body"] as? [[String:Any]] {
                if ss.tableView.mj_footer.isHidden && arr.count > 0 {
                    ss.tableView.mj_footer.isHidden = false
                }
                
                ss.dataArray = ss.dataArray + arr;
                if arr.count < 20 {
                    ss.tableView.mj_footer.state = .noMoreData
                }
            }else {
                ss.tableView.mj_footer.state = .noMoreData
            }
            
            if ss.dataArray.count == 0 {
                ss.tableView.separatorStyle = .none;
                ss.tableView.mj_footer.isHidden = true
            }else{
                ss.tableView.separatorStyle = .singleLine;
            }
            
            ss.tableView.reloadData()
        }) {[weak self] (error) in
            HUD.dismiss()
            guard let ss = self else {return}
            //ss.loadDataSuccess = false
            if ss.tableView.mj_header.isRefreshing(){ss.tableView.mj_header.endRefreshing()}
            else if ss.tableView.mj_footer.isRefreshing() {ss.tableView.mj_footer.endRefreshing()}
        }
    }

    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dataArray.count == 0 ? 1 : dataArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if dataArray.count == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCellReuseIdentifier", for: indexPath)
            cell.textLabel?.text = "你还没有拉黑其他用户奥"
            cell.textLabel?.font = UIFont.systemFont(ofSize: 13)
            cell.textLabel?.textColor = UIColor.lightGray
            cell.textLabel?.textAlignment = .center
            cell.isUserInteractionEnabled = false
            return cell
        }
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FensiCellIdentifier", for: indexPath) as! FensiCell
        
        let d = dataArray[indexPath.row]
        
        cell.fill(d , isWatched: false);
        cell.buttonClickedAction = {
            tableView.mj_header.beginRefreshing()
        }
        
        cell.accessoryType = .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /*let d = dataArray[indexPath.row]
        guard let dic = d["user"] as? [String:Any] else {return}
        
        guard let uid = dic["user_id"] as? String else {return}
        
        let vc = MeHomePageController.init(style:.plain)
        vc.uid = uid;//
        
        self.navigationController?.pushViewController(vc, animated: true)*/
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
