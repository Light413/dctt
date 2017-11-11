//
//  HUD.swift
//  Toolbox
//
//  Created by gener on 17/7/31.
//  Copyright © 2017年 Light. All rights reserved.
//

import UIKit
import SVProgressHUD

class HUD: NSObject {

    static func config(){
        SVProgressHUD.setBackgroundColor(UIColor.black)
        SVProgressHUD.setForegroundColor(UIColor.white)
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.setDefaultAnimationType(SVProgressHUDAnimationType.native)
        SVProgressHUD.setMinimumDismissTimeInterval(1)
        SVProgressHUD.setSuccessImage(UIImage(named: "success"))
        SVProgressHUD.setErrorImage(UIImage(named: "error"))
    }
    
    
   static func show() {
        SVProgressHUD.show()
    }
    
    static func show(withStatus str:String) {
        SVProgressHUD.show(withStatus: str)
    }

    static func show(info str:String){
        SVProgressHUD.showInfo(withStatus: str)
    }
    
    static func show(successInfo str:String){
        SVProgressHUD.showSuccess(withStatus: str)
    }
    
    
    static func showProgress(progress:Float,status:String) {
        SVProgressHUD.showProgress(progress, status:status )
    }
    
    
    
    static func dismiss() {
        SVProgressHUD.dismiss()
    }
    
    
    
}
