//
//  FensiCell.swift
//  DCTT
//
//  Created by wyg on 2018/4/12.
//  Copyright © 2018年 Light.W. All rights reserved.
//

import UIKit

class FensiCell: UITableViewCell {

    @IBOutlet weak var guanzhu_btn: UIButton!
    
    @IBOutlet weak var avantar: UIImageView!
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var mark: UILabel!
    
    private var _isWatched:Bool = true
    
    var buttonClickedAction:(() -> Void)?
    
    private var author_id:String!
    
    ///只处理了移除黑名单，以后待完善。。。
    @IBAction func gzAction(_ sender: UIButton) {
        Tools.showMsg("确定将用户 \"\(String.isNullOrEmpty(name.text))\" 移出黑名单?", title: "确定") { [weak self] in
            guard let ss = self else {return}
            let op = OPerationObject.init(opType: 4, obj: UIButton(), url: blackList_url, msg: "已移除黑名单")
            ss._buttonAction(op)
        }
    }
    
    
    func _buttonAction(_ op : OPerationObject) {
        guard let myid = User.uid() else {return}
        guard let _author = author_id else {return}
        let d = ["uid":myid , "auhorId":_author , "type":op.opType] as [String : Any]
        
        HUD.show()
        AlamofireHelper.post(url: op.url, parameters: d, successHandler: { [weak self](res) in
            HUD.show(successInfo: String.isNullOrEmpty(op.msg))
            guard let  ss = self else{return}
            if let action = ss.buttonClickedAction {
                action()
            }
        }) { (err) in
            HUD.dismiss()
        }
    }
    
    
    
    
    func fill(_ d:[String:Any] , isWatched:Bool = true) {
        guard let dic = d["user"] as? [String:Any] else {return}
        
        author_id = String.isNullOrEmpty(dic["user_id"])
        
        if isWatched {
            guanzhu_btn.isHidden = true
        }
        
        _isWatched = isWatched
//        guanzhu_btn.setTitle(_isWatched ? "取消关注" : "关注", for: .normal)
        
        if let igurl = dic["avatar"] as? String {
            let url = URL.init(string: igurl)
            avantar.kf.setImage(with: url, placeholder: UIImage (named: "avatar_default"))
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
        
        
        let notes = String.isNullOrEmpty(dic["notes"])
        let notesStr =  (notes.lengthOfBytes(using: String.Encoding.utf8) > 0 ? notes : "暂无介绍")
        mark.text = notesStr
        
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        guanzhu_btn.layer.borderWidth = 1
        guanzhu_btn.layer.borderColor = UIColor.init(red: 216 / 255.0, green: 61 / 255.0, blue: 52 / 255.0, alpha: 1).cgColor
        
        
    }
    
}
