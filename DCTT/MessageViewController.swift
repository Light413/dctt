//
//  MessageViewController.swift
//  DCTT
//
//  Created by wyg on 2018/3/25.
//  Copyright © 2018年 Light.W. All rights reserved.
//

import UIKit
//import SwiftyJSON

class MessageViewController: MeBaseTableViewController ,ShowAlertControllerAble{
    var pageNumber:Int = 1;
    var dataArray = [[String:Any]]();

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "消息"
        view.backgroundColor = UIColor.white
        
        _init()
    }

    
    func _init() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCellReuseIdentifier")
        tableView.register(UINib (nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "MessageCellIdentifier")
        
        tableView.estimatedRowHeight = 60;
        tableView.rowHeight = UITableView.automaticDimension
        tableView.sectionHeaderHeight = 20
        
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

        let rightItem = _getBarButtonItem(title:"清空", action: #selector(deleteAction))
        
        navigationItem.rightBarButtonItem = rightItem
    }
    
    func _getBarButtonItem(title : String? = nil , image:UIImage? = nil , action : Selector) -> UIBarButtonItem{
        let rightbtn = UIButton (frame: CGRect (x: 0, y: 0, width: 60, height: 60))
        rightbtn.setTitle(title, for: .normal)
        rightbtn.setTitleColor(UIColor.darkGray , for: .normal)
        rightbtn.setImage(image, for: .normal)
        rightbtn.setImage(image, for: .highlighted)
        rightbtn.imageEdgeInsets = UIEdgeInsets.init(top: 10, left: 15, bottom: 10, right: 5)
        
        rightbtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        rightbtn.addTarget(self, action: action , for: .touchUpInside)
        
        
        let rightitem = UIBarButtonItem.init(customView: rightbtn)
        
        return rightitem
    }
    
    
    @objc func deleteAction() {
        guard dataArray.count > 0 else {return}
        showMsg("清空消息列表?", title: "清空") { [weak self] in
            guard let ss = self else {return}
            
            ss._delete()
        }
    }
    
    func _delete() {
        guard let myid = User.uid() else {return}
        let d = ["uid":myid , "type":2] as [String : Any]
        
        HUD.show()
        AlamofireHelper.post(url: get_msglist_url, parameters: d, successHandler: {[weak self] (res) in
            HUD.show(successInfo: "删除成功")
            guard let ss = self else {return}
            ss.pageNumber = 1;
            ss.loadData()
        }) { (error) in
            HUD.show(info: "删除失败,请重试")
        }
    }

    
    func loadData() {
        guard let uid = User.uid() else {return}
        let d = ["uid": uid ,
                 "pageNumber":pageNumber,
                 "type":1 ,
                 ] as [String : Any]
        
        HUD.show(withStatus: NSLocalizedString("Loading", comment: ""))
        
        AlamofireHelper.post(url: get_msglist_url, parameters: d, successHandler: {[weak self] (res) in
            HUD.dismiss()
            guard let ss = self else {return}
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
            print(error?.localizedDescription)
            
            guard let ss = self else {return}
            //ss.loadDataSuccess = false
            if ss.tableView.mj_header.isRefreshing(){ss.tableView.mj_header.endRefreshing()}
            else if ss.tableView.mj_footer.isRefreshing() {ss.tableView.mj_footer.endRefreshing()}
            
            print("message loadData Fail")
            ss.loadData()
        }
    }
    
    
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dataArray.count == 0 ? 1 : dataArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if dataArray.count == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCellReuseIdentifier", for: indexPath)
            cell.textLabel?.text = "暂无消息"
            cell.textLabel?.font = UIFont.systemFont(ofSize: 13)
            cell.textLabel?.textColor = UIColor.lightGray
            cell.textLabel?.textAlignment = .center
            cell.isUserInteractionEnabled = false
            return cell
        }
        
        let identifier :String = "MessageCellIdentifier"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! MessageCell
        let d = dataArray[indexPath.row];
        cell.fill(d)

        return cell
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let d = dataArray[indexPath.row]
        let postStr = String.isNullOrEmpty(d["content"])
        let type = String.isNullOrEmpty(d["type"])//评论消息
        
        do{
            if let post = try JSONSerialization.jsonObject(with: postStr.data(using: String.Encoding.utf8)!, options: []) as? [String:Any]{
                if type == "2" || type == "3"{
                    let category = String.isNullOrEmpty(post["category"])
                    let pid = String.isNullOrEmpty(post["pid"])

                    let postDetailBase64str = String.isNullOrEmpty(post["postContent"])
                    let data = NSData.init(base64Encoded: postDetailBase64str, options: [])! as Data
                    do{
                        ///动态详情对象
                        let postDetailObj = try JSONSerialization.jsonObject(with: data, options: []) as! [String:Any]
                        
                        switch category {
                            case kCategory_home:
                                let vc =  HomeDetailController(pid , type:kCategory_home)
                                vc.data = postDetailObj
                                self.navigationController?.pushViewController(vc, animated: true);break
                            
                            case kCategory_zt , kCategory_life:
                                let vc =  ServerDetailController(pid , type:category)
                                vc.data = postDetailObj
                                self.navigationController?.pushViewController(vc, animated: true); break;
                            
                            default:break;
                        }

                        
                    }catch {
                        print("postContent 解析失败")
                    }
                }
            }
            
        }catch{
            
        }
        
    }
    
}
