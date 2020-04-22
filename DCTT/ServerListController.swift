//
//  ServerListController.swift
//  DCTT
//
//  Created by wyg on 2018/8/22.
//  Copyright © 2018年 Light.W. All rights reserved.
//没用 - 实现多列表切换

import UIKit

class ServerListController: UITableViewController {
    var uid:String!
    
    private var canScroll:Bool = false;
    private var dataArray = [[String:Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib (nibName: "MeHomeCell", bundle: nil), forCellReuseIdentifier: "MeHomeCellIdentifier")
        tableView.estimatedRowHeight = 80;
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView();
        tableView.showsVerticalScrollIndicator = false

        tableView.separatorColor = UIColor (red: 232/255.0, green: 232/255.0, blue: 232/255.0, alpha: 1)
        
        tableView.register(UINib (nibName: "HomeCell", bundle: nil), forCellReuseIdentifier: "HomeCellReuseIdentifierId")
        tableView.register(UINib (nibName: "HomeCellWithImage", bundle: nil), forCellReuseIdentifier: "HomeCellWithImageIdentifierId")
        tableView.register(UINib (nibName: "HomeCellWithImages", bundle: nil), forCellReuseIdentifier: "HomeCellWithImagesIdentifierId")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCellReuseIdentifier")
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(noti(_ :)), name: NSNotification.Name (rawValue: "childCanScrollNotification"), object: nil)
        
        //////
        loadData();
    }
    
    
    func loadData() {
        //HUD.show(withStatus: NSLocalizedString("Loading", comment: ""))
        let d = ["category":"sy"]
        
        AlamofireHelper.post(url: home_list_url, parameters: d, successHandler: {[weak self] (res) in
            HUD.dismiss()
            
            guard let ss = self else {return}
            
            if let arr = res["body"] as? [[String:Any]] {
                let new = Tools.default.filterDislikeData(arr)
                ss.dataArray = ss.dataArray + new;
//                if arr.count < 20 {
//                    ss.tableView.mj_footer.state = .noMoreData
//                }else{
//                    ss.tableView.mj_footer.isHidden = false
//                }
            }else {
//                ss.tableView.mj_footer.state = .noMoreData
            }
            
            
            ss.tableView.reloadData()
            //print(res);
        }) { (error) in
            HUD.dismiss()
        }
        
        
    }
    
    
    //MARK:- 控制滑动
    @objc func noti(_ noti:NSNotification) {
        canScroll = true

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
        let d = dataArray[indexPath.row]
        let type =  Int(String.isNullOrEmpty(d["imageNum"])) ?? 0
        
        var identifier :String = "HomeCellReuseIdentifierId"
        
        
        switch type {
        case 0:
//            (cell as! HomeCell).fill(d)
            
            break
        case let n where n < 3:
            identifier = "HomeCellWithImageIdentifierId"
//            cell = tableView.dequeueReusableCell(withIdentifier:  identifier, for: indexPath)
//            (cell as! HomeCellWithImage).fill(d)
            break
        case let n where n >= 3:
            
            identifier = "HomeCellWithImagesIdentifierId"
//            cell = tableView.dequeueReusableCell(withIdentifier:  identifier, for: indexPath)
//            (cell as! HomeCellWithImages).fill(d)
            
            break
        default:break
        }
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier:  identifier, for: indexPath) as! HomeListBaseCell
        
        cell.fill(d)
        
        cell.dislikeBlock = {[weak self] in
            guard let ss = self else {return}
            ss._dislike(indexPath)
        }
        
        
        cell.selectionStyle = .default
        return cell
    }
    
    func _dislike(_ index:IndexPath) {
        let d = dataArray[index.row]
        let pid =  String.isNullOrEmpty(d["pid"])
        
        dataArray.remove(at: index.row)
        //        tableView.deleteRows(at: [index], with: .left)
        tableView.reloadData()
        
        Tools.default.addDislike(pid)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
