//
//  HomeCellFillDateAble.swift
//  DCTT
//
//  Created by wyg on 2018/8/24.
//  Copyright © 2018年 Light.W. All rights reserved.
//

import Foundation
//import SwiftyJSON
@objc protocol HomeCellFillDateAble {
    ///内容类型
    @objc optional var category:String? {get}
}

extension HomeCellFillDateAble {
    func fillData(msg content:UILabel , user name:UILabel , date:UILabel , data d:[String:Any]){
        let type = String.isNullOrEmpty(d["type"])
        
        switch type {
        case "6","21","22","23","24","25" , "20" , "26" , "27"://专题、生活服务类信息
            var cc = String.isNullOrEmpty(d["content"])
            cc = cc.replacingOccurrences(of: "\n", with: " ")
            
            do{
                
                let jsonObject = try JSONSerialization.jsonObject(with: cc.data(using: String.Encoding.utf8)!, options: JSONSerialization.ReadingOptions.allowFragments)
                let obj = jsonObject as! [String:Any]
                
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

            }catch {
                print(error.localizedDescription)
            }; break
            
        default:
            var ss = String.isNullOrEmpty(d["content"]);
            ss = ss.replacingOccurrences(of: "\n", with: " ")
            //content.attributedText = _formatter(String.isNullOrEmpty(ss), type: nil);
            content.attributedText = _attributeString(ss, type: type);
            break
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
    
    func _formatter(_ s:String , type:String?) -> NSAttributedString?  {
        let paragraphStyle = NSMutableParagraphStyle.init()
        paragraphStyle.lineSpacing = 3
        paragraphStyle.lineBreakMode = .byCharWrapping
        //paragraphStyle.firstLineHeadIndent = 0
        
        let attributes = [//NSForegroundColorAttributeName:UIColor.white,
                          //NSBackgroundColorAttributeName: tt_themeColor,//tt_HomeBarColor
            //NSFontAttributeName:UIFont.systemFont(ofSize: 14),
            convertFromNSAttributedStringKey(NSAttributedString.Key.paragraphStyle):paragraphStyle,
        ]

        let attri = NSMutableAttributedString.init(string: s, attributes: convertToOptionalNSAttributedStringKeyDictionary(attributes))
        return  attri

    }
    
    ///生活服务分类特殊显示
    func _attributeString(_ s:String , type:String?) -> NSAttributedString? {
        
        return NSMutableAttributedString.init(string: s);
        
        
        let shade = NSShadow.init()
        shade.shadowBlurRadius = 5
        
        let paragraphStyle = NSMutableParagraphStyle.init()
         paragraphStyle.lineSpacing = 3
         paragraphStyle.lineBreakMode = .byCharWrapping
//        paragraphStyle.headIndent = 5
//        paragraphStyle.tailIndent = 5
         paragraphStyle.firstLineHeadIndent = 2
 
        let attributes = [convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor):UIColor.white,
                          convertFromNSAttributedStringKey(NSAttributedString.Key.backgroundColor): tt_themeColor,//tt_HomeBarColor
                          convertFromNSAttributedStringKey(NSAttributedString.Key.font):UIFont.systemFont(ofSize: 13),
                          convertFromNSAttributedStringKey(NSAttributedString.Key.paragraphStyle):paragraphStyle,
                          //NSShadowAttributeName:shade
                          ]
        
        var headTitle = "" , _len = 0;
        if let _type = type {
            headTitle = " " + String.isNullOrEmpty(kPublishTypeInfo[_type]) + " "
            _len = headTitle.count
        }
        
        let des = headTitle + " " + s;
        
        let attri = NSMutableAttributedString.init(string: des)
        attri.addAttributes(convertToNSAttributedStringKeyDictionary(attributes), range: NSRange.init(location: 0, length: _len))
        return (String.isNullOrEmpty(category ?? "") == "life") ? nil : attri
    }
    
}

extension HomeListBaseCell:HomeCellFillDateAble {
    var category: String? {
        return type
    }
}




// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
	return input.rawValue
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToNSAttributedStringKeyDictionary(_ input: [String: Any]) -> [NSAttributedString.Key: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}
