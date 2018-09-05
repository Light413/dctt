//
//  PublishFriendViewController.swift
//  DCTT
//  发布朋友圈
//  Created by wyg on 2018/2/3.
//  Copyright © 2018年 Light.W. All rights reserved.
//

import UIKit
import Photos

class PublishFriendViewController: BasePublishController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.        
        kMaxImagesNumber = 1
        
    }
    

   override func _post(_ ig:[UIImage]? = nil)  {
 
    guard let uid = User.uid() else {
        HUD.showText("请前往登录", view: view);return
    }
    
    HUD.show()
    let d = ["uid":uid,
             "content":String.isNullOrEmpty(textCell.textview.text),
             "tab":"1",
             "type":"0"]

        AlamofireHelper.upload(to: publish_url, parameters: d, uploadFiles: ig, successHandler: { (res) in
            print(res)
            HUD.show(successInfo: "发布成功!");
        }) {
           print("upload faile");
        }
        
    }
    

    
    //MARK:
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:return 1;
        case 1:return imgDataArr.count > 0 ? 1 :  1;
        case 2:return 0;
        default:return 0;
        }
        
    }
    

    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize (width: kCurrentScreenWidth - 20, height: 100)
        }
        
        let _w = (kCurrentScreenWidth - 20 )
        
        return imgDataArr.count > 0 ? CGSize (width: _w, height: _w * 1): CGSize (width: _w / 3.0, height: 100)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
