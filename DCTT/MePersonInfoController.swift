//
//  MePersonInfoController.swift
//  DCTT
//
//  Created by wyg on 2018/3/11.
//  Copyright © 2018年 Light.W. All rights reserved.
//

import UIKit
import Photos
import Kingfisher
import RxSwift
import RxCocoa

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
    var saveBtn:UIButton!
    let disposeBag = DisposeBag.init()
    var rx_avatar:Variable<UIImage?> = Variable(nil)
    var rx_sex:Variable<String?> = Variable(nil)
    var rx_age:Variable<String?> = Variable(nil)
    var rx_city:Variable<String?> = Variable(nil)

    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
        _init()
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(changeAvatar(_ :)))
        icon.addGestureRecognizer(tap)
    }

    func _init()  {
        tableView.tableHeaderView = UIView (frame: CGRect (x: 0, y: 0, width: 10, height: 20))
        self.navigationItem.rightBarButtonItem = rightNavigationItem()
        guard let userinfo = User.default.userInfo() else {return}
        
        func fillData() {
            if let avatar = User.avatar() {
                let url = URL.init(string: avatar)
                icon.kf.setImage(with: url, placeholder: UIImage (named: "avatar_default"), options: nil, progressBlock: nil, completionHandler: nil);
            }
            
            name.text = String.isNullOrEmpty(userinfo["name"])
            sex.text = String.isNullOrEmpty(userinfo["sex"])
            age.text = String.isNullOrEmpty(userinfo["bornDate"])
            city.text = String.isNullOrEmpty(userinfo["location"])
            
            if let notes = userinfo["notes"] as? String , notes.lengthOfBytes(using: String.Encoding.utf8) > 0{
                mark.text = notes;
                msg.isHidden = true
            }
        }
        
        fillData();
        

        let o_avatar =  rx_avatar.asObservable().map({$0 != nil}).shareReplay(1)
        let o_sex = rx_sex.asObservable().map({$0 != nil}).shareReplay(1)
        let o_age = rx_age.asObservable().map({$0 != nil}).shareReplay(1)
        let o_city = rx_city.asObservable().map({$0 != nil}).shareReplay(1)
        let o_name =  mark.rx.text.orEmpty.map({String.isNullOrEmpty($0) != String.isNullOrEmpty(userinfo["name"]) }).shareReplay(1)
        let o_mark =  mark.rx.text.orEmpty.map({String.isNullOrEmpty($0) != String.isNullOrEmpty(userinfo["notes"]) }).shareReplay(1)
        
        Observable.combineLatest(o_avatar,o_sex,o_age,o_city,o_name,o_mark) { $0 || $1 || $2 || $3 || $4 || $5}.bindTo(saveBtn.ex_isEnabled).addDisposableTo(disposeBag)
    }
    
    
    
    func changeAvatar(_ tap:UITapGestureRecognizer)  {
        show()
    }
    
    
    func rightNavigationItem() -> UIBarButtonItem{
        let rightbtn = UIButton (frame: CGRect (x: 0, y: 0, width: 30, height: 30))
        rightbtn.setTitle("提交", for: .normal)
        rightbtn.setTitleColor(UIColor.darkGray , for: .normal)
        rightbtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        rightbtn.addTarget(self, action: #selector(saveAction), for: .touchUpInside)
        let rightitem = UIBarButtonItem.init(customView: rightbtn)
        
        saveBtn = rightbtn
        return rightitem
    }
    
    //MARK: - save
    func saveAction()  {
        guard let userInfo = User.default.userInfo() else {return}
        guard let uid = User.uid() else {return}
        var image:[UIImage]? = nil
        
        if let avatar = rx_avatar.value {
            image = [avatar]
        }
        
        
        HUD.show()
        var d:[String:Any] = ["uid":uid, "type":"0"]
        
        if let sex = rx_sex.value {
            d["sex"] = sex;
        }
        if let city = rx_city.value {
            d["city"] = city
        }
        
        if let age = rx_age.value {
            d["bornDate"] = age;
        }
        
        if let username = userInfo["name"] as? String , username != String.isNullOrEmpty(name.text) {
            d["name"] = String.isNullOrEmpty(name.text);
        }
        
        var mark = String.isNullOrEmpty(self.mark.text)
        if let username = userInfo["notes"] as? String , username != mark {
           if mark.lengthOfBytes(using: String.Encoding.utf8) > 200 {
                mark = mark.substring(to: mark.index(mark.startIndex, offsetBy: 200))
            print(mark);
            }
            
            d["notes"] = String.isNullOrEmpty(mark);
        }

        
        AlamofireHelper.upload(to: update_profile_url, parameters: d, uploadFiles: image, successHandler: { [weak self] (res) in
            print(res)
            guard let ss = self else {return}
            guard String.isNullOrEmpty(res["status"]) == "200" else {
                HUD.showText(String.isNullOrEmpty(res["msg"]), view: ss.view);return;
            }
            
            HUD.show(successInfo: "提交成功!");
            if image != nil , let now = User.avatar() {
                ImageCache.default.removeImage(forKey: now)
            }
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: {
                NotificationCenter.default.post(name: updateUserInfoNotification, object: nil)
                ss.navigationController?.popViewController(animated: true)
            })
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
                //ss.u_sex = "\(str)"
                ss.rx_sex.value = "\(str)"
            }
        } else if indexPath.row == 2{
            TTDatePickerView.show {[weak self] (date ,age) in
                guard let ss = self else {return}
                ss.age.text = date
                //ss.u_age = date
                ss.rx_age.value = date
            }
        }else if indexPath.row == 3 {
            guard let path = Bundle.main.path(forResource: "area", ofType: "plist") else {return}
            guard let arr = NSArray.init(contentsOfFile: path) else {return}
            TTDataPickerView.show(arr as! [Any], components: 2) { [weak self](obj) in
                guard let ss = self else {return}
                guard let d = obj as? [String:String] else {return}
                let s = "\(String.isNullOrEmpty(d["province"]))" + (d["city"] == nil ? "" : "-\((String.isNullOrEmpty(d["city"])))")
                ss.city.text = s
                //ss.u_city = s
                ss.rx_city.value = s
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


// MARK: -
extension MePersonInfoController:UIImagePickerControllerDelegate ,UINavigationControllerDelegate{
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

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let img = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            icon.image = img
            //u_avatar_image = img
            rx_avatar.value = img
        }
        
        picker.dismiss(animated: true, completion: nil)
        
    }
    
}



