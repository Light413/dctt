//
//  HomeCellWithImage.swift
//  DCTT
//
//  Created by wyg on 2017/12/18.
//  Copyright © 2017年 Light.W. All rights reserved.
//

import UIKit
import Kingfisher

class HomeCellWithImage: HomeListBaseCell {

    @IBOutlet weak var msg: UILabel!
    
    @IBOutlet weak var igv: UIImageView!
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var time: UILabel!
    
    @IBOutlet weak var dislikeBtn: UIButton!
    
    @IBAction func dislikeAction(_ sender: Any) {
        Tools.showMsg("不喜欢该动态?", title: "隐藏") { [weak self] in
            guard let  ss = self else {return}
            if let b = ss.dislikeBlock {
                b()
            }
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        disLikeBtnSetStyle(dislikeBtn)
    }

    
    override func fill(_ d:[String:Any]) {
        fillData(msg: msg, user: name, date: time, data: d)

        
        let images = String.isNullOrEmpty(d["images"])
        let arr = images.components(separatedBy: ",")
        guard arr.count > 0 else { return}
        
        let url = URL.init(string: arr.first!)
        igv.kf.setImage(with: url, placeholder: UIImage (named: "default_image2"), options: nil, progressBlock: nil, completionHandler:nil)
    }
    
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
