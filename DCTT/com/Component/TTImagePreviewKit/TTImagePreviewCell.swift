//
//  TTImagePreviewCell.swift
//  DCTT
//
//  Created by gener on 2017/12/13.
//  Copyright © 2017年 Light.W. All rights reserved.
//

import UIKit
import Photos

class TTImagePreviewCell: UICollectionViewCell,UIScrollViewDelegate {
    
    var scrollview:UIScrollView!
    var igv:UIImageView!
    
    var imageClickedHandler:(() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        scrollview = UIScrollView (frame: CGRect (x: 0, y: 0, width: frame.width - 10, height: frame.height))
        scrollview.delegate = self
        scrollview.minimumZoomScale = 1
        scrollview.maximumZoomScale = 2
        scrollview.showsVerticalScrollIndicator = false
        scrollview.showsHorizontalScrollIndicator = false
        self.addSubview(scrollview)
        
        igv = UIImageView (frame: scrollview.frame)
        igv.contentMode = .scaleAspectFit
        igv.isUserInteractionEnabled = true
        scrollview.addSubview(igv)
        
        let tapGesture = UITapGestureRecognizer (target: self, action: #selector(imageTapAction))
        igv.addGestureRecognizer(tapGesture)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func imageTapAction() {
        if let tap = imageClickedHandler {
            tap();
        }
    }
    
    //MARK: - UIScrollViewDelegate
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return igv
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        setIgvCenter(scrollView)
    }
    
    fileprivate func setIgvCenter(_ scrollView:UIScrollView) {
        var _x = scrollView.center.x , _y = scrollView.center.y
        _x = scrollView.contentSize.width > scrollView.frame.width ? scrollView.contentSize.width / 2 : _x
        _y = scrollView.contentSize.height > scrollView.frame.height ? scrollView.contentSize.height / 2 : _y
        
        igv.center = CGPoint (x: _x, y: _y)
    }
    
    
    //MARK: -
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
                    strongSelf._initWithImage(ig)
                }
            })
        
    }
    
    fileprivate func _initWithImage(_ image:UIImage) {
        igv.image = image
        
        //igv frame
        let _h = image.size.height * kCurrentScreenWidth / image.size.width
        igv.frame = CGRect (x: 0, y: 0, width: kCurrentScreenWidth, height: _h)
        
        scrollview.contentSize = igv.frame.size
        
        setIgvCenter(scrollview)
        
    }
    
    //MARK:- Public
    func setImage() {
        
    }
    
    
    
}
