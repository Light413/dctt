//
//  MeHomeViewM.swift
//  DCTT
//
//  Created by wyg on 2018/9/22.
//  Copyright © 2018年 Light.W. All rights reserved.
//

import UIKit

class MeHomeViewM: NSObject {
    var category:String!
    var type:String!
    
    ///个人中心和收藏共用
    var isFromHomePage = false
    
    ///用户ID
    var user_id:String!
    
    ///无数据提示
    var noDataTipMsg = "还没有数据"
    
    ///所属类型
    var isMyFromPublish:Bool = true //默认我的主页-发布
    
    ///重写代理方法scrollViewDidScroll
    var _scrollViewDidScroll:((UIScrollView) -> Void)?
    
    var tableview:UITableView {
        get{
            return _tableview;
        }
    }
    
    private var _tableview:UITableView!
    weak var superController:UIViewController?
    
    var pageNumber:Int = 1;
    var dataArray = [[String:Any]]();

    init(_ vc:UIViewController? , isFromPublish:Bool = true) {
        super.init()
        superController = vc
        isMyFromPublish = isFromPublish
        
        _tableview = UITableView.init(frame: CGRect (x: 0, y: 0, width: kCurrentScreenWidth, height: kCurrentScreenHeight), style: .plain)
        _tableview.showsVerticalScrollIndicator = false
        _tableview.separatorStyle = .none
        _tableview.backgroundColor = UIColor.white
        _tableview.delegate = self;
        _tableview.dataSource = self

        _tableview.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCellReuseIdentifier")
        _tableview.register(UINib (nibName: "MeHomeListCell", bundle: nil), forCellReuseIdentifier: "MeHomeListCellIdentifier")

        
        //refresh
        let header = TTRefreshHeader.init(refreshingBlock: {[weak self] in
            guard let strongSelf = self else{return}
            strongSelf.pageNumber = 1
            strongSelf._tableview.mj_footer.state = .idle
            strongSelf.loadData()
        })
        
        _tableview.mj_header = header;
        
        let footer = TTRefreshFooter  {  [weak self] in
            guard let strongSelf = self else{return}
            strongSelf.pageNumber = strongSelf.pageNumber + 1
            strongSelf.loadData();
        }
        
        _tableview.mj_footer = footer
        _tableview.mj_footer.isHidden = true
        _tableview.rowHeight = UITableView.automaticDimension
        _tableview.estimatedRowHeight = 80
        _tableview.tableFooterView = UIView()
        _tableview.mj_header.beginRefreshing()
    }
    
    func loadData() {
        guard let uid = user_id else {return}
        let d = ["category":"sy" ,
                 "uid": uid ,
                 "pageNumber":pageNumber,
                 "type":isMyFromPublish ? 0 : 1 ,
                 ] as [String : Any]
        
        HUD.show(withStatus: NSLocalizedString("Loading", comment: ""))
        
        AlamofireHelper.post(url: get_sc_url, parameters: d, successHandler: {[weak self] (res) in
            HUD.dismiss()
            guard let ss = self else {return}
            //ss.loadDataSuccess = true
            
            if ss.pageNumber == 1{ ss.dataArray.removeAll()}
            if ss._tableview.mj_header.isRefreshing(){
                ss._tableview.mj_header.endRefreshing()
            }else if ss._tableview.mj_footer.isRefreshing() {
                ss._tableview.mj_footer.endRefreshing()
            }
            
            
            if let arr = res["body"] as? [[String:Any]] {
                if ss._tableview.mj_footer.isHidden && arr.count > 0 {
                    ss._tableview.mj_footer.isHidden = false
                }
                
                ss.dataArray = ss.dataArray + arr;
                if arr.count < 20 {
                    ss._tableview.mj_footer.state = .noMoreData
                }
            }else {
                ss._tableview.mj_footer.state = .noMoreData
            }
            
            if ss.dataArray.count == 0 {
                ss._tableview.separatorStyle = .none;
                ss._tableview.mj_footer.isHidden = true
            }else{
                ss._tableview.separatorStyle = .singleLine;
            }
            
            ss._tableview.reloadData()
        }) {[weak self] (error) in
            HUD.dismiss()
            print(error?.localizedDescription)
            
            guard let ss = self else {return}
            //ss.loadDataSuccess = false
            if ss._tableview.mj_header.isRefreshing(){ss._tableview.mj_header.endRefreshing()}
            else if ss._tableview.mj_footer.isRefreshing() {ss._tableview.mj_footer.endRefreshing()}
            ss.loadData()
        }
    }
    
 
}

extension MeHomeViewM:UITableViewDelegate,UITableViewDataSource{
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dataArray.count == 0 ? 1 : dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if dataArray.count == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCellReuseIdentifier", for: indexPath)
            cell.textLabel?.text = noDataTipMsg
            cell.textLabel?.font = UIFont.systemFont(ofSize: 13)
            cell.textLabel?.textColor = UIColor.lightGray
            cell.textLabel?.textAlignment = .center
            cell.isUserInteractionEnabled = false
            return cell
        }
        
        let d = dataArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "MeHomeListCellIdentifier", for: indexPath) as! MeHomeListCell
        cell.fill(d)
        
        cell.dislikeBlock = {[weak self] in
            guard let ss = self else {return}
            ss._dislike(indexPath)
        }
        
        if !isFromHomePage {
            cell.viewWithTag(100)?.isHidden = true
        }
        
        cell.selectionStyle = .default
        return cell
    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let d = dataArray[indexPath.row]
        let pid =  String.isNullOrEmpty(d["pid"])
        var _category = kCategory_home
        
        if let type = Int(String.isNullOrEmpty(d["type"])) {
            switch type {
                case 10..<20: _category = kCategory_home;break;
                case 6: _category = kCategory_zt; break
                case 20..<30 :_category = kCategory_life; break
                default:break
            }
        }
        
        var vc : BaseDetailController
        if _category == kCategory_life || _category == kCategory_zt {
            vc = ServerDetailController(pid , type:_category)
        }else{
            vc = HomeDetailController(pid , type:_category)
        }
        
        vc.data = d
        
        superController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let s = _scrollViewDidScroll {
            s(scrollView)
        }
    }
    
    func _dislike(_ index:IndexPath) {
        let d = dataArray[index.row]
        let pid =  String.isNullOrEmpty(d["pid"])
        let cat = getItemCategory(String.isNullOrEmpty(d["type"]))
        
        guard let myid = User.uid() else {return}
        let _d = ["uid":myid ,
                 "pid": pid,
                 "category":cat,
                 "type":0] as [String : Any]
        
        HUD.show()
        AlamofireHelper.post(url: delete_sc_url, parameters: _d, successHandler: {[weak self] (res) in
            guard let ss = self else{return}
            ss.dataArray.remove(at: index.row)
            //tableView.deleteRows(at: [index], with: .left)
            ss.tableview.reloadData()
            HUD.show(successInfo: "删除成功")
        }) { (error) in
            print(error)
            HUD.show(info: "删除失败,请重试")
        }
    }
    
}
