//
//  HomeDetailCommentCell.swift
//  DCTT
//
//  Created by wyg on 2018/1/11.
//  Copyright © 2018年 Light.W. All rights reserved.
//

import UIKit

class HomeDetailCommentCell: UITableViewCell {
    @IBOutlet weak var icon: UIImageView!

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var zanBtn: UIButton!
    
    @IBOutlet weak var msgText: UILabel!
    @IBOutlet weak var timeLable: UILabel!
    
    @IBOutlet weak var jubaoBtn: UIButton!//自己评论的，显示删除
    
    var isMySelf = false
    
    var avatarClickedAction:(() -> Void)?

    var commentId:String!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(tapIconAction))
        icon.addGestureRecognizer(tapGesture)
        
//        zanBtn.layer.borderWidth = 1
//        zanBtn.layer.borderColor = kTableviewBackgroundColor.cgColor
//        zanBtn.layer.cornerRadius = 10
//        zanBtn.layer.masksToBounds = true
    }
    
    @objc func tapIconAction()  {
        if let iconAction = avatarClickedAction {
            iconAction()
        }
    }
    
    func fill(_ d:[String:Any]) {
        commentId = String.isNullOrEmpty(d["id"])
        
        let text = String.isNullOrEmpty(d["content"])
        let paragraphStyle = NSMutableParagraphStyle.init()
        paragraphStyle.lineSpacing = 3
        paragraphStyle.lineBreakMode = .byCharWrapping
        paragraphStyle.firstLineHeadIndent = 0
        
        let attriDic:[String:Any] = [
            convertFromNSAttributedStringKey(NSAttributedString.Key.font):UIFont.systemFont(ofSize: 15) ,
            convertFromNSAttributedStringKey(NSAttributedString.Key.paragraphStyle):paragraphStyle,
            convertFromNSAttributedStringKey(NSAttributedString.Key.kern):1
        ]
        
        let attriStr = NSAttributedString.init(string: text, attributes: convertToOptionalNSAttributedStringKeyDictionary(attriDic))
        msgText.attributedText = attriStr
        
        //name
        var s = ""
        let _name = String.isNullOrEmpty(d["u_name"]);
        
        if _name.lengthOfBytes(using: String.Encoding.utf8) > 0  {
            s =  "\(_name)";
        }
        else
        if let name = d["u_nickName"] as? String {
            s = "\(name)";
        }

        name.text = s
        
        //avatar
        if let igurl = d["u_avatar"] as? String {
            let url = URL.init(string: igurl)
            icon.kf.setImage(with: url, placeholder: UIImage (named: "avatar_default"))
        }
        
        timeLable.text = "发布于 " + Date.dateFormatterWithString(String.isNullOrEmpty(d["date"]))

        ///自己评论的，显示删除按钮
        guard let myId = User.uid() else {return}
        let _uid = String.isNullOrEmpty(d["uid"]) //评论者ID
        isMySelf = myId == _uid
        
        if isMySelf {
           jubaoBtn.setTitle("删除", for: .normal)
        }
    }

    override func prepareForReuse() {
        jubaoBtn.setTitle("举报", for: .normal)
    }
    
    
    @IBAction func zanBtnAction(_ sender: UIButton) {
        switch sender.tag {
        case 1://赞
            break
            
        case 2://回复
            
            break
        case 3://举报

            guard !isMySelf else {
                Tools.showMsg("确定删除这条评论?", title: "删除") {[weak self]  in
                    guard let ss = self else {return}
                    ss._deleteMyComment()
                }
                
                return
            }
            
            let v = UIStoryboard.init(name: "me", bundle: nil).instantiateViewController(withIdentifier: "jubao_id") as! JuBaoController
            v.postId = ["pid":commentId!,
                        "category":"comment"
            ]
            
            
            let nav = BaseNavigationController(rootViewController: v)
            UIApplication.shared.keyWindow?.rootViewController?.present(nav, animated: true, completion: nil)
            
            break
        default:
            break
        }
        
    }
    
    func _deleteMyComment() {
        ///删除自己的评论
        let d = ["type":"delete","id":commentId! , "uid":User.uid()!]
        
        AlamofireHelper.post(url: comment_url, parameters: d, successHandler: { (res) in
            HUD.show(successInfo: "删除成功")
            NotificationCenter.default.post(name: kDeleteCommentNotification, object: nil)
        }) { (err) in
            HUD.show(info: "删除失败,请稍后重试")
        }

    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
	return input.rawValue
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}
