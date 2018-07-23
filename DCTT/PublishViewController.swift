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
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func _post(_ ig:[UIImage]? = nil)  {
        
        HUD.show()
        let d = ["uid":"pub180163000",
                 "content":String.isNullOrEmpty(textCell.textview.text),
                 "type":"1"]
        
        AlamofireHelper.upload(to: publish_url, parameters: d, uploadFiles: ig, successHandler: { (res) in
            print(res)
            HUD.show(successInfo: "发布成功!");
        }) {
            print("upload faile");
        }
        
    }
    
    
    
    override func previewAction() {
        let vc = HomeDetailController()
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK:
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:return 1;
        case 1:return imgDataArr.count + 1 > 9 ? 9 : imgDataArr.count + 1;
        case 2:return 0;
        default:return 0;
        }

    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
