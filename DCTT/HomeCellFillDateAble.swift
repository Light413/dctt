//
//  HomeCellFillDateAble.swift
//  DCTT
//
//  Created by wyg on 2018/8/24.
//  Copyright © 2018年 Light.W. All rights reserved.
//

import Foundation

protocol HomeCellFillDateAble {}

extension HomeCellFillDateAble {
    func fillData(msg content:UILabel , user name:UILabel , date:UILabel , data d:[String:Any]){
        content.text = String.isNullOrEmpty(d["content"])
        
        if let u_info = d["user"] as? [String:Any]  {
            var s = ""
            let _name = String.isNullOrEmpty(u_info["name"]);
            if _name.lengthOfBytes(using: String.Encoding.utf8) > 0  {
                s = _name;
            }
            else
                if let name = u_info["nickName"] as? String {
                    s = name;
            }
            
            name.text = s
            
            date.text = Date.dateFormatterWithString(String.isNullOrEmpty(d["postDate"]))
            
            
        }
    }
    
}

extension HomeCell:HomeCellFillDateAble{}
extension HomeCellWithImage:HomeCellFillDateAble{}
extension HomeCellWithImages:HomeCellFillDateAble{}



