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
        
        tableView.register(UINib (nibName: "HomeCell", bundle: nil), forCellReuseIdentifier: "HomeCellReuseIdentifierId")
        tableView.register(UINib (nibName: "HomeCellWithImage", bundle: nil), forCellReuseIdentifier: "HomeCellWithImageIdentifierId")
        tableView.register(UINib (nibName: "HomeCellWithImages", bundle: nil), forCellReuseIdentifier: "HomeCellWithImagesIdentifierId")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCellReuseIdentifier")
        
        //test  refresh
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
        //tableView.mj_footer.isHidden = true
        
        //...
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        
        //
        //loadData()
        tableView.mj_header.beginRefreshing()
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
        
        let d = ["category":_category! , "subType":subType] as [String : Any]
        
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
                ss.dataArray = ss.dataArray + arr;
                if arr.count < 20 {
                    ss.tableView.mj_footer.state = .noMoreData
                }else{
                    ss.tableView.mj_footer.isHidden = false
                }
            }else {
                ss.tableView.mj_footer.state = .noMoreData
            }
            
            
            ss.tableView.reloadData()
            //print(res);
        }) { (error) in
            HUD.dismiss()
        }

        
    }
    
    
    
    //MARK:-
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
        let vc = _category! == "life" ? ServerDetailController(pid) : HomeDetailController(pid)
        
        vc.data = d
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
