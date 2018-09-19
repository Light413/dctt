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
}

extension CellParseJsonAble {
    func objectFrom(_ jsonStr:String) -> [String:Any]? {
        
        do{
            let jsonObject = try JSONSerialization.jsonObject(with: jsonStr.data(using: String.Encoding.utf8)!, options: JSONSerialization.ReadingOptions.allowFragments)
            let obj = jsonObject as! [String:String]
            return obj
            
        }catch {
           return nil
        }

    }
   
}

extension ServerBaseCell:CellParseJsonAble{}

