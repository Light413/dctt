//
//  TTScrollViewController.swift
//  DCTT
//
//  Created by wyg on 2017/11/19.
//  Copyright © 2017年 Light.W. All rights reserved.
//

import UIKit

class TTScrollViewController: UIViewController ,UIScrollViewDelegate{

    let _scrollview = UIScrollView()
    var viewControllers:[UIViewController]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false;
        
        _init()
    }

    
    func _init() {
        _scrollview.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        _scrollview.contentSize = CGSize (width: kCurrentScreenWidth * CGFloat.init(viewControllers.count), height: view.frame.height)
        _scrollview.isPagingEnabled = true
        _scrollview.showsHorizontalScrollIndicator = false
        _scrollview.alwaysBounceVertical = false
        _scrollview.delegate = self
        
        view.addSubview(_scrollview)
        
        
        for i in 0..<viewControllers.count {
            let vc = viewControllers[i];
            vc.view.frame = CGRect(x: CGFloat.init(i) * kCurrentScreenWidth, y: 0, width: _scrollview.frame.width, height: _scrollview.frame.height)
            self.addChildViewController(vc)
            _scrollview.addSubview(vc.view)
        }
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        print(#function)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
