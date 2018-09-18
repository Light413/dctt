//
//  PubJiaoYouController.swift
//  DCTT
//
//  Created by wyg on 2018/3/4.
//  Copyright © 2018年 Light.W. All rights reserved.
//

import UIKit

class PubJiaoYouController: PubBaseTableViewController {


    @IBOutlet weak var imgagesCell: TableCellWithCollectionView!
    
    @IBOutlet weak var textCell: UITextView!
    
    @IBOutlet weak var textCellOther: UITextView!
    
    @IBOutlet weak var typeSeg: UISegmentedControl!
    
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
                      "content":String.isNullOrEmpty(textCell.text),
                      "hope":String.isNullOrEmpty(textCellOther.text)]
        
        _post(uid, pars: sjInfo, ig: ig)
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
