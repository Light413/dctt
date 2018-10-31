//
//  HomeListBaseCell.swift
//  DCTT
//
//  Created by wyg on 2018/9/19.
//  Copyright © 2018年 Light.W. All rights reserved.
//

import UIKit

class HomeListBaseCell: UITableViewCell ,DisLikeButtonStyle{

    ///sy,life
    var type:String?
    
    func fill(_ d:[String:Any]) {}
    
    ///点击不喜欢处理操作
    var dislikeBlock:(() -> Void)?
    
}
