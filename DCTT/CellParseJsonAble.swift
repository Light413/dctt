//
//  CellParseJsonAble.swift
//  DCTT
//
//  Created by wyg on 2018/9/19.
//  Copyright © 2018年 Light.W. All rights reserved.
//

import Foundation
protocol CellParseJsonAble {
    func fill(_ dic:[String:Any])
    func isHasNewLine(_ s:String) -> String
    
}

extension CellParseJsonAble {
    func objectFrom(_ jsonStr:String) -> [String:Any]? {
        let cc = jsonStr.replacingOccurrences(of: "\n", with: "&&")
        do{
            let jsonObject = try JSONSerialization.jsonObject(with: cc.data(using: String.Encoding.utf8)!, options: JSONSerialization.ReadingOptions.allowFragments)
            let obj = jsonObject as? [String:Any]
            return obj
            
        }catch {
           return nil
        }

    }
}

extension CellParseJsonAble {
    ///检测是否换行,对应解析操作
    func isHasNewLine(_ s:String) -> String {
        let _s = s.replacingOccurrences(of: "&&", with: "\n")
        return _s;
    }
    
}

extension ServerBaseCell:CellParseJsonAble{}

