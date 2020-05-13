//
//  AlamofireHelper.swift
//  DCTT
//
//  Created by wyg on 2018/7/22.
//  Copyright © 2018年 Light.W. All rights reserved.
//

import UIKit
import Alamofire

class AlamofireHelper: NSObject {
    let base_url = BASE_URL
    static let `default` = AlamofireHelper()
    
    /// Request
    ///
    /// - parameter withUrl:        url
    /// - parameter method:         method
    /// - parameter parameters:     pars
    /// - parameter successHandler: successHandler
    /// - parameter failureHandler: failure
    public func request(url withUrl:String,
                       method:HTTPMethod = .post,
                       parameters:[String:Any]? = nil,
                       encoding: ParameterEncoding = URLEncoding.default,
                       successHandler:(([String:Any]) -> Void)? = nil,
                       failureHandler:((Error?) -> Void)? = nil)
    {
        //    if let delegate = UIApplication.shared.delegate as? AppDelegate{
        //        guard delegate._networkReachabilityManager.isReachable else {HUD.show(info: "unable to connect to the network, please check the network Settings!"); return}
        //    }
        
        
        guard withUrl.lengthOfBytes(using: String.Encoding.utf8) > 0 else { return}
        var header:HTTPHeaders = [:];
        var _pars:[String:Any] = parameters ?? [:];
        if let token = User.token() {
            header["Authorization"] = token; _pars["t"] = token;
            if User.isLogined() {
                _pars["uid"] = User.uid()!
            }
        }
        
        AF.request(base_url + withUrl, method: method, parameters: _pars, encoding:encoding, headers: header)
            .validate()
            .responseJSON { (dataResponse) in
                DispatchQueue.main.async {
                    switch dataResponse.result {
                        case .success(let value):
                            if let dic = value as? [String:Any] ,let status = dic["status"] as? Int {
                                if "\(status)" == "200" {
                                    if let success = successHandler {
                                        success(dic);
                                    }
                                }else{
                                    if let failure = failureHandler {
                                        let err = NSError.init(domain: "\(dic["msg"] ?? "")", code:status, userInfo: nil)
                                        failure(err)
                                    }
                                }
                            }
                            break
                        
                        case .failure(let error):
                            if let failure = failureHandler {
                                failure(error)
                            }
                            break
                    }
                }
        }
        
    }
    
    //MARK:- Public Methods
   static public func get(url:String ,
             parameters:[String:Any]? = nil,
             successHandler:(([String:Any]) -> Void)? = nil,
             failureHandler:((Error?) -> Void)? = nil)
    {
       AlamofireHelper.default.request(url: url,method:.get , parameters: parameters, successHandler: successHandler, failureHandler: failureHandler);
    }
    
   static public func post(url:String ,
              parameters:[String:Any]? = nil,
              successHandler:(([String:Any]) -> Void)? = nil,
              failureHandler:((Error?) -> Void)? = nil)
    {
        AlamofireHelper.default.request(url: url,method:.post , parameters: parameters, successHandler: successHandler, failureHandler: failureHandler);

    }
    
    //MARK: - upload
    ///上传多张图片
   public func upload(to:String,
                parameters:[String:Any]? = nil,
                uploadFiles:[Any]? = nil,
                successHandler:(([String:Any]) -> Void)? = nil,
                failureHandler:(() -> Void)? = nil)
    {
        let header:HTTPHeaders = ["content-type":"multipart/form-data"];
        AF.upload(multipartFormData: { (multipartData) in
            if let fils = uploadFiles {
                for obj in fils {
                    if obj is UIImage {
                        let ig = obj as! UIImage
                        let data  = ig.jpegData(compressionQuality: 0.4);
                        if let d = data {
                            let fileName = Tools.dateToString(Date(), formatter: "yyyyMMddHHmmss").appending("\(arc4random()%10000)")
                            multipartData.append(d, withName: "files[]", fileName: "\(fileName).jpg", mimeType: "image/jpeg");//image/jpeg ，image/png
                        }
                    }else{///
                    }
                }
            }
            
            if let pars = parameters {
                for (k , v) in pars {
                    var data:Data?
                    if v is String {
                        let s = v as! String
                        data = s.data(using: String.Encoding.utf8)
                    }else if v is [Any] {
                        let arr = v as! [Any];
                        if arr.count > 0 {
                            do {
                                data =  try JSONSerialization.data(withJSONObject: arr, options: []);
                            }catch{
                                print(error.localizedDescription);
                            }
                        }
                    } else if v is Data {
                        let d = v as! Data;
                        data = d;
                    }
                    
                    if let d = data {
                        multipartData.append(d, withName: k)
                    }
                }
                
                if let token = User.token() {
                    if let data = token.data(using: String.Encoding.utf8){
                        multipartData.append(data, withName: "t");
                    }
                }
                
            }
        }, to: base_url + to, headers: header).responseJSON(completionHandler: { (dataResponse) in
            print(dataResponse.result)
            DispatchQueue.main.async {
                 switch dataResponse.result {
                     case .success(let value):
                         if let dic = value as? [String:Any] ,let status = dic["status"] as? Int {
                             if "\(status)" == "200" {
                                 if let success = successHandler {
                                     success(dic);
                                 }
                             }else{
                                 if let failure = failureHandler {
                                     let err = NSError.init(domain: "\(dic["msg"] ?? "")", code:status, userInfo: nil)
                                    
                                    print(err.localizedDescription);
                                    
                                     failure()
                                 }
                             }
                         }
                         break
                     
                     case .failure(let error):
                         if let failure = failureHandler {
                             failure()
                         }
                         
                         print(error.localizedDescription);
                         break
                 }
             }
            
        });
    }
    
    //convenience methods
    static public func upload(to:String,
                parameters:[String:Any]? = nil,
                uploadFiles:[Any]? = nil,
                successHandler:(([String:Any]) -> Void)? = nil,
                failureHandler:(() -> Void)? = nil)
    
    {
        AlamofireHelper.default.upload(to: to, parameters: parameters, uploadFiles: uploadFiles, successHandler: successHandler, failureHandler: failureHandler);
    }
    
    
}
