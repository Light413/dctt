//
//  constant.swift
//  Toolbox
//
//  Created by gener on 17/6/26.
//  Copyright © 2017年 Light. All rights reserved.
//

import Foundation
import UIKit

let kBartintColor =  UIColor (red: 54/255.0, green:  54/255.0, blue:  54/255.0, alpha: 1)
//let kTableviewHeadViewBgColor = UIColor(red: 84/255.0, green:  150/255.0, blue:  194/255.0, alpha: 1)

let kTableviewBackgroundColor = UIColor.init(colorLiteralRed: 231/255.0, green: 231/255.0, blue: 231/255.0, alpha: 1)
let kCellDefaultBgColor = UIColor (red: 236/255.0, green: 236/255.0, blue: 236/255.0, alpha: 1)
let kCellSelectedBgColor = UIColor.white
let kDOCTYPEColor:[String:UIColor] = ["AIPC":UIColor(red: 255/255.0, green:  227/255.0, blue:  30/255.0, alpha: 1),
                                      "AMM":UIColor(red: 169/255.0, green:  67/255.0, blue:  85/255.0, alpha: 1),
                                      "TSM":UIColor(red: 146/255.0, green:  154/255.0, blue:  158/255.0, alpha: 1),]

let kCurrentScreenWidth = UIScreen.main.bounds.width
let kCurrentScreenHeight = UIScreen.main.bounds.height

var APP_IS_BACKGROUND:Bool = false //app是否处于后台

//MARK: -
let RootControllerChangeWithIndex:((Int) -> Void) = {index in
    let root = UIApplication.shared.keyWindow?.rootViewController as! BaseTabbarController
    root.selectedIndex = index
}
let ktabbarVCIndex:Int = (UIApplication.shared.keyWindow?.rootViewController as! BaseTabbarController).selectedIndex

let Loading = {HUD.show()}
let Loadingwith:((String)->()) = {str in
    HUD.show(withStatus:str)
}

let Dismiss = {HUD.dismiss()}


//MARK: - 全局变量
//Notification
let knotification_airplane_changed = Notification.Name(rawValue: "knotification_airplane_changed")
let knotification_publication_changed = Notification.Name(rawValue: "knotification_publication_changed")
let knotification_segment_changed = Notification.Name(rawValue: "knotification_segment_changed")

///////////
#if !DEBUG
    public func print(_ items: Any...) {
    }

#endif

enum ImageCellTpye {
    case album
    
    case preview

    case publish
}

let kPublishTypeTitle = [
    "10":"新鲜事",
    "11":"朋友圈",
    "12":"提问",
    "13":"段子",
    "20":"最新活动",
    "21":"商家黄页",
    "22":"吃喝玩乐",
    "23":"相亲交友",
    "24":"求职招聘",
    "25":"房屋信息",
    "26":"打车出行",
    "27":"打听个事",
    "28":"吐槽曝光",
    "29":"二手交易",
    "210":"摄影婚庆",
    "211":"母婴亲子",
    "212":"3C数码",
    "213":"家居装饰",
    "214":"快递物流",
    "215":"其他",

]

var kPublish_type_title:String!
var kPublish_type_info:[String:String]!


//////TEST
let test_is_login = true






//MARK: - methods
public func imgWithColor(_ color:UIColor) -> UIImage? {
    let ret = CGRect (x: 0, y: 0, width: 1, height: 1)
    
    UIGraphicsBeginImageContext(ret.size)
    
    let ctx = UIGraphicsGetCurrentContext()
    
    ctx?.setFillColor(color.cgColor)
    
    ctx?.fill(ret)
    
    let ig = UIGraphicsGetImageFromCurrentImageContext()
    
    UIGraphicsEndImageContext()
    
    return ig
    
}






