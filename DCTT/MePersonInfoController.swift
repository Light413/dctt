//
//  MePersonInfoController.swift
//  DCTT
//
//  Created by wyg on 2018/3/11.
//  Copyright © 2018年 Light.W. All rights reserved.
//

import UIKit
import Photos

class MePersonInfoController: MeBaseTableViewController {

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var sex: UILabel!
    @IBOutlet weak var age: UILabel!
    @IBOutlet weak var city: UILabel!
    
    @IBOutlet weak var mark: UITextView!
    @IBOutlet weak var msg: UILabel!
    
    
    
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
    
    
    
    func showCarema(_ index:Int) {
        let vc = UIImagePickerController.init()
        vc.delegate = self
        vc.allowsEditing = true

        switch index {
        case 1:
            guard UIImagePickerController.isSourceTypeAvailable(.camera) else {HUD.show(info: "NO Camera Available");return}
            guard AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo) == .authorized else {
                AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo, completionHandler: { (b) in
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
        case 2:
            vc.sourceType = .photoLibrary
            break
        default:break
        }

        
        
        self.navigationController?.present(vc, animated: true, completion: nil)
        
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableHeaderView = UIView (frame: CGRect (x: 0, y: 0, width: 10, height: 20))
        
        self.navigationItem.rightBarButtonItem = rightNavigationItem()
        
//        if let btn = self.navigationItem.leftBarButtonItem?.customView as? UIButton {
//            let sel = btn.actions(forTarget: self.navigationController, forControlEvent: .touchUpInside);
//            
//        }
        
    }

    func rightNavigationItem() -> UIBarButtonItem{
        let rightbtn = UIButton (frame: CGRect (x: 0, y: 0, width: 30, height: 30))
        rightbtn.setTitle("保存", for: .normal)
        rightbtn.setTitleColor(UIColor.darkGray , for: .normal)
        rightbtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        rightbtn.addTarget(self, action: #selector(previewAction), for: .touchUpInside)
        let rightitem = UIBarButtonItem.init(customView: rightbtn)
        
        return rightitem
    }
    
    func previewAction()  {
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

}



extension MePersonInfoController:UIImagePickerControllerDelegate ,UINavigationControllerDelegate{
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let img = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            icon.image = img
        }
        
        picker.dismiss(animated: true, completion: nil)
        
    }
    
}



