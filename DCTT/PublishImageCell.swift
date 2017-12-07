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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        igv.contentMode = .scaleAspectFill
        
    }

    
    func setImage(_ asset:PHAsset) {
        let requestOption = PHImageRequestOptions.init()
        //requestOption.isSynchronous = true
        requestOption.resizeMode = .fast
        
        let size = CGSize(width: 400, height: 400)
         PHImageManager.default().requestImage(for: asset, targetSize: size, contentMode: .aspectFit, options: requestOption, resultHandler: { [weak self ](img, dic) in
            
         guard let strongSelf = self else{return}
         if let ig = img {
            strongSelf.igv.image = ig;
         }
         
         })
    }
    
    
}
