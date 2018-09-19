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
    
    var _d:[String:Any]?
    var category:String!
    
    override func awakeFromNib() {
        zanBtn.contentHorizontalAlignment = .center
        zanBtn.layer.cornerRadius = 12.5
        zanBtn.layer.masksToBounds = true
        zanBtn.layer.borderWidth = 0.5
        zanBtn.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    @IBAction func zanBtnAction(_ sender: UIButton) {
        guard let dic = _d else{return}
        guard let pid = dic["pid"] as? String else {return}
        guard let uid = dic["uid"] as? String else {return}
        
        guard !sender.isSelected else {
            HUD.showText("已经点赞!", view: self)
            return;
        }
        
        HUD.show()
        let d = ["pid":pid , "type":"1" ,"postby":uid , "uid":User.uid()!,"category":category!]

        AlamofireHelper.post(url: post_detail_url, parameters: d, successHandler: {[weak self] (res) in
            guard let ss = self else {return}
            ///+1 不能取消点赞
            
            ss.zanBtn.isSelected = true
            HUD.show(successInfo: "点赞成功")
        }) { (error) in
           HUD.show(info: "点赞失败,请稍后重试")
        }

    }
    
    func fill(_ d:[String:Any]) {
        _d = d
        
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
