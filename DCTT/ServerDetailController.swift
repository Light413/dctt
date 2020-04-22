//
//  ServerDetailController.swift
//  DCTT
//
//  Created by wyg on 2018/9/18.
//  Copyright © 2018年 Light.W. All rights reserved.
//

import UIKit

class ServerDetailController: BaseDetailController {

    private var _type:String!
    private var _cellReuseIdentifier:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _type = String.isNullOrEmpty(data["type"])
        
        title = kPublishTypeInfo[_type]
        
        switch _type! {
        case "6" ,"20","26","22","27" ://专题,吃喝玩乐、二手交易、便民信息
            _cellReuseIdentifier = "ZTDetailCellIdentifier"
            _tableview.register(UINib (nibName: "ZTDetailCell", bundle: nil), forCellReuseIdentifier: "ZTDetailCellIdentifier")
            break
            
        case "21","24","25", "23"://求职、房屋、打车、交友
            _cellReuseIdentifier = "QiuzhiCellIdentifier"
            _tableview.register(UINib (nibName: "QiuzhiCell", bundle: nil), forCellReuseIdentifier: "QiuzhiCellIdentifier")
            break
//        case "22"://商家
//            _cellReuseIdentifier = "ShangjiaCellIdentifier"
//            _tableview.register(UINib (nibName: "ShangjiaCell", bundle: nil), forCellReuseIdentifier: "ShangjiaCellIdentifier")
//            break
            
//        case "23"://交友
//            _cellReuseIdentifier = "JiaoyouCellIdentifier"
//            _tableview.register(UINib (nibName: "JiaoyouCell", bundle: nil), forCellReuseIdentifier: "JiaoyouCellIdentifier")
//
//            break
        default:
            break
        }
        
        
        /////TTPostCommentSuccessNotification
        NotificationCenter.default.addObserver(self, selector: #selector(postCommentSuccessAction(_ :)), name: TTPostCommentSuccessNotification, object: nil)
        
        loadComment()
    }
    
    @objc func postCommentSuccessAction(_ noti:NSNotification) {
        loadComment()
    }
    
    
    
    
    override func getCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        if _cellReuseIdentifier != nil {
            let cell = tableView.dequeueReusableCell(withIdentifier: _cellReuseIdentifier, for: indexPath)
                as! ServerBaseCell
            
            cell.fill(data)
            
            return cell

        }else {
            return super.getCell(tableView, indexPath: indexPath)
        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
