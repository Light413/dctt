//
//  AddButtonItemProtocol.swift
//  DCTT
//
//  Created by wyg on 2018/9/13.
//  Copyright © 2018年 Light.W. All rights reserved.
//

import Foundation

protocol AddButtonItemProtocol {}
extension AddButtonItemProtocol {
    
    func getBarButtonItem(title : String , action : Selector) -> UIBarButtonItem{
        let rightbtn = UIButton (frame: CGRect (x: 0, y: 0, width: 60, height: 30))
        rightbtn.setTitle(title, for: .normal)
        rightbtn.setTitleColor(UIColor.darkGray , for: .normal)
        rightbtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        rightbtn.addTarget(self, action: action , for: .touchUpInside)
        let rightitem = UIBarButtonItem.init(customView: rightbtn)
        
        return rightitem
    }
    
}
