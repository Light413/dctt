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
        let type = String.isNullOrEmpty(d["type"])
        switch type {
        case "6","21","22","23","24","25"://生活服务类信息
            let cc = String.isNullOrEmpty(d["content"])
            do{
                let jsonObject = try JSONSerialization.jsonObject(with: cc.data(using: String.Encoding.utf8)!, options: JSONSerialization.ReadingOptions.allowFragments)
                let obj = jsonObject as! [String:String]
                content.text = String.isNullOrEmpty(obj["content"])

            }catch {
                
            }
            
            break
            
        default:content.text = String.isNullOrEmpty(d["content"]); break
        }

        
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



