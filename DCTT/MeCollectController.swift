//
//  MeCollectController.swift
//  DCTT
//
//  Created by wyg on 2018/3/25.
//  Copyright © 2018年 Light.W. All rights reserved.
//

import UIKit

class MeCollectController: MeBaseTableViewController ,AddButtonItemProtocol,ShowAlertControllerAble{

    var pageNumber:Int = 1;
    var dataArray = [[String:Any]]();
    
    var viewM:MeHomeViewM!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "收藏";
        
        tableView.register(UINib (nibName: "MeHomeCell", bundle: nil), forCellReuseIdentifier: "MeHomeCellIdentifier")

        //tableView.register(UINib (nibName: "CollectCell", bundle: nil), forCellReuseIdentifier: "CollectCellIdentifier")
        _initSubviews()

        

    }
    
    
    
    func _getBarButtonItem(title : String? = nil , image:UIImage? = nil , action : Selector) -> UIBarButtonItem{
        let rightbtn = UIButton (frame: CGRect (x: 0, y: 0, width: 60, height: 60))
        rightbtn.setTitle(title, for: .normal)
        rightbtn.setTitleColor(UIColor.darkGray , for: .normal)
        rightbtn.setImage(image, for: .normal)
        rightbtn.setImage(image, for: .highlighted)
        rightbtn.imageEdgeInsets = UIEdgeInsetsMake(10, 15, 10, 5)
        
        rightbtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        rightbtn.addTarget(self, action: action , for: .touchUpInside)
        
        
        let rightitem = UIBarButtonItem.init(customView: rightbtn)
        
        return rightitem
    }

    
    func deleteAction() {
        
        showMsg("删除所有收藏?", title: "删除") { () in
            
        }
    }
    
    func _initSubviews() {
        let rightItem = _getBarButtonItem(image: UIImage (named: "delete_allshare")!, action: #selector(deleteAction))
        
        navigationItem.rightBarButtonItem = rightItem
        
        viewM = MeHomeViewM.init(self , isFromPublish: false)
        
        tableView = viewM.tableview
    }
    

    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
