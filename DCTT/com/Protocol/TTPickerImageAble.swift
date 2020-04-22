//
//  TTPickerImageAble.swift
//  DCTT
//
//  Created by gener on 2018/8/2.
//  Copyright © 2018年 Light.W. All rights reserved.
//
import UIKit
import Foundation
import AVFoundation

enum SourceType {
    case camera
    case photo
}

protocol TTPickerImageAble : UIImagePickerControllerDelegate ,UINavigationControllerDelegate{
}

extension TTPickerImageAble where Self : UIViewController {

    func show()  {
        let alertViewContronller = UIAlertController.init(title: "选择图片", message: nil, preferredStyle: .actionSheet)
        let action1 = UIAlertAction.init(title: "从相册选择", style: .default, handler: { [weak self] (action) in
            guard let strongSelf = self else {return}
            strongSelf.pickImageWithIndex(2)
        })
        
        let action2 = UIAlertAction.init(title: "拍照", style: .default, handler: { [weak self] (action) in
            guard let strongSelf = self else {return}
            strongSelf.pickImageWithIndex(1)
        })
        
        let action3 = UIAlertAction.init(title: "取消", style: .cancel, handler: nil)
        
        alertViewContronller.addAction(action1)
        alertViewContronller.addAction(action2)
        alertViewContronller.addAction(action3)
        
        self.navigationController?.present(alertViewContronller, animated: true, completion: nil)
    }
    
    private func pickImageWithIndex(_ index:Int) {
        let vc = UIImagePickerController.init()
        vc.delegate = self
        vc.allowsEditing = true
        
        switch index {
        case 1:
            guard UIImagePickerController.isSourceTypeAvailable(.camera) else {HUD.show(info: "NO Camera Available");return}
            guard AVCaptureDevice.authorizationStatus(for: AVMediaType(rawValue: convertFromAVMediaType(AVMediaType.video))) == .authorized else {
                AVCaptureDevice.requestAccess(for: AVMediaType(rawValue: convertFromAVMediaType(AVMediaType.video)), completionHandler: { (b) in
                    DispatchQueue.main.async {
                        if b {
                            print("Allow");
                        }else {
                            HUD.show(info: "Allow access to the camera in Settings");
                            print("Not Allow");
                        }
                    }
                }); return
            }
            
            vc.sourceType = .camera
            break
        case 2: vc.sourceType = .photoLibrary;break
        default:break
        }
        
        self.navigationController?.present(vc, animated: true, completion: nil)
    }
    
    
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromAVMediaType(_ input: AVMediaType) -> String {
	return input.rawValue
}
