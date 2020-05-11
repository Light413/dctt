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

    var cellBtnClickedAction:(() -> Void)?
    
    @IBAction func helpBtnAction(_ sender: UIButton) {
        if let a = cellBtnClickedAction {
            a();
        }
        
    }
    
    
    func fill()  {
        guard let dic = User.default.userInfo() else {return}
        name.text = User.name()

        if let igurl = dic["avatar"] as? String {
             let url = URL.init(string: igurl)
            avatar.kf.setImage(with: url, placeholder: UIImage (named: "avatar_default"))
        }

        praiseCnt.text = String.isNullOrEmpty(dic["zanCnt"])
        fansCnt.text = String.isNullOrEmpty(dic["fanCnt"])
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
