//
//  TTImagePreviewCell.swift
//  DCTT
//
//  Created by gener on 2017/12/12.
//  Copyright © 2017年 Light.W. All rights reserved.
//

import UIKit
import Photos

class TTImagePreviewCell: UICollectionViewCell ,UIScrollViewDelegate{

    @IBOutlet weak var igv: UIImageView!

    @IBOutlet weak var scrollview: UIScrollView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        igv.contentMode = .scaleAspectFit
        
        scrollview.delegate = self
    }

    override func layoutSubviews() {
       super.layoutSubviews()
        
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return igv
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
//        print(#function)
//        var _h:CGFloat = 0
//        let rect = igv.frame
//        
//        if (igv.image?.size.height)!  < igv.frame.height {
//            _h = (igv.image?.size.height)!;
//        }else{
//            _h = rect.height;
//        }
//        
//        igv.frame = CGRect (x: rect.minX, y: rect.minY, width: rect.width, height: _h)
//        igv.center = self.center
//        
//        print("2-------------------")
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        view?.frame = UIScreen.main.bounds
    }
    
    
    
    
    override func prepareForReuse() {
        scrollview.zoomScale = 1
        
    }
    
    
    /// - parameter asset:      所指向的图片资源
    /// - parameter type:       cell类型
    /// - parameter isSelected: 是否选中确定角标icon
    func setImage(_ asset:PHAsset , type:ImageCellTpye , isSelected:Bool? = false) {
        
        //获取相册图片
        let requestOption = PHImageRequestOptions.init()
        requestOption.resizeMode = .exact
        
        let size = CGSize(width: asset.pixelWidth, height: asset.pixelHeight)
        PHImageManager.default().requestImage(for: asset, targetSize: size, contentMode: .aspectFit, options: requestOption, resultHandler: { [weak self ](img, dic) in
            
            guard let strongSelf = self else{return}
            if let ig = img {
                strongSelf.igv.image = ig;
            }
            })
        
        //设置角标
        /*if type == .album {
            btn.setImage(UIImage (named: "ImgPic_select_album"), for: .normal);
            btn.setImage(UIImage (named: "ImgPic_select_ok_album"), for: .selected)
        } else if type == .publish {
            btn.setImage(UIImage (named: "ImgPic_close"), for: .normal);
            btn.setImage(UIImage (named: "ImgPic_close"), for: .selected)
        }else {
            btn.isHidden = true
        }
        
        btn.isSelected = isSelected!*/
        
        
    }
    
    
    
    
}
