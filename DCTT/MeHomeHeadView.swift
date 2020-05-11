//
//  MeHomeHeadView.swift
//  DCTT
//
//  Created by wyg on 2018/3/18.
//  Copyright © 2018年 Light.W. All rights reserved.
//

import UIKit

class MeHomeHeadView: UIView {

    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var sex: UIImageView!
    @IBOutlet weak var age: UILabel!
    @IBOutlet weak var city: UILabel!
    
    @IBOutlet weak var mark: UILabel!
    @IBOutlet weak var praise: UILabel!
    @IBOutlet weak var fans: UILabel!
    @IBOutlet weak var score: UILabel!

    @IBOutlet weak var watchBtn: UIButton!
    
    @IBOutlet weak var blackBtn: UIButton!
    @IBOutlet weak var buttonBg: UIView!
    
    
    var watchOperation:OPerationObject!
    var blackOperation:OPerationObject!
    
    var avatarClickerAction:(() -> Void)?
    
    private var author_id:String!
    
    override func awakeFromNib() {
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(iconTap(_ :)))
        avatar.addGestureRecognizer(tap)
        
        //watchBtn.isHidden = true
        buttonBg.isHidden = true
        
        ///0:检测是否关注 3:添加关注 4:取消关注
        watchOperation = OPerationObject.init(opType: 0, obj: watchBtn, url: fans_url, msg: "加载完成")
        blackOperation = OPerationObject.init(opType: 0, obj: blackBtn, url: blackList_url, msg: "加载完成")
    }
    
    @objc func iconTap(_ gesture:UITapGestureRecognizer)  {
        if let action = avatarClickerAction {
            action()
        }
    }
    
    
    @IBAction func watchAction(_ sender: UIButton) {
        guard User.isLogined() else {
            HUD.showText(kPleaseToLogin, view: UIApplication.shared.keyWindow!)
            return
        }

        if sender.tag == 1 {
            if sender.isSelected {
                let op = OPerationObject.init(opType: 4, obj: watchBtn, url: fans_url, msg: "取消关注")
                _buttonAction(op)
            }else {
                let op = OPerationObject.init(opType: 3, obj: watchBtn, url: fans_url, msg: "添加关注")
                _buttonAction(op)
            }
        } else if sender.tag == 2 {//黑名单
            if sender.isSelected {
                let op = OPerationObject.init(opType: 4, obj: blackBtn, url: blackList_url, msg: "已移除黑名单")
                _buttonAction(op)
            }else {
                Tools.showMsg("添加到黑名单后将无法查看对方动态,可在\"设置-黑名单\"中解除。是否确定?", title: "确定") {[weak self]  in
                    guard let ss = self else {return}
                    let op = OPerationObject.init(opType: 3, obj: ss.blackBtn, url: blackList_url, msg: "已添加到黑名单")
                    ss._buttonAction(op)
                }
            }
        }
        
    }
    
    
    func fill(_ dic:[String:Any]) {
        if let igurl = dic["avatar"] as? String {
            let url = URL.init(string: igurl)
            avatar.kf.setImage(with: url, placeholder: nil, options: nil, progressBlock: nil);
//            avatar.setImage(path:url, placeholder: UIImage (named: "avatar_default"), options: nil, progressBlock: nil, completionHandler: nil)
        }
        
        var s = ""
        let _name = String.isNullOrEmpty(dic["name"]);
        if _name.lengthOfBytes(using: String.Encoding.utf8) > 0  {
            s = _name;
        }
        else
            if let name = dic["nickName"] as? String {
                s = name;
        }
        name.text = s

        let sexigname = String.isNullOrEmpty(dic["sex"]) == "1" ? "boy":"girl"
        sex.image = UIImage (named:  sexigname)
        age.text =  String.isNullOrEmpty(dic["age"]) + "岁"
        
        city.text = (dic["location"] as? String) ?? "未知"
        
        let notes = String.isNullOrEmpty(dic["notes"])
        let notesStr = "签名: " + (notes.lengthOfBytes(using: String.Encoding.utf8) > 0 ? notes : "暂无介绍")
        
//        let paragraphStyle = NSMutableParagraphStyle.init()
//        paragraphStyle.lineSpacing = 5
//        paragraphStyle.lineBreakMode = .byCharWrapping
//        paragraphStyle.firstLineHeadIndent = 15
//
//        let dic:[String:Any] = [NSFontAttributeName:UIFont.systemFont(ofSize: 17) , NSParagraphStyleAttributeName:paragraphStyle,NSKernAttributeName:1]
        
        let attriStr = NSMutableAttributedString.init(string: notesStr)
        attriStr.addAttributes(convertToNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.font):UIFont.systemFont(ofSize: 13) , convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor):UIColor.darkGray]), range: NSRange.init(location: 0, length: 3));
        
        mark.attributedText = attriStr
        
        praise.text = String.isNullOrEmpty(dic["zanCnt"])
        fans.text = String.isNullOrEmpty(dic["fanCnt"])
        score.text = String.isNullOrEmpty(dic["score"])
        
        ///watch
        author_id = String.isNullOrEmpty(dic["user_id"])
        
        ///查看自己的主页
        if let myuid = User.uid() , author_id == myuid {
            return
        }

        ///查看他人的主页
        buttonBg.isHidden = false;
        
        _checkIsWatched()
        
        _checkBlacked()
    }

    func _checkIsWatched() {
        _buttonAction(watchOperation)
    }
    
    
    func _checkBlacked() {
        _buttonAction(blackOperation)
    }
    
    ///0:检测是否关注 3:添加关注 4:取消关注
    func _buttonAction(_ op : OPerationObject) {
        guard let myid = User.uid() else {return}
        guard let _author = author_id else {return}
        
        
        let d = ["uid":myid , "auhorId":_author , "type":op.opType] as [String : Any]
        
        HUD.show()
        AlamofireHelper.post(url: op.url, parameters: d, successHandler: { [weak self](res) in
            HUD.show(successInfo: String.isNullOrEmpty(op.msg))
            
            guard let ss = self else {return}
            guard let d = res["body"] as? [String:Any] else {return}
            let isWatched = String.isNullOrEmpty(d["is"])
            
            if op.obj.isHidden {
                op.obj.isHidden = false
            }
            if op.opType == 0 {
                op.obj.isSelected = isWatched == "1" ? true : false
            }else if op.opType == 3 {
                op.obj.isSelected = true
            }else if op.opType == 4 {
                op.obj.isSelected = false
            }
            
            if op.obj == ss.watchBtn {
                op.obj.backgroundColor = op.obj.isSelected ? UIColor.lightGray
                    : UIColorFromHex(rgbValue: 0xEC5252)
            }

        }) { (err) in
            HUD.dismiss()
        }
    }
    
//    func _watchAction(_ type:Int , msg:String?) {
//        guard let myid = User.uid() else {return}
//        guard let _author = author_id else {return}
//
//
//        let d = ["uid":myid , "auhorId":_author , "type":type] as [String : Any]
//
//        HUD.show()
//        AlamofireHelper.post(url: fans_url, parameters: d, successHandler: { [weak self](res) in
//            HUD.show(successInfo: String.isNullOrEmpty(msg))
//
//            guard let ss = self else {return}
//            guard let d = res["body"] as? [String:Any] else {return}
//            let isWatched = String.isNullOrEmpty(d["is"])
//
//            if ss.watchBtn.isHidden {
//                ss.watchBtn.isHidden = false
//            }
//            if type == 0 {
//                ss.watchBtn.isSelected = isWatched == "1" ? true : false
//            }else if type == 3 {
//                ss.watchBtn.isSelected = true
//            }else if type == 4 {
//                ss.watchBtn.isSelected = false
//            }
//
//
//            ss.watchBtn.backgroundColor = ss.watchBtn.isSelected ? UIColor.lightGray
//                : UIColorFromHex(rgbValue: 0xEC5252)
//        }) { (err) in
//            HUD.dismiss()
//        }
//    }
    
    
    
    
}

struct OPerationObject {
    var opType:Int
    var obj:UIButton
    var url:String
    var msg:String
}





// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToNSAttributedStringKeyDictionary(_ input: [String: Any]) -> [NSAttributedString.Key: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
	return input.rawValue
}
