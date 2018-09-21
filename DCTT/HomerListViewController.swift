//
//  HomerListViewController.swift
//  DCTT
//
//  Created by wyg on 2017/12/21.
//  Copyright © 2017年 Light.W. All rights reserved.
//

import UIKit
import MJRefresh
import Alamofire

class HomerListViewController: BaseTableViewController {
    var pageNumber:Int = 1;
    
    private var _type:String!
    private var _category:String!
    private var loadDataSuccess:Bool = false
    
    ///type:小分类 , category:大分类 sy-首页 life-生活服务
    init(_ type:String , category:String = "sy") {
        super.init(nibName: nil, bundle: nil)
        
        _type = type
        _category = category
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(hasPublishSuccessNoti(_:)), name: kHasPublishedSuccessNotification, object: nil)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCellReuseIdentifier")

        tableView.register(UINib (nibName: "HomeCell", bundle: nil), forCellReuseIdentifier: "HomeCellReuseIdentifierId")
        tableView.register(UINib (nibName: "HomeCellWithImage", bundle: nil), forCellReuseIdentifier: "HomeCellWithImageIdentifierId")
        tableView.register(UINib (nibName: "HomeCellWithImages", bundle: nil), forCellReuseIdentifier: "HomeCellWithImagesIdentifierId")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCellReuseIdentifier")
        
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
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        
        if let delegate = UIApplication.shared.delegate as? AppDelegate{
            guard delegate._networkReachabilityManager.isReachable else {
                HUD.showText("貌似网络不太好,请稍后重试", view: self.view)
                return
            }
        }
        
        tableView.mj_header.beginRefreshing()
    }

    ///发布成功，更新对应的列表
    func hasPublishSuccessNoti(_ noti:Notification) {
        if let info = noti.userInfo , let type = info["type"] as? String{
            if _type! == type || _type! == "0" {
                tableView.mj_header.beginRefreshing()
            }
        }
    }
    
    func loadData() {
        //HUD.show(withStatus: NSLocalizedString("Loading", comment: ""))
        var subType = 0
        switch _type! {
            case "0":subType = 0;break//最新
            case "1":subType = 1;break//最热
            case "2":subType = 2;break//nouse
            case "3":subType = 3; break//nouse
            case "4":subType = 4;break//nouse
            case "5":subType = 5;break//nouse
            case "6":subType = 6;break//nouse
            default: subType = Int(_type)!; break
        }
        
        let d = ["category":_category! ,
                 "subType":subType ,
                 "pageNumber":pageNumber
            ] as [String : Any]
        
        AlamofireHelper.post(url: home_list_url, parameters: d, successHandler: {[weak self] (res) in
            HUD.dismiss()
            guard let ss = self else {return}
            ss.loadDataSuccess = true
            
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
            
            
            ss.tableView.reloadData()
            //print(res);
        }) {[weak self] (error) in
            HUD.dismiss()
            guard let ss = self else {return}
            ss.loadDataSuccess = false
            if ss.tableView.mj_header.isRefreshing(){ss.tableView.mj_header.endRefreshing()}
            else if ss.tableView.mj_footer.isRefreshing() {ss.tableView.mj_footer.endRefreshing()}
        }

        
    }
    
    
    
    //MARK:-
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if loadDataSuccess {
            return dataArray.count == 0 ? 1 : dataArray.count
        }
        
        return dataArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if dataArray.count == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCellReuseIdentifier", for: indexPath)
            cell.textLabel?.text = "还没有数据"
            cell.textLabel?.font = UIFont.systemFont(ofSize: 12)
            cell.textLabel?.textColor = UIColor.lightGray
            cell.textLabel?.textAlignment = .center
            cell.isUserInteractionEnabled = false
            return cell
        }
        
        let d = dataArray[indexPath.row]
        let type =  Int(String.isNullOrEmpty(d["imageNum"])) ?? 0
        var identifier :String = "HomeCellReuseIdentifierId"

        switch type {
        case 0: identifier = "HomeCellReuseIdentifierId";break
            
        case let n where n < 3:
            identifier = "HomeCellWithImageIdentifierId"
            break
            
        case let n where n >= 3:
            identifier = "HomeCellWithImagesIdentifierId"; break
            
        default:break
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier:  identifier, for: indexPath) as! HomeListBaseCell
        cell.type = _category
        cell.fill(d)
        
        cell.selectionStyle = .default
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let d = dataArray[indexPath.row]
        let pid =  String.isNullOrEmpty(d["pid"])
        let vc = _category! == "life" ? ServerDetailController(pid , type:kCategory_life) : HomeDetailController(pid , type:kCategory_home)
        
        vc.data = d
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
