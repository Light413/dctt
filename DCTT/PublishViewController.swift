//
//  PublishViewController.swift
//  DCTT
//  发布动态
//  Created by wyg on 2017/11/11.
//  Copyright © 2017年 Light.W. All rights reserved.
//

import UIKit
import Photos

class PublishViewController: BasePublishController {
    ///发布内容类型
    /**
     1.新鲜事
     2.问答
     3.吐槽
     4.活动
     5.娱乐
     */
    private var _type:String!
    private var _isPublishFriend:Bool = false//发布朋友圈
    
    init(_ type:String) {
        super.init(nibName: nil, bundle: nil)
        
        _type = type
        
        ///发布朋友圈
        if type == "6" {
            kMaxImagesNumber = 1
            _isPublishFriend = true
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func _post(_ ig:[UIImage]? = nil)  {
        guard let uid = User.uid() else {
            HUD.showText("请前往登录", view: view);return
        }
        
        HUD.show()
        let d = ["uid":uid,
                 "content":String.isNullOrEmpty(textCell.textview.text),
                 "type":_type!]
        
        AlamofireHelper.upload(to: publish_url, parameters: d, uploadFiles: ig, successHandler: { [weak self] (res) in
            print(res)
            HUD.show(successInfo: "发布成功!");
            guard let ss = self else {return}
            
            ss.dismiss(animated: true, completion: nil)
            
        }) {
            print("upload faile");
        }
        
    }
    

    
    //MARK:
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:return 1;
        case 1:
            if _isPublishFriend {
                return  1;
            }else{
                return imgDataArr.count + 1 > 9 ? 9 : imgDataArr.count + 1;
            }
        case 2:return 0;
        default:return 0;
        }

    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
