//
//  User.swift
//  DCTT
//
//  Created by gener on 2018/8/2.
//  Copyright © 2018年 Light.W. All rights reserved.
//

import Foundation

struct User {
    static var userInfo:[String:Any]? {
        if let arr = UserDefaults.standard.value(forKey: "userinfo") as? [String:Any] {
            return arr;
        }
    }

    static var name:String?{
        if let name = userInfo?["name"] as? String {
            return name;
        } else if let name = userInfo?["nickName"] as? String {
            return name;
        }
    }
    
    static let isLogined:Bool = User.userInfo != nil
    static let token:String? = User.getValue("token")
    static let age  = User.getValue("age")
    static let uid  = User.getValue("user_id")
    static let avatarUrl  = User.getValue("avatar")
    static let location  = User.getValue("location")
    static let notes  = User.getValue("notes")
    static let score  = User.getValue("score")
    static let fans  = User.getValue("fans")
    static let praise  = User.getValue("praise")
    static let sex  = User.getValue("sex")
    static let phoneNumber  = User.getValue("phone_number")
    static let pwd  = User.getValue("pwd")

    private static func  getValue(_ key:String) -> String? {
        if let v = userInfo?[key] {
            return "\(v)";
        }
    
    }
    
    
}
