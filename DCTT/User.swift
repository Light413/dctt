//
//  User.swift
//  DCTT
//
//  Created by gener on 2018/8/2.
//  Copyright © 2018年 Light.W. All rights reserved.
//

import Foundation

class User {
    static let `default` = User()
    
    func userInfo() -> [String:Any]? {
        if let data = UserDefaults.standard.value(forKey: "userinfo") as? Data {
            do {
                if let d =  try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String:Any]{
                    return d;
                }
                return nil
            }catch {
                
            }
        }
        
        return nil

    }
    
   static func name() -> String? {
        guard let dic = User.default.userInfo() else {return nil}
        if let name = dic["name"] as? String  {
            return "\(name)";
        }
        
        if let name = dic["nickName"] as? String {
            return "\(name)";
        }
        
        return nil
    }
    
    
   static func isLogined() -> Bool {
        return  User.default.userInfo() != nil
    }
    
   static func token() -> String? {
        guard let dic = User.default.userInfo() else {return nil}
        guard let token = dic["token"] as? String else {return nil}
        return token
    }
    
   static func uid() -> String? {
        guard let dic = User.default.userInfo() else {return nil}
        guard let user_id = dic["user_id"] as? String else {return nil}
        return user_id
    }
    
}
