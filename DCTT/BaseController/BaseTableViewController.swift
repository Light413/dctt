//
//  BaseTableViewController.swift
//  Toolbox
//
//  Created by gener on 17/6/28.
//  Copyright © 2017年 Light. All rights reserved.
//

import UIKit
import MJRefresh

class BaseTableViewController: UITableViewController {
    var dataArray = [[String:Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.showsVerticalScrollIndicator = false
//        tableView.separatorColor = UIColor (red: 232/255.0, green: 232/255.0, blue: 232/255.0, alpha: 1)
        
        tableView.tableFooterView = UIView();
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.showsVerticalScrollIndicator = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        tableView.showsVerticalScrollIndicator = true
    }
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        tableView.showsVerticalScrollIndicator = false
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dataArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier :String = "HomeCellReuseIdentifierId"
        let cell = tableView.dequeueReusableCell(withIdentifier:  identifier, for: indexPath)
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
    
}
