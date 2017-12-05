//
//  TTPublishView.swift
//  DCTT
//
//  Created by gener on 2017/12/5.
//  Copyright © 2017年 Light.W. All rights reserved.
//

import UIKit

class TTPublishView: UIView {
    static let `default` = TTPublishView (frame: UIScreen.main.bounds)
    
    var _maskView:UIView!
    var _contentview:UIView!
    
    let kContentViewHeight:CGFloat = 220
    let kAnimateDuration = 0.25
    
    typealias completeHandlerType = ((Int)->())
    var completeHandler:completeHandlerType?
    
    override init(frame: CGRect = UIScreen.main.bounds) {
        super.init(frame: frame)
        
        _maskView = UIView (frame: frame)
        _maskView.backgroundColor = UIColor.black
        _maskView.alpha = 0.2
        _maskView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(tapClick)))
        
        _contentview = UIView (frame: CGRect (x: 0, y: frame.height, width: frame.width, height: kContentViewHeight))
        _contentview.backgroundColor = kTableviewBackgroundColor
        
        let cancleBtn = UIButton (frame: CGRect (x: 0, y: _contentview.frame.height - 50, width: _contentview.frame.width, height: 50))
        cancleBtn.setTitle("取消", for: .normal)
        cancleBtn.addTarget(self, action: #selector(cancleBtnClick), for: .touchUpInside)
        cancleBtn.setTitleColor(UIColor (red: 212/255.0, green: 61/255.0, blue: 61/255.0, alpha: 1), for: .normal)
        cancleBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        cancleBtn.backgroundColor = UIColor.white
        _contentview.addSubview(cancleBtn)
        
        let titles = ["动态","朋友圈","服务"]
        let imgs = ["publish_write","publish_image","video_allshare"]
        
        let _x = [0.5,2,3.5]
        let _w = frame.width / 5
        for index in 0..<titles.count {
            let btn = UIButton (frame: CGRect (x: _w  * (CGFloat(_x[index])) , y: 35, width: _w, height: _w + 20))
            btn.setTitle(titles[index], for: .normal)
            btn.setTitleColor(UIColor.darkGray, for: .normal)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
            
            btn.setImage(UIImage (named: imgs[index]), for: .normal)
            btn.setImage(UIImage (named: imgs[index]), for: .highlighted)
            
            btn.titleEdgeInsets = UIEdgeInsetsMake(_w + 5, -_w, 0, 0)
            btn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 20, 0)

            btn.tag = 101 + index
            btn.addTarget(self, action: #selector(ditributeClick(_:)), for: .touchUpInside)
            _contentview.addSubview(btn)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    //MARK:
    func show(_ withCompleteHandler:completeHandlerType? = nil) {
        UIApplication.shared.keyWindow?.addSubview(_maskView)
        UIApplication.shared.keyWindow?.addSubview(_contentview)
        UIView.animate(withDuration: kAnimateDuration) { [weak self] in
            guard let strongSelf = self else {return}
            strongSelf._contentview.transform = CGAffineTransform.init(translationX: 0, y: -strongSelf.kContentViewHeight)
        }
        
        completeHandler = withCompleteHandler
    }

    class func show(_ withCompleteHandler:completeHandlerType? = nil) {
        TTPublishView.default.show(withCompleteHandler)
    }
    
    func dismiss() {
        UIView.animate(withDuration: kAnimateDuration, animations: { [weak self] in
            guard let strongSelf = self else {return}
            strongSelf._contentview.transform = CGAffineTransform.identity
            }) { [weak self] (_b) in
                guard let strongSelf = self else {return}
                if _b{
                    strongSelf._contentview.removeFromSuperview()
                    strongSelf._maskView.removeFromSuperview()
                }
        }
    }
    
    
    //MARK: - CLICK
    func tapClick() {
        dismiss()
    }
    
    func cancleBtnClick() {
        dismiss()
    }
    
    
    func ditributeClick(_ btn:UIButton) {
        dismiss()

        if let complete = completeHandler {
            complete(btn.tag - 100);
        }
        
    }
    
    
    
    
}



