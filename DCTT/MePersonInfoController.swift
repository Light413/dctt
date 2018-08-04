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
    
    @IBOutlet weak var markCell: PubBaseTextViewCell!
    
    @IBOutlet weak var mark: UITextView!
    @IBOutlet weak var msg: UILabel!
    
    ///recent
    fileprivate var u_avatar_image:UIImage?
    fileprivate var u_sex:String?
    fileprivate var u_age:String?
    fileprivate var u_city:String?
    fileprivate var u_mark:String?
    
    //MARK: -
    func show()  {
        let alertViewContronller = UIAlertController.init(title: "添加照片", message: nil, preferredStyle: .actionSheet)
        let action1 = UIAlertAction.init(title: "从相册选择", style: .default, handler: { [weak self] (action) in
            guard let strongSelf = self else {return}
            strongSelf.selectPictureWithIndex(2)
            })
        
        let action2 = UIAlertAction.init(title: "拍照", style: .default, handler: { [weak self] (action) in
            guard let strongSelf = self else {return}
            strongSelf.selectPictureWithIndex(1)
        })
        
        let action3 = UIAlertAction.init(title: "取消", style: .cancel, handler: nil)
        
        alertViewContronller.addAction(action1)
        alertViewContronller.addAction(action2)
        alertViewContronller.addAction(action3)
        
        self.navigationController?.present(alertViewContronller, animated: true, completion: nil)
    }
    
    func selectPictureWithIndex(_ index:Int) {
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
            case 2: vc.sourceType = .photoLibrary;break
            default:break
        }
        
        self.navigationController?.present(vc, animated: true, completion: nil)
    }

    
    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableHeaderView = UIView (frame: CGRect (x: 0, y: 0, width: 10, height: 20))
        
        self.navigationItem.rightBarButtonItem = rightNavigationItem()
        
//        if let btn = self.navigationItem.leftBarButtonItem?.customView as? UIButton {
//            let sel = btn.actions(forTarget: self.navigationController, forControlEvent: .touchUpInside);
//            
//        }
        _init()
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(changeAvatar(_ :)))
        
        icon.addGestureRecognizer(tap)
    }

    func _init()  {
        if let avatar = User.avatar() {
         let url = URL.init(string: avatar)
        icon.kf.setImage(with: url, placeholder: UIImage (named: "avatar_default"), options: nil, progressBlock: nil, completionHandler: nil)
        }

    }
    
    
    
    func changeAvatar(_ tap:UITapGestureRecognizer)  {
        show()
    }
    
    
    func rightNavigationItem() -> UIBarButtonItem{
        let rightbtn = UIButton (frame: CGRect (x: 0, y: 0, width: 30, height: 30))
        rightbtn.setTitle("保存", for: .normal)
        rightbtn.setTitleColor(UIColor.darkGray , for: .normal)
        rightbtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        rightbtn.addTarget(self, action: #selector(saveAction), for: .touchUpInside)
        let rightitem = UIBarButtonItem.init(customView: rightbtn)
        
        return rightitem
    }
    
    func saveAction()  {
        guard let uid = User.uid() else {return}
        var image:[UIImage]? = nil
        
        if let avatar = u_avatar_image {
            image = [avatar]
        }
        
        
        HUD.show()
            let d = ["uid":uid,
//                     "content":String.isNullOrEmpty(mark.text),
//                     "type":"1"
        ]
            
            AlamofireHelper.upload(to: add_action_url, parameters: d, uploadFiles: image, successHandler: { [weak self] (res) in
                print(res)
                HUD.show(successInfo: "发布成功!");
                guard let ss = self else {return}
                
                ss.dismiss(animated: true, completion: nil)
                
            }) {
                print("upload faile");
            }

    }
    
    //MARK: -
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.section == 1, indexPath.row > 0 else {return}
        name.resignFirstResponder()
        
        if indexPath.row == 1{
            TTDataPickerView.show(["男","女"]) {[weak self] (str) in
                guard let ss = self else {return}
                ss.sex.text = "\(str)"
                ss.u_sex = "\(str)"
            }

        } else if indexPath.row == 2{
            TTDatePickerView.show {[weak self] (date ,age) in
                guard let ss = self else {return}
                ss.age.text = date
                ss.u_age = date
                print("\(date) - \(age)")
            }

        }else if indexPath.row == 3 {
            guard let path = Bundle.main.path(forResource: "area", ofType: "plist") else {return}
            guard let arr = NSArray.init(contentsOfFile: path) else {return}
            TTDataPickerView.show(arr as! [Any], components: 2) { [weak self](obj) in
                guard let ss = self else {return}
                guard let d = obj as? [String:String] else {return}
                let s = "\(String.isNullOrEmpty(d["province"]))" + (d["city"] == nil ? "" : "-\((String.isNullOrEmpty(d["city"])))")
                ss.city.text = s
                ss.u_city = s
                print(obj)
            }
            
        }
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
            u_avatar_image = img
        }
        
        picker.dismiss(animated: true, completion: nil)
        
    }
    
}



