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
//数据源更新状态
enum DSStatus:Int{
    case wait_update    = 1
    case downloading    = 2
    case will_unzip     = 3
    case unzipping      = 4
    case will_update    = 5
    case completed      = 6
    
}

//Notification
let knotification_airplane_changed = Notification.Name(rawValue: "knotification_airplane_changed")
let knotification_publication_changed = Notification.Name(rawValue: "knotification_publication_changed")
let knotification_segment_changed = Notification.Name(rawValue: "knotification_segment_changed")

//
var kUnzipprogress: UIProgressView!
var kUnzipProgressStatus:Float = 0.0


///PATH
/*
 "/var/mobile/Containers/Data/Application/E2F03F14-9FA2-415A-87F6-E46B68A03E2A/Library/TDLibrary
 /CCA/
 CCAA320CCAAIPC20161101/aipc"
 */
let DocumentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]

let LibraryPath = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)[0]
let ROOTPATH = LibraryPath.appending("/TDLibrary")
let HTMLPATH = LibraryPath.appending("/HTML")
let ROOTSUBPATH = "/CCA/" //待确定唯一性?

let PATH = ROOTPATH + ROOTSUBPATH

//sub
let APLISTJSONPATH = "/resources/apList.json"
let APMODELMAPJSPATH = ROOTPATH + ROOTSUBPATH + "apModelMap.js"//与MSN字段关联飞机手册


//dataSource
var kDataSourceLocations = [String]()
let kpackage_info = "package_info.json"
let ksync_manifest = "sync_manifest.json"
let ktdafactorymobilebaseline = "tdafactorymobilebaseline.json"


///////////
#if !DEBUG
    public func print(_ items: Any...) {
    }

#endif





