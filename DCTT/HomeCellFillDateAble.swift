//
//  HomeCellFillDateAble.swift
//  DCTT
//
//  Created by wyg on 2018/8/24.
//  Copyright © 2018年 Light.W. All rights reserved.
//

import Foundation

@objc protocol HomeCellFillDateAble {
    ///内容类型
    @objc optional var category:String? {get}
}

extension HomeCellFillDateAble {
    func fillData(msg content:UILabel , user name:UILabel , date:UILabel , data d:[String:Any]){
        let type = String.isNullOrEmpty(d["type"])
        
        switch type {
        case "6","21","22","23","24","25"://专题、生活服务类信息
            let cc = String.isNullOrEmpty(d["content"])
            do{
                let jsonObject = try JSONSerialization.jsonObject(with: cc.data(using: String.Encoding.utf8)!, options: JSONSerialization.ReadingOptions.allowFragments)
                let obj = jsonObject as! [String:String]
                
                var sj = ""
                if type == "22" {
                    sj = String.isNullOrEmpty(obj["name"])
                }
                
                if type == "6" {//专题直接显示
                   content.text = sj + String.isNullOrEmpty(obj["content"])
                }else{
                    let s = sj + String.isNullOrEmpty(obj["content"])
                    if let attri = _attributeString(s, type: type) {
                        content.attributedText = attri
                    }else{
                        content.text = s;
                    }
                }

            }catch {}
            
            break
        case "20" , "26" , "27":
            let s = String.isNullOrEmpty(d["content"])
            if let attri = _attributeString(s, type: type) {
                content.attributedText = attri
            }else{
                content.text = s;
            }
            
            break
            
        default:content.text = String.isNullOrEmpty(d["content"]); break
        }

        ///用户info
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
    
    
    func _attributeString(_ s:String , type:String) -> NSAttributedString? {
        let shade = NSShadow.init()
        shade.shadowBlurRadius = 5
        //shade.shadowColor = UIColor.lightGray.cgColor
        
        let attributes = [NSForegroundColorAttributeName:UIColor.white,
                          NSBackgroundColorAttributeName:UIColorFromHex(rgbValue: 0xE92D13),
                          NSFontAttributeName:UIFont.systemFont(ofSize: 13),
                          //NSShadowAttributeName:shade
                          ]
        let headTitle = String.isNullOrEmpty(kPublishTypeInfo[type]) + " "
        let des = headTitle + s;
        
        let attri = NSMutableAttributedString.init(string: des)
        attri.addAttributes(attributes, range: NSRange.init(location: 0, length: 4))
        return (String.isNullOrEmpty(category ?? "") == "life") ? nil : attri
    }
    
}

extension HomeListBaseCell:HomeCellFillDateAble {
    var category: String? {
        return type
    }
}



