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
let kCurrentScreenWidth = UIScreen.main.bounds.width
let kCurrentScreenHeight = UIScreen.main.bounds.height
var APP_IS_BACKGROUND:Bool = false //app是否处于后台

//let BASE_URL = "http://192.168.1.104:80/tt/"
let BASE_URL = "http://39.106.164.101:80/tt/"
let home_list_url = "getPostList.php"
let publish_url = "publish.php"
let register_url = "register.php"
let login_url = "login.php"
let update_profile_url = "updateProfile.php"

let comment_url = "comment.php"
let post_detail_url = "detail.php"
let get_sc_url = "getsc.php"
let fans_url = "fan.php"
let delete_sc_url = "deletesc.php"

///html
let user_agreement_url = "userAgreement.html"
let aboutus_url = "aboutus.html"
let contactus_url = "contactus.html"
let disclaimer_url = "disclaimer.html"
let usehelp_url = "usehelp.html"

///
let Loading = {HUD.show()}
let Loadingwith:((String)->()) = {str in
    HUD.show(withStatus:str)
}

let Dismiss = {HUD.dismiss()}


//MARK: - 全局变量
//Notification


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

///类型信息，与plist 对应
let kPublishTypeInfo = [
    "6":"话题",
    "10":"新鲜事",
    "11":"朋友圈",
    "12":"提问",
    "13":"段子",
    "20":"吃喝玩乐",
    "21":"求职招聘",
    "22":"商家主页",
    "23":"相亲交友",
    "24":"房屋信息",
    "25":"打车出行",
    "26":"二手交易",
    "27":"便民信息",
//    "211":"母婴亲子",
//    "212":"3C数码",
//    "213":"家居装饰",
//    "214":"快递物流",
//    "215":"其他",

]

///信息类别
let kCategory_home = "sy" //首页
let kCategory_zt = "zt" //专题
let kCategory_life = "life"//生活服务

var kPublish_type_title:String!


//////TEST
var user_has_logined = User.isLogined()

var kchildViewCanScroll:Bool = false




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


///提示登录
let kPleaseToLogin = "请登录后操作!"

///发布新动态成功通知
let kHasPublishedSuccessNotification = NSNotification.Name.init("kHasPublishedSuccessNotification")




