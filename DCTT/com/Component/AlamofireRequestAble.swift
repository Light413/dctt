//
//  AlamofireRequestAble.swift
//  DCTT
//
//  Created by wyg on 2018/8/1.
//  Copyright © 2018年 Light.W. All rights reserved.
//

import Foundation

protocol AlamofireRequestAble where Self : UIViewController {}

extension AlamofireRequestAble {
    
    func AlamofireRequest(_ url:String , parameter:[String:Any] , successHandler:(([String:Any]) -> Void)? = nil) {
        AlamofireHelper.post(url: url, parameters: parameter, successHandler: successHandler) {[weak self] (error) in
            HUD.dismiss()
            guard let ss = self else {return}
            if let err = error as NSError? {
                HUD.showText(err.domain, view: ss.view)
            }else{
                HUD.showText("服务器返回错误", view: ss.view)
            }
        }
    }
    
    
}


extension UIViewController:AlamofireRequestAble{}




