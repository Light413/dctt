//
//  UIImage+TT.swift
//  DCTT
//
//  Created by wyg on 2021/9/21.
//  Copyright © 2021 Light.W. All rights reserved.
//

import Foundation
extension UIImage {
    ///根据颜色生成图片
    func imageWithColor(_ color:UIColor) -> UIImage? {
        let rect = CGRect (x: 0, y: 0, width: 1, height: 0.5)
        UIGraphicsBeginImageContext(rect.size)
        let ctx = UIGraphicsGetCurrentContext()
        ctx?.setFillColor(color.cgColor)
        ctx?.fill(rect)
        
        let ig = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return ig
    }
    
}
