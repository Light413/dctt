//
//  Tools.swift
//  mcs
//
//  Created by gener on 2018/1/23.
//  Copyright © 2018年 Light. All rights reserved.
//

import UIKit

class Tools: NSObject {

    static let `default` = Tools()
    
   //MARK:-
   static func stringToDate(_ dateStr:String, formatter:String = "yyyy") -> Date {
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = formatter
        
        return dateFormatter.date(from: dateStr)!
    }
    
    static func dateToString(_ date:Date, formatter:String = "yyyy") -> String {
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = formatter
        
        return dateFormatter.string(from: date)
    }
    

    //时间戳 -> Date
    static func date(_ s:String) -> Date? {
        guard let sec = TimeInterval.init(s)  else {
            return nil
        }
        
        let date = Date.init(timeIntervalSince1970: sec / 1000.0)
        
        return date
        
    }
    
   
    static func showMsg( _ msg:String , title:String , handler:@escaping (() -> Void)) {
        
        let vc = UIAlertController.init(title: msg,message: nil, preferredStyle: .alert)
        let action = UIAlertAction.init(title:"取消", style: .default)
        let action2 = UIAlertAction.init(title: title, style: .destructive) { (action) in
            handler();
        }
        
        vc.addAction(action)
        vc.addAction(action2)
        UIApplication.shared.keyWindow?.rootViewController?.present(vc, animated: true, completion: nil);
    }

    
    ///不喜欢的动态处理
    private func _dislikePath() -> String? {
        guard let p = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else {return nil}
       return p + "/dislike"
    }
    
    func getDislikeData() -> [String:[String]]? {
        guard let path = _dislikePath() else {return nil}
        let d = NSKeyedUnarchiver.unarchiveObject(withFile: path) as? [String:[String]]
        return d
    }
    
    func addDislike(_ pid:String) {
        var _newArr = [String]()
        
        if let d = getDislikeData() , let arr = d["dislike"] {
            _newArr = arr
            if (!_newArr.contains(pid)){
                _newArr.append(pid)
            }
            
        }else{
            _newArr = [pid]
        }
        
        guard let p = _dislikePath() else {return}
        NSKeyedArchiver.archiveRootObject(["dislike":_newArr], toFile: p)
        
        HUD.showText("将不再为你推送此类内容!", view: kAPPKeyWindow)
    }
    
    func filterDislikeData(_ ds:[[String:Any]]) -> [[String:Any]] {
        if let _disks = getDislikeData() , let _disksArr = _disks["dislike"] {
            var new = [[String:Any]]()
            
            for d in ds {
                let pid =  String.isNullOrEmpty(d["pid"])
                if !_disksArr.contains(pid){
                    new.append(d)
                }
            }
            
            return new
        }else {
            
            return ds
        }
    }
    
    /*
    //MARK: - show pop
    static func showAlert(_ vcname:String , withBar:Bool = true , frame:CGRect = CGRect(x: 0, y: 0, width: 500, height: 360)) {
        let appname = Bundle.main.infoDictionary!["CFBundleExecutable"] as! String
        let cls  =  NSClassFromString(appname + "." + vcname) as! BaseViewController.Type
        let vc = cls.init()
        vc.view.frame = frame
        
        Tools.default._show(vc, withBar: true, frame: frame);
    }
    
    static func showVC(_ vc:UIViewController , withBar:Bool = true , frame:CGRect = CGRect(x: 0, y: 0, width: 500, height: 360)) {
        vc.view.frame = frame
        Tools.default._show(vc, withBar: true, frame: frame);
    }
    
    func _show(_ vc:UIViewController , withBar:Bool = true , frame:CGRect ) {
        if withBar {
            let nav = BaseNavigationController(rootViewController:vc)
            nav.navigationBar.barTintColor = kPop_navigationBar_color
            nav.modalPresentationStyle = .formSheet
            nav.preferredContentSize = frame.size
            UIApplication.shared.keyWindow?.rootViewController?.present(nav, animated: true, completion: nil)
        } else {
            vc.modalPresentationStyle = .formSheet;
            vc.preferredContentSize = frame.size
            UIApplication.shared.keyWindow?.rootViewController?.present(vc, animated: true, completion: nil)
        }

    }
    
    
    static func showDatePicekr(_ s:UIViewController? = nil , handler:((Any) -> Void)? = nil){
        let vc = DatePickerController.init()
        let frame = CGRect (x: 0, y: 0, width: 500, height: 240)
        vc.view.frame = frame
        
        vc.pickerDidSelectedHandler = handler
        
        let nav = BaseNavigationController(rootViewController:vc)
        nav.navigationBar.barTintColor = kPop_navigationBar_color
        nav.modalPresentationStyle = .formSheet
        nav.preferredContentSize = frame.size
        
        if let ss = s {
            ss.present(nav, animated: true, completion: nil)
        }else {
            UIApplication.shared.keyWindow?.rootViewController?.present(nav, animated: true, completion: nil);
        }

    }
    
    
    static func showDataPicekr(_ s:UIViewController? = nil , dataSource:[Any]? = nil, handler:((Any) -> Void)? = nil){
        let vc = DataPickerController.init()
        let frame = CGRect (x: 0, y: 0, width: 500, height: 240)
        if let station = dataSource {
            vc.dataArray = station;
        }
        
        vc.view.frame = frame
        //vc.dataType = .obj
        vc.pickerDidSelectedHandler = handler
        
        let nav = BaseNavigationController(rootViewController:vc)
        nav.navigationBar.barTintColor = kPop_navigationBar_color
        nav.modalPresentationStyle = .formSheet
        nav.preferredContentSize = frame.size
        
        if let ss = s {
            ss.present(nav, animated: true, completion: nil)
        }else {
            UIApplication.shared.keyWindow?.rootViewController?.present(nav, animated: true, completion: nil);
        }
    
    }
    
    
    
    
    //MARK: - 获取基础数据
    static func loginUserName() -> String {
        if let name = UserDefaults.standard.value(forKey:"user-name") as? String {
            return name;
        }
        return ""
    }
    

    
    
    
    //MARK:- private
    static func user_role() -> String {
        if let s = UserDefaults.standard.value(forKey: "user-role") as? String {
            return s;
        }
        
        return ""
    }
    */
    
    
    
    
    
    
    
    
    
}
