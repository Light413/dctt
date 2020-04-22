//
//  HistoryDetailController.swift
//  DCTT
//
//  Created by wyg on 2018/10/23.
//  Copyright © 2018年 Light.W. All rights reserved.
//

import UIKit

class HistoryDetailController: MeBaseTableViewController {

    var info:[String:Any]?
    
    var row = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib (nibName: "_TodayDetailCell", bundle: nil), forCellReuseIdentifier: "_TodayViewCellIdentifier")
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension

        
        if let d = info {
            row = 1
            let _date = Tools.stringToDate(String.isNullOrEmpty(d["date"]), formatter: "yyyyMMdd")
            title = Tools.dateToString(_date, formatter: "yyyy年MM月dd日")

            tableView.reloadData();
            
        }

    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return row
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "_TodayViewCellIdentifier", for: indexPath)
            as! _TodayDetailCell

        cell.fill(info!)
        
        return cell
    }
    

    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }



}
