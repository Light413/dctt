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
    private var completionHandler:((Any) -> Void)?
    private var datePicker:UIPickerView!
    private var dataArray:[Any] = []
    private var numberOfComponents:Int = 1
    private var selectedMultiComponents:(first:Int,second:Int) = (0,0)
    
    class func show(_ dataArray:[Any],components:Int = 1 , withCompleteHandler:((Any) -> Void)? = nil) {
        //remove from superview
        let _instance = TTDataPickerView.default
        _instance.dataArray = dataArray;
        _instance.numberOfComponents = components
        _instance.selectedMultiComponents = (0,0)
    
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
            if numberOfComponents == 1{
                hander(dataArray[selectedMultiComponents.first]);
            } else if numberOfComponents == 2 {
                let d = dataArray[selectedMultiComponents.first] as! [String:Any]
                let province = d["province"] as! String
                var res = ["province":province ]
                
                if let arr = d["areas"] as? [String], arr.count > 0 {
                  let city = arr[selectedMultiComponents.second]
                    res["city"] = city
                }
                
                
                hander(res)
            }
            
        }

    }
    
    ///UIPickerViewDelegate
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if numberOfComponents == 1 {
            return "\(dataArray[row])"
        } else if numberOfComponents == 2 {
            if component == 0 {
                let d = dataArray[row] as! [String:Any]
                return d["province"] as? String
            }else {
                let d = dataArray[selectedMultiComponents.first] as! [String:Any]
                let arr = d["areas"] as! [String]
                return arr[row]
            }
        }
       
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if numberOfComponents == 1 {
            selectedMultiComponents.first = row

        }else if numberOfComponents == 2 {
            if component == 0 {
                selectedMultiComponents.first = row
                selectedMultiComponents.second = 0
                pickerView.reloadComponent(1)
                pickerView.selectRow(0, inComponent: 1, animated: true)
            }else if component == 1 {
                selectedMultiComponents.second = row
            }
        }
        
    }
    
    //UIPickerViewDataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return numberOfComponents
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0  {
            return dataArray.count;
        } else if component == 1 {
            let d = dataArray[selectedMultiComponents.first] as! [String:Any]
            let arr = d["areas"] as! [String]
            return arr.count
        }
        
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 45
    }
    
}
