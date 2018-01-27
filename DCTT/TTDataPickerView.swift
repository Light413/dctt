//
//  TTDataPickerView.swift
//  DCTT
//
//  Created by wyg on 2018/1/27.
//  Copyright © 2018年 Light.W. All rights reserved.
//

import UIKit

class TTDataPickerView: TTBasePickerView,UIPickerViewDelegate,UIPickerViewDataSource {

    static var `default` = TTDataPickerView.init(frame: UIScreen.main.bounds)
    
    private var completionHandler:((String) -> Void)?
    private var datePicker:UIPickerView!
    private var _row:Int = 0
    
    class func show(_ withCompleteHandler:((String) -> Void)? = nil) {
        //remove from superview
        let _instance = TTDataPickerView.default
        guard let _contentview = _instance._contentview else{return}
        for _v in _contentview.subviews {
            if _v.isKind(of: UIPickerView.self){
                _v.removeFromSuperview();
            }
            
        }
        
        //add contentview
        let datePicker = UIPickerView.init(frame: CGRect (x: 0, y: _instance.kTopButtonHeight, width: _contentview.frame.width, height: _contentview.frame.height - _instance.kTopButtonHeight))
        
        datePicker.delegate = _instance
        datePicker.dataSource = _instance
        _contentview.addSubview(datePicker)
        
        _instance.completionHandler = withCompleteHandler
        _instance.datePicker = datePicker
        
        //show
        _instance.show()
    }
    
    override func finishedButtonClicked() {
        
        if let hander = completionHandler {
            hander("\(arr[_row])")
        }
        
        
    }
    
    let arr = [1,2,3,4,5,6]
    ///UIPickerViewDelegate
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(arr[row])"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        _row = row
    }
    
    //UIPickerViewDataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arr.count
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 45
    }
    
    
}
