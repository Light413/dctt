//
//  themeColor.swift
//  Toolbox
//
//  Created by gener on 17/9/20.
//  Copyright © 2017年 Light. All rights reserved.
//

import Foundation
import UIKit

func UIColorFromHex(rgbValue: UInt) -> UIColor {
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}

//common
let kTableview_headView_bgColor = UIColorFromHex(rgbValue: 0x8bb9fc)
let h5_theme_color = UIColorFromHex(rgbValue: 0xff4500)

//Airplane
let kAirplaneCell_head_normal_color = UIColorFromHex(rgbValue: 0x333333)
let kAirplaneCell_subhead_normal_color = UIColorFromHex(rgbValue: 0x666666)
let kAirplaneCell_head_selected_color = UIColorFromHex(rgbValue: 0x2765c8)
let kAirplaneSubCell_bg_color = UIColorFromHex(rgbValue: 0xf1f1f2)
let kAirplaneSubCell_text_color = UIColorFromHex(rgbValue: 0x666666)

///中国红
let tt_BarColor = UIColor (red: 212/255.0, green: 61/255.0, blue: 61/255.0, alpha: 1)

///灵宝绿
//let tt_HomeBarColor = UIColor (red: 46/255.0, green: 182/255.0, blue: 106/255.0, alpha: 1)
//let tt_HomeBarColor =  UIColor (red: 251/255.0, green:  58/255.0, blue:  47/255.0, alpha: 1)
let tt_HomeBarColor =  UIColor (red: 246/255.0, green:  132/255.0, blue:  60/255.0, alpha: 1)

let tt_defafault_barColor = UIColor (red: 250/255.0, green: 251/255.0, blue: 253/255.0, alpha: 1)

////...
let tt_themeColor = UIColor (red: 250/255.0, green: 110/255.0, blue: 12/255.0, alpha: 1)

let tt_bg_color =  UIColor.init(red:244/255.0, green: 245/255.0, blue: 247/255.0, alpha: 1)

let kButtonTitleColor = UIColor (red: 236/255.0, green: 82/255.0, blue: 82/255.0, alpha: 1)





