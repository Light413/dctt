//
//  HomeDetailController.swift
//  DCTT
//
//  Created by gener on 17/11/21.
//  Copyright © 2017年 Light.W. All rights reserved.
//

import UIKit
import Kingfisher

class HomeDetailController: BaseDetailController{

    private var _titleView:UIView!
    
    //MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()

        //titleview
        _titleView = titleView()
        _titleView.isHidden = true
        navigationItem.titleView = _titleView

        /////TTPostCommentSuccessNotification
        NotificationCenter.default.addObserver(self, selector: #selector(postCommentSuccessAction(_ :)), name: TTPostCommentSuccessNotification, object: nil)
        
        loadComment()
    }

    @objc func postCommentSuccessAction(_ noti:NSNotification) {
        loadComment()
    }
    
    


    //MARK: -
    func titleView() -> UIView {
        let _bgview = UIView (frame: CGRect (x: 0, y: 0, width: 30, height: 30))

        let icon = UIImageView (frame: CGRect (x: 0, y: 0, width: _bgview.frame.height, height: _bgview.frame.height))
        icon.image = UIImage (named: "avatar_default")
        icon.layer.cornerRadius = _bgview.frame.height / 2
        icon.layer.masksToBounds = true
        _bgview.addSubview(icon)
        
        //icon
        if let dic = data["user"] as? [String:Any]{
            if let igurl = dic["avatar"] as? String {
                let url = URL.init(string: igurl)
                icon.kf.setImage(with: url, placeholder: UIImage (named: "avatar_default"))
            }
        }

        
        //....
        let btn = UIButton (frame: CGRect (x: icon.frame.maxX + 10, y: 0, width: 60, height: 25))
        btn.backgroundColor = UIColor (red: 17/255.0, green: 135/255.0, blue: 212/255.0, alpha: 1)
        btn.setTitle("关注", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        btn.layer.cornerRadius = 5
        btn.layer.masksToBounds = true
        btn.addTarget(self, action: #selector(watchBtnAction), for: .touchUpInside)
        //_bgview.addSubview(btn)
        
        return _bgview
    }
    
    @objc func watchBtnAction() {
        //关注
        
    }
    
    
    //MARK: - 
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        _titleView.isHidden = !(scrollView.contentOffset.y > 60)
    }
    
    
    deinit {
        print("HomeDetailController deinit")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    



}
