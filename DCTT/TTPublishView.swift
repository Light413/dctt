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
    
    let kContentViewHeight:CGFloat = 220  + (kIsIPhoneX ? 30 : 0)
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
        
        let cancleBtn = UIButton (frame: CGRect (x: 0, y: _contentview.frame.height - 50  - (kIsIPhoneX ? 30 : 0), width: _contentview.frame.width, height: 50  + (kIsIPhoneX ? 30 : 0)))
        cancleBtn.setTitle("取消", for: .normal)
        cancleBtn.addTarget(self, action: #selector(cancleBtnClick), for: .touchUpInside)
        cancleBtn.setTitleColor(UIColor.darkGray, for: .normal)
        cancleBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        cancleBtn.backgroundColor = UIColor.white
        _contentview.addSubview(cancleBtn)
        
        let titleLable = UILabel (frame: CGRect (x: 0, y: 15, width: frame.width, height: 20))
        _contentview.addSubview(titleLable)
        titleLable.text = "分享到"
        titleLable.textAlignment = .center
        titleLable.font = UIFont.systemFont(ofSize: 15)
        
        //-0-0-0-0- 5 4 121212121 = 13
        let titles = ["朋友圈","微信好友","QQ","QQ空间"]
        let icon_imgs = ["icon_share_wechat_timeline","icon_share_wechat_friends","icon_share_qq","icon_share_qzone"]
        
        let _w = frame.width / 17.0
        for index in 0..<titles.count {
//            let btn = UIButton (frame: CGRect (x: _w  * (CGFloat(_x[index])) , y: 35, width: _w, height: _w + 20))
            let btn = UIButton (frame: CGRect (x: _w  * (CGFloat(index + 1)) + _w * 3 * (CGFloat(index)) , y: 55, width: _w * 3, height: _w * 3 + 0))
            
//            btn.setTitle(titles[index], for: .normal)
//            btn.setTitleColor(UIColor.darkGray, for: .normal)
//            btn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
            
            btn.setImage(UIImage (named: icon_imgs[index]), for: .normal)
            btn.setImage(UIImage (named: icon_imgs[index]), for: .highlighted)
            
//            btn.titleEdgeInsets = UIEdgeInsetsMake(_w + 5, -_w, 0, 0)
//            btn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 20, 0)

            let t = UILabel (frame: CGRect (x: 0, y: btn.frame.maxY + 10, width: _w * 3, height: 20))
            t.center = CGPoint.init(x: btn.center.x, y: t.center.y)
            t.font = UIFont.systemFont(ofSize: 11)
            t.textColor = UIColor.darkGray
            t.textAlignment = .center
            
            t.text = titles[index]
            
            _contentview.addSubview(t)
            
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
    @objc func tapClick() {
        dismiss()
    }
    
    @objc func cancleBtnClick() {
        dismiss()
    }
    
    
    @objc func ditributeClick(_ btn:UIButton) {
        dismiss()

        if let complete = completeHandler {
            complete(btn.tag - 100);
        }
        
    }
    
    
    
    
}



