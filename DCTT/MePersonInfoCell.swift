//
//  MePersonInfoCell.swift
//  DCTT
//
//  Created by gener on 2017/11/29.
//  Copyright © 2017年 Light.W. All rights reserved.
//

import UIKit

class MePersonInfoCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var sex: UIImageView!
    @IBOutlet weak var age: UILabel!
    @IBOutlet weak var city: UILabel!
    
    @IBOutlet weak var praiseCnt: UILabel!
    @IBOutlet weak var fansCnt: UILabel!
    @IBOutlet weak var score: UILabel!

    func fill()  {
        guard let dic = User.default.userInfo() else {return}
        name.text = User.name()

        if let igurl = dic["avatar"] as? String {
             let url = URL.init(string: igurl)
            avatar.kf.setImage(with: url, placeholder: UIImage (named: "avatar_default"), options: nil, progressBlock: nil, completionHandler: nil)
        }

        let notes = String.isNullOrEmpty(dic["notes"])
        city.text =  notes.lengthOfBytes(using: String.Encoding.utf8) > 0 ? notes : "暂无介绍"

        praiseCnt.text = String.isNullOrEmpty(dic["praise"])
        fansCnt.text = String.isNullOrEmpty(dic["fans"])
        score.text = String.isNullOrEmpty(dic["score"])
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
