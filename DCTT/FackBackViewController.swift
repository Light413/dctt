//
//  FackBackViewController.swift
//  DCTT
//
//  Created by wyg on 2018/3/25.
//  Copyright © 2018年 Light.W. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


class FackBackViewController: MeBaseTableViewController {

    @IBOutlet weak var cell: PubBaseTextViewCell!
    
    var publishBtn:UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = rightNavigationItem()
        
        let btn = UIButton (frame: CGRect (x: 0, y: kCurrentScreenHeight - 50 - 64, width: kCurrentScreenWidth, height: 50))
        btn.backgroundColor =  UIColor.orange
        btn.setTitle("看看大伙说的啥", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.addTarget(self, action: #selector(jump), for: .touchUpInside)
        self.view.addSubview(btn)
    }

    @objc func jump() {
        let v = BaseWebViewController(baseUrl:feedbackList_url)
        v.title = "最新留言"
        self.navigationController?.pushViewController(v, animated: true)
    }
    func rightNavigationItem() -> UIBarButtonItem{
        let rightbtn = UIButton (frame: CGRect (x: 0, y: 0, width: 40, height: 30))
        rightbtn.setTitle("提交", for: .normal)
        rightbtn.setTitleColor(tt_BarColor , for: .normal)
        rightbtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        rightbtn.addTarget(self, action: #selector(submintBtnAction), for: .touchUpInside)
        let rightitem = UIBarButtonItem.init(customView: rightbtn)
        
        publishBtn = rightbtn
        
        return rightitem
    }

    
    @objc func submintBtnAction() {
        guard let s = cell._text else {HUD.showText("输入内容不能为空", view: UIApplication.shared.keyWindow!); return}
        var d = ["content" : s , "type":"add"]
        
        if let uid = User.uid() {
            d["uid"] = uid
        }
        
        HUD.show(withStatus: "数据提交中")
        AlamofireHelper.post(url: feedback_url, parameters: d, successHandler: {[weak self] (res) in
            HUD.show(successInfo: "提交成功,再次感谢您的支持和关注")
            guard let ss = self else {return}
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: {
                ss.navigationController?.popViewController(animated: true)
            })
            
        }) { (err) in
            HUD.showText("提交失败,请稍后重试", view: UIApplication.shared.keyWindow!)
        }
    }

    
    
    
    
}
