//
//  PubShangJiaController.swift
//  DCTT
//
//  Created by wyg on 2018/3/4.
//  Copyright © 2018年 Light.W. All rights reserved.
//

import UIKit

class PubShangJiaController: PubBaseTableViewController {

    @IBOutlet weak var imgagesCell: TableCellWithCollectionView!
    @IBOutlet weak var textCell: UITextView!
  
    @IBOutlet weak var sj_name: UITextField!
    
    @IBOutlet weak var sj_address: UITextField!
    
    @IBOutlet weak var sj_tel: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imgagesCell.superVC = self
        
        sourceTextView = textCell
        
    }

    override func willPost() {
        imgDataArr = imgagesCell.imagesArr
    }
    
    override func startPost(_ ig:[UIImage]? = nil)  {
        guard let uid = User.uid() else { HUD.showText("请前往登录", view: view);return}
        guard String.isNullOrEmpty(sj_name.text).lengthOfBytes(using: String.Encoding.utf8) > 0 else{ HUD.showText("请输入商家名称", view: view);return}
        guard String.isNullOrEmpty(sj_address.text).lengthOfBytes(using: String.Encoding.utf8) > 0 else{ HUD.showText("请输入商家地址", view: view);return}
        guard String.isNullOrEmpty(sj_tel.text).lengthOfBytes(using: String.Encoding.utf8) > 0 else{ HUD.showText("请输入联系方式", view: view);return}
        
        let sjInfo = ["name":String.isNullOrEmpty(sj_name.text),
                      "address":String.isNullOrEmpty(sj_address.text),
                      "tel":String.isNullOrEmpty(sj_tel.text),
                      "content":String.isNullOrEmpty(textCell.text)]
        
        _post(uid, pars: sjInfo, ig: ig)
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
