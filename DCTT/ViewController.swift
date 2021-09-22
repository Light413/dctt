//
//  ViewController.swift
//  DCTT
//
//  Created by wyg on 2017/11/11.
//  Copyright © 2017年 Light.W. All rights reserved.
//

import UIKit
import SkeletonView
class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, SkeletonTableViewDataSource ,SkeletonTableViewDelegate{
    var tableView:UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        view.backgroundColor  = UIColor.blue
        let igv = UIImageView.init(frame: CGRect (x: 100, y: 100, width: 200, height: 200));
//        igv.backgroundColor = UIColor.red
        
        igv.isSkeletonable = true;
//        igv.showAnimatedGradientSkeleton()
//        self.view.addSubview(igv);
        
        tableView = UITableView.init(frame: CGRect (x: 0, y: 0, width: kCurrentScreenWidth, height: kCurrentScreenHeight), style: .grouped);
        tableView.delegate = self;
        tableView.dataSource = self;
        
        tableView.isSkeletonable = true;
        
        tableView.register(UINib (nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "HomeCellWithImageIdentifierId")
        self.view.addSubview(tableView);
        tableView.tableHeaderView = UIView(frame: CGRect (x: 0, y: 0, width: 1, height: 0.001));
        tableView.tableFooterView = UIView()
        tableView.sectionHeaderHeight = 0.01
        tableView.estimatedRowHeight = 180;
        tableView.rowHeight = UITableView.automaticDimension;
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        let animate = SkeletonAnimationBuilder().makeSlidingAnimation(withDirection: .leftRight);
        let gradient = SkeletonGradient(baseColor: UIColorFromHex(rgbValue: 0xE6E6E6))
        
        tableView.showAnimatedGradientSkeleton(usingGradient: gradient, animation: animate)

    }
    
    ///--MARK
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "HomeCellWithImageIdentifierId"
    }
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0;
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "HomeCellWithImageIdentifierId", for: indexPath);
        
        return cell;
    }
    
    
    
}

