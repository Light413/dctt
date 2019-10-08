//
//  HomeDetailFooterView.swift
//  DCTT
//
//  Created by wyg on 2018/1/25.
//  Copyright © 2018年 Light.W. All rights reserved.
//

import UIKit

class HomeDetailFooterView: UIView {

    @IBOutlet weak var zanBtn: UIButton!
    @IBOutlet weak var readCnt: UILabel!
    
    @IBOutlet weak var jubaoBtn: UIButton!
    var _d:[String:Any]?
    var category:String!
    
    @IBAction func jubaoAction(_ sender: Any) {
//        Tools.showMsg("发布的虚假信息或违法内容,举报该用户?", title: "举报") { () in
//            ///...
//
//        }
        
        let v = UIStoryboard.init(name: "me", bundle: nil).instantiateViewController(withIdentifier: "jubao_id") as! JuBaoController
        v.postId = ["pid":String.isNullOrEmpty(_d?["pid"]),
                    "category":String.isNullOrEmpty(_d?["category"])
        ]
        
        
        let nav = BaseNavigationController(rootViewController: v)
        UIApplication.shared.keyWindow?.rootViewController?.present(nav, animated: true, completion: nil)
    }
    
    
    
    override func awakeFromNib() {
        zanBtn.contentHorizontalAlignment = .center
        zanBtn.layer.cornerRadius = 12.5
        zanBtn.layer.masksToBounds = true
        zanBtn.layer.borderWidth = 0.5
        zanBtn.layer.borderColor = UIColor.lightGray.cgColor
        
        jubaoBtn.layer.borderWidth = 1
        jubaoBtn.layer.borderColor = kTableviewBackgroundColor.cgColor
        jubaoBtn.layer.cornerRadius = 10
        jubaoBtn.layer.masksToBounds = true
    }
    
    @IBAction func zanBtnAction(_ sender: UIButton) {
        guard User.isLogined() else {
            HUD.showText(kPleaseToLogin, view: UIApplication.shared.keyWindow!)
            return
        }
        

        guard let dic = _d else{return}
        guard let pid = dic["pid"] as? String else {return}
        guard let uid = dic["uid"] as? String else {return}
        
        guard !sender.isSelected else {
            HUD.showText("已经点赞!")
            return;
        }
        
        HUD.show()
        let d = ["pid":pid , "type":"1" ,"postby":uid , "uid":User.uid()!,"category":category! , "postContent":String.isNullOrEmpty(dic["content"])]
        
        AlamofireHelper.post(url: post_detail_url, parameters: d, successHandler: {[weak self] (res) in
            guard let ss = self else {return}
            ///+1 不能取消点赞
            
            ss.zanBtn.isSelected = true
            HUD.show(successInfo: "点赞成功")
        }) { (error) in
           HUD.show(info: error?.localizedDescription ?? "点赞失败,请稍后重试")
        }

    }
    
    func fill(_ d:[String:Any]) {
        _d = d
        
        if String.isNullOrEmpty(d["isMySelf"]) == "1" {
            jubaoBtn.isHidden = true
        }
        
        if let cnt = Int(String.isNullOrEmpty(d["readCnt"])) {
            readCnt.text = "\(cnt)";
        }
        
        if let cnt = Int(String.isNullOrEmpty(d["praiseCnt"]))  , cnt > 0 {
            zanBtn.setTitle("\(cnt)", for: .normal)
            
            //是否已赞
            zanBtn.isSelected = String.isNullOrEmpty(d[
                    "isPraised"]) == "1"
        }
        
        
        
    }
    
}
