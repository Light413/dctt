//
//  MeHomeCell2.swift
//  DCTT
//
//  Created by wyg on 2018/8/9.
//  Copyright © 2018年 Light.W. All rights reserved.
//

import UIKit

class MeHomeCell2: UITableViewCell {

    var superVC:UIViewController?
    var pagevc:TTPageViewController!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        ////pagevc
        var vcArr = [UIViewController]()
        
        for _ in 0..<2 {
            let v = HomerListViewControllerTest2();
            //v.view.frame =  CGRect (x: 0, y: 0, width: kCurrentScreenWidth, height: _h - 49)
            vcArr.append(v)
        }
        
        let rec = CGRect (x: 0, y: 0, width: self.frame.width, height:self.frame.height)
         pagevc = TTPageViewController(controllers:vcArr, frame: rec, delegate:nil)
        
//        self.superVC?.addChildViewController(pagevc)
        self.addSubview(pagevc.view)

    }
    
    func add() {
        self.superVC?.addChildViewController(pagevc)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
