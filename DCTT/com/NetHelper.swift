//
//  NetHelper.swift
//  JobCard
//
//  Created by gener on 17/11/3.
//  Copyright © 2017年 Light. All rights reserved.
//

import Foundation
import Alamofire

//MARK:-

/// download file from url
///
/// - parameter path:               file location
/// - parameter to:                 destation to save
/// - parameter downloadProgress:   progress
/// - parameter completionResponse: complete handler
func download(fromUrl path:String,
              to:String,
              downloadProgress:((Progress) -> Void)? = nil ,
              completionResponse:((DownloadResponse<Any>) -> Void)? = nil)
{
    let downloadDestation:DownloadRequest.DownloadFileDestination = {_,_ in
        let des = URL (fileURLWithPath: to)
        return (des,[DownloadRequest.DownloadOptions.removePreviousFile, .createIntermediateDirectories])
    }
    
    Alamofire.download(path, to: downloadDestation).downloadProgress { (progress) in
        if let progressHandler = downloadProgress {
            progressHandler(progress)
        }
        }.responseJSON { (response) in
            if let completeHandler = completionResponse {
                completeHandler(response)
            }
    }
    
}


/// Request
///
/// - parameter withUrl:        url
/// - parameter method:         method
/// - parameter parameters:     pars
/// - parameter successHandler: successHandler
/// - parameter failureHandler: <#failureHandler description#>
func netHelper_request(withUrl:String,
                       method:HTTPMethod = .get,
                       parameters:[String:Any]? = nil,
                       successHandler:((Any) -> Void)? = nil,
                       failureHandler:((Void) -> Void)? = nil)
{
    guard withUrl.lengthOfBytes(using: String.Encoding.utf8) > 0 else { return}
    Alamofire.request(withUrl, method: method, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (dataResponse) in
        DispatchQueue.main.async {
            if let dic = dataResponse.result.value as? [String:Any] ,let status = dic["status"] {
                if "\(status)" == "200" {
                    if let success = successHandler {
                        success(dic);
                    }
                }else{
                    if let failure = failureHandler {
                        failure();
                    }
                }
            }else{
                if let failure = failureHandler {
                    failure();
                }
                
            }
        }
   
    }
    
}



