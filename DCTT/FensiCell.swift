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
    
    @IBAction func gzAction(_ sender: UIButton) {
        
        
    }
    
    
    func fill(_ d:[String:Any] , isWatched:Bool = true) {
        guard let dic = d["user"] as? [String:Any] else {return}
        
        _isWatched = isWatched
        guanzhu_btn.setTitle(_isWatched ? "取消关注" : "关注", for: .normal)
        
        if let igurl = dic["avatar"] as? String {
            let url = URL.init(string: igurl)
            avantar.kf.setImage(with: url, placeholder: UIImage (named: "avatar_default"), options: nil, progressBlock: nil, completionHandler: nil)
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

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
