//
//  TTRefreshFooter.swift
//  DCTT
//
//  Created by gener on 2017/12/4.
//  Copyright © 2017年 Light.W. All rights reserved.
//

import UIKit
import MJRefresh

class TTRefreshFooter: MJRefreshAutoFooter {

    weak var title:UILabel!
    weak var loading:UIActivityIndicatorView!
    
    override func prepare() {
        super.prepare()
        self.mj_h = 50
        
        let _l = UILabel()
        _l.font = UIFont.systemFont(ofSize: 13)
        _l.textColor = UIColor.darkGray
        _l.textAlignment = .center
        self.addSubview(_l)
        self.title = _l
        
        let _loading = UIActivityIndicatorView.init(activityIndicatorStyle: .gray)
        self.addSubview(_loading)
        self.loading = _loading
    }
    
    
    override func placeSubviews() {
        super.placeSubviews()
        
        self.title.frame = self.bounds
        self.loading.center = self.title.center
    }
    
    
    override func scrollViewPanStateDidChange(_ change: [AnyHashable : Any]!) {
        super.scrollViewPanStateDidChange(change);
    }
    
    override func scrollViewContentOffsetDidChange(_ change: [AnyHashable : Any]!) {
        super.scrollViewContentOffsetDidChange(change)
    }
    
    override func scrollViewContentSizeDidChange(_ change: [AnyHashable : Any]!) {
        super.scrollViewContentSizeDidChange(change)
    }
    
    
    
    override var pullingPercent: CGFloat {
        get {
            return super.pullingPercent;
        }
        set{
            super.pullingPercent = newValue;
        }
    }

    
    override var state: MJRefreshState {
        get{
            return super.state;
        }
        set {
            let old = self.state
            if old == newValue {
                return;
            }
            
            super.state = newValue
            switch newValue {
            case .idle:
                self.loading.stopAnimating()
                self.title.text = "上拉加载更多"
                break
                
            case .refreshing:
                self.loading.startAnimating()
                self.title.text = nil
                break
                
            case .noMoreData:
                self.title.text = "已经是最后一条啦"
                self.loading.stopAnimating()
                break
                
            default:break
            }
            
        }
        
    }

}


