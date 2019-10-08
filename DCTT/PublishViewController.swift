//
//  PublishViewController.swift
//  DCTT
//  发布动态
//  Created by wyg on 2017/11/11.
//  Copyright © 2017年 Light.W. All rights reserved.
//

import UIKit
import Photos

class PublishViewController: BasePublishController,ShowAlertControllerAble {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ///弹框提示已同意用户协议
        showTipsBeforePublish()
    }
    
    
    
    override func _post(_ ig:[UIImage]? = nil)  {
        guard let uid = User.uid() else {
            HUD.showText("请前往登录", view: view);return
        }
        
        HUD.show()
        let d = ["uid":uid,
                 "content":String.isNullOrEmpty(textCell.textview.text),
                 "type":typeId!]
        
        AlamofireHelper.upload(to: publish_url, parameters: d, uploadFiles: ig, successHandler: { [weak self] (res) in
            HUD.show(successInfo: "发布成功!");
            guard let ss = self else {return}
            print(res)
            
            let vc = UIAlertController.init(title: "发布成功",message: "感谢你的参与，系统24小时内进行审核通过后才会显示", preferredStyle: .alert);
            let action2 = UIAlertAction.init(title: "我知道了", style: .default) { (action) in
                NotificationCenter.default.post(name: kHasPublishedSuccessNotification, object: nil, userInfo: ["type":ss.typeId!])
                
                ss.dismiss(animated: true, completion: nil)
            }
            
            vc.addAction(action2)
            ss.navigationController?.present(vc, animated: true, completion: nil);
        }) {
            print("upload faile");
        }
        
    }
    
    //MARK:
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:return 1;
        case 1: return imgDataArr.count + 1 > 9 ? 9 : imgDataArr.count + 1;
        case 2:return 0;
        default:return 0;
        }

    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
