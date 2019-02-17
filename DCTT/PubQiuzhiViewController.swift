//
//  PubQiuzhiViewController.swift
//  DCTT
//
//  Created by wyg on 2018/3/4.
//  Copyright © 2018年 Light.W. All rights reserved.
//  发布求职招聘

import UIKit

class PubQiuzhiViewController: PubBaseTableViewController {

    @IBOutlet weak var imgagesCell: TableCellWithCollectionView!
    
    @IBOutlet weak var titleTf: UITextField!
    
    @IBOutlet weak var textCell: UITextView!
    
    @IBOutlet weak var typeSeg: UISegmentedControl!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        imgagesCell.superVC = self

        sourceTextView = textCell
        
        var t1 = "";
        var t2 = "";
        
        switch typeId {
        case "21":
            t1 = "求职";
            t2 = "招聘"; break
        case "23":
            t1 = "我是男生";
            t2 = "我是女生"; break
        case "24":
            t1 = "我是房主";
            t2 = "我要找房"; break
        case "25":
            t1 = "车找人";
            t2 = "人找车"; break
        default:
            break
        }
        
        typeSeg.setTitle(t1, forSegmentAt: 0)
        typeSeg.setTitle(t2, forSegmentAt: 1)
    }

    override func willPost() {
        imgDataArr = imgagesCell.imagesArr
    }
    
    override func startPost(_ ig:[UIImage]? = nil)  {
        guard let uid = User.uid() else { HUD.showText("请前往登录", view: view);return}
        let cont = String.isNullOrEmpty(textCell.text);
        let _title = String.isNullOrEmpty(titleTf.text)
        
        guard _title.lengthOfBytes(using: String.Encoding.utf8) > 0 else { HUD.showText("输入标题不能为空", view: view);return}
        
        guard cont.lengthOfBytes(using: String.Encoding.utf8) > 0 else { HUD.showText("输入内容不能为空", view: view);return}
        
        
        let sjInfo = ["type":typeSeg.selectedSegmentIndex,
                      "title":_title,
                      "content":cont] as [String : Any]
        
        _post(uid, pars: sjInfo, ig: ig)
        
    }
    
    
    
    deinit {
        print("PubQiuzhiViewController")
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
