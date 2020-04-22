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
    
    ///只有文字
    func getBarButtonItem(title : String , action : Selector) -> UIBarButtonItem{

        return _getBarButtonItem(title: title, image: nil, action: action)
    }
    
    ///只有图片
    func getBarButtonItem(image : UIImage , action : Selector) -> UIBarButtonItem{
        
        return _getBarButtonItem(title: nil, image: image, action: action)
    }
    
    
    private func _getBarButtonItem(title : String? = nil , image:UIImage? = nil , action : Selector) -> UIBarButtonItem{
        let rightbtn = UIButton (frame: CGRect (x: 0, y: 0, width: 60, height: 30))
        rightbtn.setTitle(title, for: .normal)
        rightbtn.setTitleColor(UIColor.darkGray , for: .normal)
        rightbtn.setImage(image, for: .normal)
        rightbtn.imageEdgeInsets = UIEdgeInsets.init(top: 5, left: 30, bottom: 5, right: 10)
        
        rightbtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        rightbtn.addTarget(self, action: action , for: .touchUpInside)
        
        
        let rightitem = UIBarButtonItem.init(customView: rightbtn)
        
        return rightitem
    }
}
