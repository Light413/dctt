//
//  TTImagePreviewCell2.swift
//  DCTT
//
//  Created by gener on 2017/12/13.
//  Copyright © 2017年 Light.W. All rights reserved.
//

import UIKit
import Photos

class TTImagePreviewCell2: UICollectionViewCell,UIScrollViewDelegate {
    
    var scrollview:UIScrollView!
    var igv:UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        scrollview = UIScrollView (frame: CGRect (x: 0, y: 0, width: frame.width, height: frame.height))
        scrollview.delegate = self
        scrollview.minimumZoomScale = 1
        scrollview.maximumZoomScale = 2
        
        autoresizesSubviews = true
        
        self.addSubview(scrollview)
        
        igv = UIImageView (frame: scrollview.frame)
        igv.contentMode = .scaleAspectFit
        scrollview.addSubview(igv)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    //MARK: - UIScrollViewDelegate //587-319
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return igv
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        var _x = scrollView.center.x , _y = scrollView.center.y
        
        _x = scrollView.contentSize.width > scrollView.frame.width ? scrollView.contentSize.width / 2 : _x
        _y = scrollView.contentSize.height > scrollView.frame.height ? scrollView.contentSize.height / 2 : _y
        
        igv.center = CGPoint (x: _x, y: _y)
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        print(scale);
        
//        let _igh = (igv.image?.size.height)!, _igw = (igv.image?.size.width)!
//        
//        let s = scale
//        igv.frame.size = CGSize (width: _igw * s < scrollView.frame.width ? scrollView.frame.width : _igw * s, height: _igh * s < scrollView.frame.height ? scrollView.frame.height : _igh * s)
//        
//        scrollView.contentSize = igv.frame.size;
        
        
        var _x = scrollView.center.x , _y = scrollView.center.y
        _x = scrollView.contentSize.width > scrollView.frame.width ? scrollView.contentSize.width / 2 : _x
        _y = scrollView.contentSize.height > scrollView.frame.height ? scrollView.contentSize.height / 2 : _y
        
        igv.center = CGPoint (x: _x, y: _y)

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
        
    }
    
    
}
