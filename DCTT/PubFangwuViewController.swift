//
//  PubFangwuViewController.swift
//  DCTT
//
//  Created by wyg on 2018/3/4.
//  Copyright © 2018年 Light.W. All rights reserved.
//

import UIKit

class PubFangwuViewController: PubBaseTableViewController {
    @IBOutlet weak var imgagesCell: TableCellWithCollectionView!
    
    @IBOutlet weak var typeSeg: UISegmentedControl!
    @IBOutlet weak var textCell: UITextView!
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
        
        let sjInfo = ["type":String.isNullOrEmpty(typeSeg.selectedSegmentIndex),
                      "content":String.isNullOrEmpty(textCell.text)]
        
        _post(uid, pars: sjInfo, ig: ig)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
