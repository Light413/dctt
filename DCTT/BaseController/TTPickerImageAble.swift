//
//  TTPickerImageAble.swift
//  DCTT
//
//  Created by gener on 2018/8/2.
//  Copyright © 2018年 Light.W. All rights reserved.
//

import Foundation

protocol TTPickerImageAble {
    var selectedImage:UIImage? {get set}
}

extension TTPickerImageAble where Self : UIViewController {

    func show()  {
        let alertViewContronller = UIAlertController.init(title: "添加照片", message: nil, preferredStyle: .actionSheet)
        let action1 = UIAlertAction.init(title: "从相册选择", style: .default, handler: { [weak self] (action) in
            guard let strongSelf = self else {return}
            //strongSelf.showImagePicker()
            })
        
        let action2 = UIAlertAction.init(title: "拍照", style: .default, handler: { (action) in
            
        })
        
        let action3 = UIAlertAction.init(title: "取消", style: .cancel, handler: nil)
        
        alertViewContronller.addAction(action1)
        alertViewContronller.addAction(action2)
        alertViewContronller.addAction(action3)
        
        self.navigationController?.present(alertViewContronller, animated: true, completion: nil)

    }
    
    
    
}
