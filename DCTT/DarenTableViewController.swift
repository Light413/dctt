//
//  DarenTableViewController.swift
//  DCTT
//
//  Created by wyg on 2018/9/8.
//  Copyright © 2018年 Light.W. All rights reserved.
//

import UIKit

class DarenTableViewController: BaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib (nibName: "DarenCell", bundle: nil), forCellReuseIdentifier: "DarenCellIdentifier")
        
        tableView.rowHeight = 100
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 10
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DarenCellIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = MeHomePageController.init(style:.plain)
        if let uid = User.uid() {
            vc.uid = uid
        }
        self.navigationController?.pushViewController(vc, animated: true)

    }
}
