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
    
    
    var avatarClickerAction:(() -> Void)?
    
    private var author_id:String!
    
    override func awakeFromNib() {
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(iconTap(_ :)))
        avatar.addGestureRecognizer(tap)
        
        watchBtn.isHidden = true
    }
    
    func iconTap(_ gesture:UITapGestureRecognizer)  {
        if let action = avatarClickerAction {
            action()
        }
    }
    
    
    @IBAction func watchAction(_ sender: UIButton) {
        guard User.isLogined() else {
            HUD.showText(kPleaseToLogin, view: UIApplication.shared.keyWindow!)
            return
        }

        if sender.isSelected {
            _watchAction(4, msg: "取消关注")
        }else {
            _watchAction(3, msg: "添加关注")
        }
        
    }
    
    
    func fill(_ dic:[String:Any]) {
        if let igurl = dic["avatar"] as? String {
            let url = URL.init(string: igurl)
            avatar.kf.setImage(with: url, placeholder: UIImage (named: "avatar_default"), options: nil, progressBlock: nil, completionHandler: nil)
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
        attriStr.addAttributes([NSFontAttributeName:UIFont.systemFont(ofSize: 13) , NSForegroundColorAttributeName:UIColor.darkGray], range: NSRange.init(location: 0, length: 3));
        
        mark.attributedText = attriStr
        
        praise.text = String.isNullOrEmpty(dic["zanCnt"])
        fans.text = String.isNullOrEmpty(dic["fanCnt"])
        score.text = String.isNullOrEmpty(dic["score"])
        
        ///watch
        author_id = String.isNullOrEmpty(dic["user_id"])
        guard let myuid = User.uid() else { return }
        guard author_id != myuid else {return}
        
        _checkIsWatched()
    }

    
    func _checkIsWatched() {
        _watchAction(0, msg: "加载完成")
    }
    
    ///0:检测是否关注 1:添加关注 2:取消关注
    func _watchAction(_ type:Int , msg:String?) {
        guard let myid = User.uid() else {return}
        guard let _author = author_id else {return}
        let d = ["uid":myid , "auhorId":_author , "type":type] as [String : Any]
        
        HUD.show()
        AlamofireHelper.post(url: fans_url, parameters: d, successHandler: { [weak self](res) in
            HUD.show(successInfo: String.isNullOrEmpty(msg))
            
            guard let ss = self else {return}
            guard let d = res["body"] as? [String:Any] else {return}
            let isWatched = String.isNullOrEmpty(d["is"])
            
            if ss.watchBtn.isHidden {
                ss.watchBtn.isHidden = false
            }
            if type == 0 {
                ss.watchBtn.isSelected = isWatched == "1" ? true : false
            }else if type == 3 {
                ss.watchBtn.isSelected = true
            }else if type == 4 {
                ss.watchBtn.isSelected = false
            }
            
            
            ss.watchBtn.backgroundColor = ss.watchBtn.isSelected ? UIColor.lightGray
                : UIColorFromHex(rgbValue: 0xEC5252)
        }) { (err) in
            HUD.dismiss()
        }
    }
    
    
}
