//
//  HomeListViewModel.swift
//  DCTT
//
//  Created by wyg on 2021/3/4.
//  Copyright © 2021 Light.W. All rights reserved.
//

import UIKit
import SkeletonView
class HomeListViewModel: NSObject,UITableViewDelegate{
    ///。。。需要个参数描述的model
    
    private var pageNumber:Int = 1;
    private var _type:String! = "0"
    private var _category:String! = "sy"
    private var loadDataSuccess:Bool = false
    var dataArray = [[String:Any]]()
    
    public var tableView:UITableView!
    weak public var parentViewController:UIViewController?
    
    /// - parameter:所属的UIViewController
    init(_ parentController:UIViewController?) {
        super.init()
        
        parentViewController = parentController
        tableView = _tableView();
    }
   
    ///显示骨架动画
    public func showSkeletonAnimate(){
        tableView.showAnimatedGradientSkeleton()
    }
    
   private func _tableView() -> UITableView {
    let tableView = UITableView.init(frame: CGRect.zero, style: .plain);
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.register(UINib (nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCell");
        tableView.isSkeletonable = true;
        tableView.backgroundColor = UIColor.white
        tableView.separatorColor = UIColorFromHex(rgbValue: 0xE6E6E6);
    //tableView.separatorStyle = .none;
        tableView.sectionHeaderHeight = 0
        tableView.sectionFooterHeight = 6
        tableView.tableHeaderView = UIView (frame: CGRect (x: 0, y: 0, width: 0, height: CGFloat.leastNormalMagnitude))
        tableView.tableFooterView = UIView (frame: CGRect (x: 0, y: 0, width: 0, height: CGFloat.leastNormalMagnitude));
        tableView.estimatedRowHeight = 120;
        tableView.rowHeight = UITableView.automaticDimension;
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCellReuseIdentifier")
        tableView.register(UINib (nibName: "HomeCell", bundle: nil), forCellReuseIdentifier: "HomeCellReuseIdentifierId")
        tableView.register(UINib (nibName: "HomeCellWithImage", bundle: nil), forCellReuseIdentifier: "HomeCellWithImageIdentifierId")
        tableView.register(UINib (nibName: "HomeCellWithImages", bundle: nil), forCellReuseIdentifier: "HomeCellWithImagesIdentifierId")
    
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
        return tableView;
    }
    
    func loadData() {
        //HUD.show(withStatus: NSLocalizedString("Loading", comment: ""))
        var subType = 0
        switch _type! {
            case "0":subType = 0;break//最新
            case "1":subType = 1;break//最热
            default: subType = Int(_type)!; break
        }
        
        var d = ["category":_category! ,
                 "subType":subType ,
                 "pageNumber":pageNumber
            ] as [String : Any]
        
        ///已登录，过滤黑名单
        if let myid = User.uid(){
            d["uid"] = myid
        }
        AlamofireHelper.post(url: home_list_url, parameters: d, successHandler: {[weak self] (res) in
            HUD.dismiss()
            guard let ss = self else {return}
            ss.loadDataSuccess = true;
            ss.tableView.hideSkeleton();
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
                
                let new = Tools.default.filterDislikeData(arr)
                ss.dataArray = ss.dataArray + new;
                if arr.count < 20 {
                    ss.tableView.mj_footer.state = .noMoreData
                }
            }else {
                ss.tableView.mj_footer.state = .noMoreData
            }
            
            ss.tableView.reloadData();
        }) {[weak self] (error) in
            HUD.dismiss()
            print("request error");
            guard let ss = self else {return}
            ss.tableView.hideSkeleton();
            ss.loadDataSuccess = false
            if ss.tableView.mj_header.isRefreshing(){ss.tableView.mj_header.endRefreshing()}
            else if ss.tableView.mj_footer.isRefreshing() {ss.tableView.mj_footer.endRefreshing()}
        }
    }
    
    //MARK:- UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
        let igNum =  Int(String.isNullOrEmpty(d["imageNum"])) ?? 0
        var identifier :String = "HomeCellReuseIdentifierId"

        if _category == kCategory_life {
            identifier = "LifeListViewCelIdentifier"
            let cell = tableView.dequeueReusableCell(withIdentifier:  identifier, for: indexPath) as! LifeListViewCell
//            cell.type = _category
            cell.fill(d)
            cell.dislikeBlock = {[weak self] in
                guard let ss = self else {return}
//                ss._dislike(indexPath)
            }
            
            cell.selectionStyle = .none
            return cell
        }
        
        ///首页列表
        switch igNum {
            case 0: identifier = "HomeCellReuseIdentifierId";break
            case let n where n < 3: identifier = "HomeCellWithImageIdentifierId"; break
            case let n where n >= 3: identifier = "HomeCellWithImagesIdentifierId"; break
            default:break
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier:  identifier, for: indexPath) as! HomeListBaseCell
        cell.type = _category
        cell.fill(d)
        cell.dislikeBlock = {[weak self] in
            guard let ss = self else {return}
//            ss._dislike(indexPath)
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let d = dataArray[indexPath.row]
        let pid =  String.isNullOrEmpty(d["pid"])
        let vc = _category! == "life" ? ServerDetailController(pid , type:kCategory_life) : HomeDetailController(pid , type:kCategory_home)
        vc.data = d;
        
        guard let pvc = parentViewController else{return}
        pvc.navigationController?.pushViewController(vc, animated: true)
    }
}

extension HomeListViewModel:SkeletonTableViewDataSource{
    //默认会根据UITableView高度自动计算需要几个单元格，此方法可不要
    /*func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5;
    }*/
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "TableViewCell"
    }
}
