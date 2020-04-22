//
//  TTBasePickerView.swift
//  DCTT
//
//  Created by wyg on 2018/1/27.
//  Copyright © 2018年 Light.W. All rights reserved.
//

import UIKit

class TTBasePickerView: UIView {
    var _contentview:UIView!
    let kTopButtonHeight:CGFloat = 45
    
    private var _maskView:UIView!
    private let kContentViewHeight:CGFloat = 220
    private let kAnimateDuration = 0.25
    
    typealias completeHandlerType = (()->())
    var completeHandler:completeHandlerType?
    
    override init(frame: CGRect = UIScreen.main.bounds) {
        super.init(frame: frame)
        
        _maskView = UIView (frame: frame)
        _maskView.backgroundColor = UIColor.black
        _maskView.alpha = 0.2
        _maskView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(tapClick)))
        
        _contentview = UIView (frame: CGRect (x: 0, y: frame.height, width: frame.width, height: kContentViewHeight))
        _contentview.backgroundColor = UIColor.white //kTableviewBackgroundColor
        
        let _titles = ["取消","确定"]        
        for i in 0..<2 {
            let btn = UIButton (frame: CGRect (x: i == 0 ? 10 : _contentview.frame.width - 70 , y: 0, width: 60, height: kTopButtonHeight))
            btn.setTitle(_titles[i], for: .normal)
            btn.addTarget(self, action: #selector(contentBtnClick(_ :)), for: .touchUpInside)
            btn.setTitleColor(kAirplaneCell_head_selected_color, for: .normal)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            btn.tag = 100 + i
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

    
//    class func show(_ withCompleteHandler:completeHandlerType? = nil) {
//        self.default.show(withCompleteHandler)
//    }
    
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
    
    @objc func contentBtnClick( _ button:UIButton) {
        if button.tag == 101 {
            finishedButtonClicked()
        }
        
        dismiss()
    }
    
    
    func finishedButtonClicked() { }
    

}
