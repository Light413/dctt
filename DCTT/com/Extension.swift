//
//  Extension.swift
//  Toolbox
//
//  Created by gener on 17/10/26.
//  Copyright © 2017年 Light. All rights reserved.
//

import Foundation

extension Date {

    //MARK:
   /// Date类型返回字符串
   ///
   /// - parameter date:          date
   /// - parameter withFormatter: 格式化字符串
   ///
   /// - returns:格式化后的字符串
   public static func stringFromDate(_ date:Date ,withFormatter:String) -> String {
        //"yyyy-MM-dd HH:mm"
        let formatter = DateFormatter.init()
        formatter.dateFormat = withFormatter
        return formatter.string(from: date)
    }
    
   /// 字符串转Date类型
   ///
   /// - parameter str:           日期字符串
   /// - parameter withFormatter: 格式化
   ///
   /// - returns: date
   public static func dateFromString(_ str:String ,withFormatter:String) -> Date? {
        let formatter = DateFormatter.init()
        formatter.timeZone = TimeZone.init(secondsFromGMT: 8);
        formatter.dateFormat = withFormatter
        return formatter.date(from: str)
    }



}
