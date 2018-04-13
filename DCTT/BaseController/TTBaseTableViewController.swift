//
//  TTBaseTableViewController.swift
//  DCTT
//
//  Created by wyg on 2018/4/13.
//  Copyright © 2018年 Light.W. All rights reserved.
//

import UIKit

class TTBaseTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        tableView.showsVerticalScrollIndicator = false
    }

    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        tableView.showsVerticalScrollIndicator = true
    }
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        tableView.showsVerticalScrollIndicator = false
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

 

}
