//
//  CategorySectionHeaderView.swift
//  DCTT
//
//  Created by gener on 2018/2/27.
//  Copyright © 2018年 Light.W. All rights reserved.
//

import UIKit

class CategorySectionHeaderView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    let _line = UILabel()
    let line_h:CGFloat = 1
    
    var _selectedBtn:UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let w :CGFloat = 80
        let h = frame.height
        let _titles = ["最新发布"]
        
        for i in 0..<_titles.count {
            let btn = UIButton (frame: CGRect (x: i == 0 ? 0 : w, y: 0, width: w, height: h - line_h));
            //btn.backgroundColor = UIColor.white
            btn.setTitle(_titles[i], for: .normal)
            btn.setTitleColor(UIColor.darkGray, for: .selected)
            btn.setTitleColor(UIColor.darkGray, for: .normal)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
            
            btn.addTarget(self, action: #selector(clickedAction(_:)), for: .touchUpInside)
            btn.tag = 100 + i
            
            if i == 0 {
                btn.isSelected = true
                _selectedBtn = btn;
                
            }

            self.addSubview(btn)
        }
        
        
//        _line.frame = CGRect (x: (w - 50) / 2.0, y: h - line_h, width: 50, height: line_h)
//        _line.backgroundColor = tt_BarColor
        _line.frame = CGRect (x: 0, y: h - line_h - 1, width: self.frame.width, height: line_h)
        _line.backgroundColor = kTableviewBackgroundColor

        self.addSubview(_line)
        
        self.backgroundColor = tt_bg_color
    }
    
    
    @objc func clickedAction(_ button:UIButton) {
        guard _selectedBtn != button else { return }
        
        _selectedBtn.isSelected = false
        button.isSelected = true
        _selectedBtn = button
        
        UIView.animate(withDuration: 0.2) { [weak self] in
            
            guard let strongSelf = self else { return }
            strongSelf._line.center.x = button.center.x
        }
        
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func _initSubviews() {
        
    }
    
    
    
}
