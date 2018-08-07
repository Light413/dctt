//
//  ShowAlertControllerAble.swift
//  mcs
//
//  Created by gener on 2018/7/5.
//  Copyright © 2018年 Light. All rights reserved.
//

import Foundation
import UIKit

protocol ShowAlertControllerAble {}

extension ShowAlertControllerAble where Self : UIViewController {
    
    func showMsg( _ msg:String , title:String , handler:@escaping ((Void) -> Void)) {
        
        let vc = UIAlertController.init(title: msg,message: nil, preferredStyle: .alert)
        let action = UIAlertAction.init(title:"Cancel", style: .default)
        let action2 = UIAlertAction.init(title: title, style: .destructive) { (action) in
            handler();
        }
        
        vc.addAction(action)
        vc.addAction(action2)
        self.navigationController?.present(vc, animated: true, completion: nil);
        
    }

    
}
