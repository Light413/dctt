//
//  MeHomeSuperCell.swift
//  DCTT
//
//  Created by wyg on 2018/8/8.
//  Copyright © 2018年 Light.W. All rights reserved.
//

import UIKit

class MeHomeSuperCell: UITableViewCell {

    @IBOutlet weak var tableview: UITableView!
    
    var canScroll:Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tableview.delegate = self
        tableview.dataSource = self
        tableview.tableFooterView = UIView()
        tableview.register(UINib (nibName: "MeHomeCell", bundle: nil), forCellReuseIdentifier: "MeHomeCellIdentifier")
        tableview.estimatedRowHeight = 80;
        tableview.rowHeight = UITableView.automaticDimension
        tableview.showsVerticalScrollIndicator = false;
        
        NotificationCenter.default.addObserver(self, selector: #selector(noti(_ :)), name: NSNotification.Name (rawValue: "childCanScrollNotification"), object: nil)
    }

    @objc func noti(_ noti:NSNotification) {
        canScroll = true
        print("child can")
    }
    
}

extension MeHomeSuperCell:UITableViewDataSource,UITableViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !canScroll {
           scrollView.contentOffset = CGPoint.zero
        }
        
        if scrollView.contentOffset.y <= 0 {
            if canScroll {
                canScroll = false
                NotificationCenter.default.post(name: NSNotification.Name (rawValue: "superCanScrollNotification"), object: nil)

            }
        }
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier :String = "MeHomeCellIdentifier"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        
        cell.selectionStyle = .none

        return cell

    }
    
}



