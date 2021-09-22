//
//  String+TT.swift
//  DCTT
//
//  Created by wyg on 2021/9/21.
//  Copyright © 2021 Light.W. All rights reserved.
//

import Foundation
extension String {
    ///计算字符串所需size
   public func textSizeWithConstraint(_ size:CGSize , font:UIFont) -> CGSize {
        let size = self.boundingRect(with: size,options: .usesLineFragmentOrigin,attributes: [NSAttributedString.Key.font:font],  context: nil ).size;
        return size;
    }
}
