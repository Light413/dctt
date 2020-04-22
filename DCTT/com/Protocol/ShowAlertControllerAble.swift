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
    
    func showMsg( _ msg:String , title:String , handler:@escaping (() -> Void)) {
        
        let vc = UIAlertController.init(title: "提示",message: msg, preferredStyle: .alert)
        let action = UIAlertAction.init(title:"取消", style: .default)
        let action2 = UIAlertAction.init(title: title, style: .destructive) { (action) in
            handler();
        }
        
        vc.addAction(action)
        vc.addAction(action2)
        self.navigationController?.present(vc, animated: true, completion: nil);
        
    }

    
    ///发布之前弹框提示
    func showTipsBeforePublish() {
        /*let vc = UIAlertController.init(title: "发布须知",message: "\n1.发布内容前请确保已经认真阅读并同意用户协议及服务条款,在[我的-设置-关于我们]中查看完整内容。\n\n2.请发布优质、真实有效信息。若发现虚假、无效、充满负能量的等消极内容会被立即删除，严重者封号处理。", preferredStyle: .alert)
        let action = UIAlertAction.init(title:"不同意", style: .cancel){[weak self] (action) in
            guard let ss  = self else {return}
            ss.dismiss(animated: true, completion: nil)
        }
        
        action.setValue(UIColor.lightGray, forKey: "titleTextColor")
        
        let action2 = UIAlertAction.init(title: "悉知并同意", style: .default)
        
        
        vc.addAction(action)
        vc.addAction(action2)
        self.navigationController?.present(vc, animated: true, completion: nil);*/
    }
    
}
