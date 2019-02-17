//
//  Extension.swift
//  Toolbox
//
//  Created by gener on 17/10/26.
//  Copyright © 2017年 Light. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa


extension UIButton{
    var ex_isEnabled:AnyObserver<Bool>{
        return UIBindingObserver(UIElement: self) { button, valid in
            button.isEnabled = valid
            button.setTitleColor(valid ? UIColor.red:UIColor.lightGray, for: .normal);
            }.asObserver()
    }
}

extension UIImageView {
    
    func setImage(path:URL)  {
        self.kf.setImage(with: path, placeholder: UIImage (named: "default_image2"), options: nil, progressBlock: nil, completionHandler:nil)

    }
    
}

extension String {
    static func isNullOrEmpty(_ any:Any?) -> String {
        guard  let s = any else {return ""}
        if s is NSNull {  return "";  }
        let val = "\(s)".replacingOccurrences(of: "<br/>", with: "")
        
        return val
    }

}


extension Date {
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


    /// 根据日期字符串转化为简短日期
    ///
    /// - parameter dateStr: eg"2018-08-23 14:10:00"
    ///
    /// - returns: 格式化后的日期
   public static func dateFormatterWithString(_ dateStr:String) -> String {
        let dateformatter  = DateFormatter.init();
        dateformatter.dateFormat = "yyyy-MM-dd HH:mm:SS"
        dateformatter.timeZone = TimeZone.current
        let date = dateformatter.date(from: dateStr)
        let sec = date?.timeIntervalSinceNow
        
        guard let s = sec , s < 0.0 else {return ""}
        let second = fabs(s)
        
        let mins = second / 60
        if mins < 1 {
            return "刚刚";
        }
        
        let hour = mins / 60
        if hour < 1 {
            let m = Int(mins) % 60
            return "\(m)分钟前"
        }
        
        let day = hour / 24
        if day < 1 {
            let h = Int(hour) % 24
            return "\(h)小时前"
        }
    
        dateformatter.dateFormat = "yyyy-MM-dd"
        return dateformatter.string(from: date!);
    
        /*
        let month = day / 30
        if month < 1 {
            let d = Int(day) % 30
            return "\(d)天前"
        }
        
        let year = month / 12
        if year < 1 {
            let m = Int(month) % 12
            return "\(m)个月前"
        }
        
        let y = Int(year)
        return "\(y)年前"*/
    }
}


