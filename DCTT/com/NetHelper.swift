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
func netHelper_download(fromUrl path:String,
              to:String,
              parameters:Parameters? = nil,
              downloadProgress:((Progress) -> Void)? = nil ,
              completionResponse:((DownloadResponse<Any>) -> Void)? = nil)
{
    let downloadDestation:DownloadRequest.DownloadFileDestination = {_,_ in
        let des = URL (fileURLWithPath: to)
        return (des,[DownloadRequest.DownloadOptions.removePreviousFile, .createIntermediateDirectories])
    }
    
    Alamofire.download(path, parameters: nil, headers: nil, to: downloadDestation).downloadProgress { (progress) in
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
/// - parameter failureHandler: failure
func netHelper_request(withUrl:String,
                       method:HTTPMethod = .get,
                       parameters:[String:Any]? = nil,
                       encoding: ParameterEncoding = URLEncoding.default,
                       successHandler:(([String:Any]) -> Void)? = nil,
                       failureHandler:((String?) -> Void)? = nil)
{
//    if let delegate = UIApplication.shared.delegate as? AppDelegate{
//        guard delegate._networkReachabilityManager.isReachable else {HUD.show(info: "unable to connect to the network, please check the network Settings!"); return}
//    }
    
    
    guard withUrl.lengthOfBytes(using: String.Encoding.utf8) > 0 else { return}
    var header:HTTPHeaders = [:]
    if let token = UserDefaults.standard.value(forKey: "user-token") as? String {
        header["Authorization"] = token;
    }

    Alamofire.request(BASE_URL + withUrl, method: method, parameters: parameters, encoding:encoding, headers: header)
        .validate()
        .responseJSON { (dataResponse) in
            DispatchQueue.main.async {
                switch dataResponse.result {
                case .success(let value):
                    if let dic = value as? [String:Any] ,let status = dic["status"] {
                        if "\(status)" == "200" {
                            if let success = successHandler {
                                success(dic);
                            }
                        }else{
                            //print(dic)
                            if let failure = failureHandler {
                                failure(dic["msg"] as? String)
                            } else {
                                HUD.show(info: "\(dic["msg"])");
                            }
                        }
                    }
                    break
                    
                case .failure(let error):
                    print(dataResponse.response?.statusCode);
                    
                    if let code = dataResponse.response?.statusCode {
                        HUD.show(info: "Response ErrorCode:\(code)");
                    }else {
                        HUD.show(info: error.localizedDescription);
                    }
                    break
                }
            }
    }

}



func request(_ url :String,
    parameters:[String:Any]? = nil,
             successHandler:(([String:Any]) -> Void)? = nil,
             failureHandler:((String?) -> Void)? = nil)
{

    netHelper_request(withUrl: url, method: .post, parameters: parameters, successHandler: successHandler, failureHandler: failureHandler);

}

func requestJSONEncoding(_ url :String,
                 parameters:[String:Any]? = nil,
                 successHandler:(([String:Any]) -> Void)? = nil,
                 failureHandler:((String?) -> Void)? = nil)
{
    netHelper_request(withUrl: url, method: .post, parameters: parameters, encoding: JSONEncoding.default, successHandler: successHandler, failureHandler: failureHandler);
}



//MARK: - 上传文件
func netHelper_upload(to:String,
            parameters:[String:Any]? = nil,
            uploadFiles:[Any]? = nil,
            successHandler:((Any) -> Void)? = nil,
            failureHandler:((Void) -> Void)? = nil)
{
    var header:HTTPHeaders = [:]
    if let token = UserDefaults.standard.value(forKey: "user-token") as? String {
        header["Authorization"] = token;
        header["content-type"] = "multipart/form-data"
    }

    Alamofire.upload(multipartFormData: { (multipartData) in
        if let fils = uploadFiles {
            for obj in fils {
                if obj is UIImage {
                    let ig = obj as! UIImage
                    let data  = UIImageJPEGRepresentation(ig, 0.5);
                    if let d = data {
                        let fileName = Tools.dateToString(Date(), formatter: "yyyyMMddHHmmss").appending("\(arc4random()%10000)")
                        multipartData.append(d, withName: "files[]", fileName: "\(fileName).jpg", mimeType: "image/jpeg");//image/jpeg ，image/png
                    }
                }else{
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
        }
    }, to: to, headers: header) { (encodingResult) in
        switch encodingResult {
        case .success(request: let upload, streamingFromDisk: _, streamFileURL:_):
            upload.responseJSON(completionHandler: {  (res) in
                print("111");
                if let success = successHandler {
                    success(res);
                }
            })
            break;
            
        case .failure(let error):
            print("2222")
            if let fail = failureHandler {
                fail();
            }

            print(error.localizedDescription);break
        }
    }
}


///download image
/*func requestImage(_ id:String , completionHandler:((UIImage) -> Void)? = nil) {
    let url = BASE_URL + download_url + "?id=\(id)"
    let path = NSTemporaryDirectory().appending("cache/") + id
    let exist = FileManager.default.fileExists(atPath: kTemporaryDirectory)
    
    if exist {
        if FileManager.default.fileExists(atPath: path) {
            do {
                let data = try Data.init(contentsOf:  URL.init(fileURLWithPath: path))
                let ig = UIImage.init(data: data)
                if let handler = completionHandler , let _ig = ig {
                    handler(_ig);
                }
                return;
            }catch{
                print("get error");
            }
        }
    }else {
        do{
            try FileManager.default.createDirectory(atPath: kTemporaryDirectory, withIntermediateDirectories: true, attributes: nil);
        }catch {
            print("createDirectory Error");
        }
    }
    
    
    var header:HTTPHeaders = [:]
    if let token = UserDefaults.standard.value(forKey: "user-token") as? String {
        header["Authorization"] = token;
    }
    
    Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: header).responseData(queue: DispatchQueue.main) { (data) in

        guard let da = data.result.value  else{return}
        let ig = UIImage.init(data: da)
        if let handler = completionHandler , let _ig = ig{
            handler(_ig);
        }

        do{
            try da.write(to: URL.init(string: path)!);
        }catch{
            print("error");
        }
        
    }
}*/







