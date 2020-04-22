//
//  PublishImageCell.swift
//  DCTT
//
//  Created by gener on 2017/12/5.
//  Copyright © 2017年 Light.W. All rights reserved.
//

import UIKit
import Photos
class PublishImageCell: UICollectionViewCell {

    @IBOutlet weak var igv: UIImageView!

    @IBOutlet weak var btn: UIButton!
    
    var cellType:ImageCellTpye!

    var cellSelectedHandler:((Bool) -> Bool)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        igv.contentMode = .scaleAspectFill
        
    }
    
    
    override func prepareForReuse() {
        btn.isSelected = false
    }
    
    @IBAction func badgeButtonAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected

        if let handler = cellSelectedHandler {
           let _b =  handler(sender.isSelected);
            if !_b {
            sender.isSelected = !sender.isSelected
            }
        }
        
    }

    
    /// - parameter asset:      所指向的图片资源
    /// - parameter type:       cell类型
    /// - parameter isSelected: 是否选中确定角标icon
    func setImage(_ asset:Any , type:ImageCellTpye , isSelected:Bool? = false) {
        cellType = type
        
        if asset is PHAsset {
            //获取相册图片
            let requestOption = PHImageRequestOptions.init()
            //requestOption.isSynchronous = true
            requestOption.resizeMode = .fast
            
            let size = CGSize(width: 400, height: 400)
            PHImageManager.default().requestImage(for: asset as! PHAsset, targetSize: size, contentMode: .aspectFit, options: requestOption, resultHandler: { [weak self ](img, dic) in
                
                guard let strongSelf = self else{return}
                if let ig = img {
                    strongSelf.igv.image = ig;
                }
                })

        } else if asset is UIImage {
            igv.image = asset as? UIImage;
        }
        
        //设置角标
        if type == .album {
            btn.setImage(UIImage (named: "ImgPic_select_album"), for: .normal);
            btn.setImage(UIImage (named: "ImgPic_select_ok_album"), for: .selected)
        } else if type == .publish {
            btn.setImage(UIImage (named: "revoke_icon"), for: .normal);
            btn.setImage(UIImage (named: "revoke_icon"), for: .selected)
            btn.imageEdgeInsets = UIEdgeInsets.init(top: 3, left: 15, bottom: 15, right: 3)
        }else {
            btn.isHidden = true
        }
        
        btn.isSelected = isSelected!
        
        
    }
    
    
}
