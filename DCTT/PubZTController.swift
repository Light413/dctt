//
//  PubZTController.swift
//  DCTT
//
//  Created by wyg on 2018/9/13.
//  Copyright © 2018年 Light.W. All rights reserved.
//

import UIKit

class PubZTController: PubBaseTableViewController {
    @IBOutlet weak var imgagesCell: TableCellWithCollectionView!
    
    @IBOutlet weak var textCell: UITextView!
    
    @IBOutlet weak var main_title: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

         imgagesCell.superVC = self
        sourceTextView = textCell
        
        typeId = "6"
    }

    override func willPost() {
        imgDataArr = imgagesCell.imagesArr
    }
    
    override func startPost(_ ig:[UIImage]? = nil)  {
        guard let uid = User.uid() else { HUD.showText("请前往登录", view: view);return}
        
        let sjInfo = ["title":String.isNullOrEmpty(main_title.text),
                      "content":String.isNullOrEmpty(textCell.text)]
        
        _post(uid, pars: sjInfo, ig: ig)
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

 

}
