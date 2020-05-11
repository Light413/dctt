//
//  MessageCell.swift
//  DCTT
//
//  Created by wyg on 2018/3/25.
//  Copyright © 2018年 Light.W. All rights reserved.
//

import UIKit
import SwiftyJSON

class MessageCell: UITableViewCell {

    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var msgType: UILabel!
    @IBOutlet weak var content: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func fill(_ d:[String:Any]) {
        //name
        var s = ""
        let _name = String.isNullOrEmpty(d["u_name"]);
        
        if _name.lengthOfBytes(using: String.Encoding.utf8) > 0  {
            s =  "\(_name)";
        }
        else
            if let name = d["u_nickName"] as? String {
                s = "\(name)";
        }
        
        name.text = s
        
        //avatar
        if let igurl = d["u_avatar"] as? String {
            let url = URL.init(string: igurl)
            avatar.kf.setImage(with: url, placeholder: UIImage (named: "avatar_default"))
        }
        
        time.text = Date.dateFormatterWithString(String.isNullOrEmpty(d["date"]))
        
        
        ///type
        let type = String.isNullOrEmpty(d["type"])
        switch type {
            case "1":msgType.text = "关注了你";
                content.text = nil;break
            case "2":msgType.text = "赞了你的动态";break
            case "3":msgType.text = "评论了你的动态";break
            default:msgType.text = nil;break
        }
        
        /*d 数据格式
        [
            "commenterUid" ,""
            "commenterName",""
            "type":"2"
            "content":[//jsonstr
                "postContent":"base64Str"//动态数据详情
                "category":"动态类型"
            ]
            
        ]*/
        
        if type == "2" || type == "3" {
            var str = ""
            let postStr = String.isNullOrEmpty(d["content"])
            do{
                if let post = try JSONSerialization.jsonObject(with: postStr.data(using: String.Encoding.utf8)!, options: []) as? [String:Any]{
                    
                    let postDetailBase64str = String.isNullOrEmpty(post["postContent"])
                    let data = NSData.init(base64Encoded: postDetailBase64str, options: [])
                    do{
                        ///动态详情对象
                        let postDetailObj = try JSON.init(data: data! as Data)

                        ///首页类型的字符串直接显示，其他类型是json字符串要继续解析
                        let content1 = String.isNullOrEmpty(postDetailObj["content"])
                        if String.isNullOrEmpty(post["category"]) == kCategory_home {
                            str = content1;
                        }else{
                            let obj2 = JSON.init(parseJSON: content1)
                            str = String.isNullOrEmpty(obj2["content"])
                        }
                        
                    }catch {
                        print("postContent 解析失败")
                    }
                    
                    if type == "3"{
                        msgType.text = "评论: " + String.isNullOrEmpty(post["commentDetail"])
                    }
                    
                }
                
            }catch{
                print(error.localizedDescription)
            }
            
            let attri = NSMutableAttributedString.init(string: str, attributes: convertToOptionalNSAttributedStringKeyDictionary([:]))//[NSBackgroundColorAttributeName:kTableviewBackgroundColor]
            
            content.attributedText = attri
        }

    }
    
    
    override func prepareForReuse() {
        msgType.text = nil
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}
