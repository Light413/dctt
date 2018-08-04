//
//  TTDatePickerView.swift
//  DCTT
//
//  Created by wyg on 2018/1/27.
//  Copyright © 2018年 Light.W. All rights reserved.
//

import UIKit

class TTDatePickerView: TTBasePickerView {
    static var `default` = TTDatePickerView.init(frame: UIScreen.main.bounds)

    private var completionHandler:((String ,Int) -> Void)?
    private var datePicker:UIDatePicker!
    
    class func show(_ withCompleteHandler:((String ,Int) -> Void)? = nil) {
        //remove from superview
        let _instance = TTDatePickerView.default
        guard let _contentview = _instance._contentview else{return}
        for _v in _contentview.subviews {
            if _v.isKind(of: UIDatePicker.self){
                _v.removeFromSuperview();
            }
            
        }
        
        //add contentview
        let datePicker = UIDatePicker.init(frame: CGRect (x: 0, y: _instance.kTopButtonHeight, width: _contentview.frame.width, height: _contentview.frame.height - _instance.kTopButtonHeight))
        
        datePicker.datePickerMode = .date
        datePicker.maximumDate = Date()
        _contentview.addSubview(datePicker)
        
        _instance.completionHandler = withCompleteHandler
        _instance.datePicker = datePicker
        
        //show
        _instance.show()
    }
    
    override func finishedButtonClicked() {
        let formatter = DateFormatter.init()
        formatter.dateFormat = "yyyy-MM-dd"
        
        let selected_year = formatter.string(from: datePicker.date)
        let this_year = formatter.string(from: Date())
        
        //let age = Int.init(this_year)! - Int.init(selected_year)!
        
        if let hander = completionHandler {
            hander(selected_year,0)
        }
        
        
    }
    
}
