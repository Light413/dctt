//
//  TTImagePicker.swift
//  DCTT
//
//  Created by wyg on 2018/9/12.
//  Copyright © 2018年 Light.W. All rights reserved.
//

import UIKit
import Photos

class TTImagePicker: NSObject {
    ///当前所属控制器
    weak var viewController:UIViewController?
    
    ///能够选择的最大个数
    var maxImageNumber:Int = 0
    
    ///通知观察者选择完成
    let selectedCompletionNotificationName = NSNotification.Name.init(rawValue: "selectedCompletionNotificationName")
    
    override init() {
        super.init()
        
        ///监听预览图片选择完成事件
        NotificationCenter.default.addObserver(self, selector: #selector(selectImageCompletionNotification(_ :)), name: NSNotification.Name (rawValue: "notification_selectedimage_completion"), object: nil)

    }
    
    @objc func selectImageCompletionNotification(_ noti:Notification)  {
        self.presentViewController.dismiss(animated: true, completion: nil)
        
        print("notification_selectedimage_completion")
        
        ////通知选择完成
        NotificationCenter.default.post(name:selectedCompletionNotificationName, object: nil, userInfo: noti.userInfo)

    }
    
    
    //MARK: -
    func show() {
        let alertViewContronller = UIAlertController.init(title: "添加照片", message: nil, preferredStyle: .actionSheet)
        let action1 = UIAlertAction.init(title: "从相册选择", style: .default, handler: { [weak self] (action) in
            guard let strongSelf = self else {return}
            strongSelf.showPhotoLibriary()
        })
        
        let action2 = UIAlertAction.init(title: "拍照", style: .default, handler: { [weak self] (action) in
            guard let strongSelf = self else {return}
            strongSelf.showCamera()
        })
        
        let action3 = UIAlertAction.init(title: "取消", style: .cancel, handler: nil)
        
        alertViewContronller.addAction(action1)
        alertViewContronller.addAction(action2)
        alertViewContronller.addAction(action3)
        
        viewController?.navigationController?.present(alertViewContronller, animated: true, completion: nil)
    }
    
    
    var presentViewController:UIViewController!
    
    func showPhotoLibriary()  {
        guard PHPhotoLibrary.authorizationStatus() == .authorized else {
            PHPhotoLibrary.requestAuthorization { [weak self](status) in
                guard let ss = self else {return}
                
                DispatchQueue.main.async {
                    if status == PHAuthorizationStatus.authorized {
                        print("Allow");
                        ss._showTTImagePickerViewController()
                    }else {
                        HUD.showText("请在系统设置中允许访问相册", view: UIApplication.shared.keyWindow!)
                        print("Not Allow");
                    }
                }
            }; return
        }
        

        _showTTImagePickerViewController();
    }

    func _showTTImagePickerViewController() {
        let vc = TTImagePickerViewController()
        //最大选择数
        vc.maxImagesNumber = maxImageNumber
        
        vc.imageSelectedCompletionHandler = {[weak self]  images in
            guard let strongSelf = self else {
                return
            }
            
            
            //strongSelf.presentViewController.dismiss(animated: true, completion: nil)
            NotificationCenter.default.post(name: strongSelf.selectedCompletionNotificationName, object: nil, userInfo: ["images":images])
        }
        
        presentViewController = UINavigationController(rootViewController:vc)
        viewController?.navigationController?.present(presentViewController, animated: true, completion: nil)
    }
    
    
    func showCamera() {
        let vc = UIImagePickerController.init()
        vc.delegate = self
        vc.allowsEditing = true
        
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
        
        
        viewController?.navigationController?.present(vc, animated: true, completion: nil)
        
    }
    
}


extension TTImagePicker:UIImagePickerControllerDelegate ,UINavigationControllerDelegate{

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
// Local variable inserted by Swift 4.2 migrator.
let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        if let img = info["UIImagePickerControllerOriginalImage"] as? UIImage {

            NotificationCenter.default.post(name: self.selectedCompletionNotificationName, object: nil, userInfo: ["images":[img]])
        }
        
        picker.dismiss(animated: true, completion: nil)
        
    }
    
}





// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromAVMediaType(_ input: AVMediaType) -> String {
	return input.rawValue
}
