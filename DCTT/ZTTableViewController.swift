//
//  ZTTableViewController.swift
//  DCTT
//
//  Created by wyg on 2018/9/8.
//  Copyright © 2018年 Light.W. All rights reserved.
//

import UIKit

class ZTTableViewController: BaseTableViewController {
    private var _type:String!//最新，热门
    var pageNumber:Int = 1;

    init(_ type:String) {
        super.init(nibName: nil, bundle: nil)
        
        _type = type
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib (nibName: "ZTTableViewCell", bundle: nil), forCellReuseIdentifier: "ZTTableViewCellIdentifier")
        
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        
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

        
        tableView.mj_header.beginRefreshing()
    }

    
    func loadData() {
        //HUD.show(withStatus: NSLocalizedString("Loading", comment: ""))
        var d = ["category":"friend",
                 "subType":Int(_type!)!
            ] as [String : Any]
        
        ///已登录，过滤黑名单
        if let myid = User.uid(){
            d["uid"] = myid
        }

        AlamofireHelper.post(url: home_list_url, parameters: d, successHandler: {[weak self] (res) in
            HUD.dismiss()
            
            guard let ss = self else {return}
            if ss.pageNumber == 1{ ss.dataArray.removeAll()}
            
            if ss.tableView.mj_header.isRefreshing(){
                ss.tableView.mj_header.endRefreshing()
            }else if ss.tableView.mj_footer.isRefreshing() {
                ss.tableView.mj_footer.endRefreshing()
            }
            
            if let arr = res["body"] as? [[String:Any]] {
                let new = Tools.default.filterDislikeData(arr)
                ss.dataArray = ss.dataArray + new;
                if arr.count < 20 {
                    ss.tableView.mj_footer.state = .noMoreData
                }else{
                    ss.tableView.mj_footer.isHidden = false
                }
            }else {
                ss.tableView.mj_footer.state = .noMoreData
            }
            
            
            ss.tableView.reloadData()
            
        }) { (error) in
            HUD.dismiss()
        }
        
        
    }

    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dataArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ZTTableViewCellIdentifier", for: indexPath) as! ZTTableViewCell
        
        let d = dataArray[indexPath.row]
        cell.fill(d)

        cell.dislikeBlock = {[weak self] in
            guard let ss = self else {return}
            ss._dislike(indexPath)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let d = dataArray[indexPath.row]
        let pid =  String.isNullOrEmpty(d["pid"])
        let vc = ServerDetailController(pid,type:kCategory_zt)
        
        vc.data = d
        
        self.navigationController?.pushViewController(vc, animated: true)
    }

    
    func _dislike(_ index:IndexPath) {
        let d = dataArray[index.row]
        let pid =  String.isNullOrEmpty(d["pid"])
        
        dataArray.remove(at: index.row)
        //        tableView.deleteRows(at: [index], with: .left)
        tableView.reloadData()
        
        Tools.default.addDislike(pid)
        
    }


}
