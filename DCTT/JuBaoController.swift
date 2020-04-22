//
//  JuBaoController.swift
//  DCTT
//
//  Created by wyg on 2018/10/31.
//  Copyright © 2018年 Light.W. All rights reserved.
//

import UIKit

class JuBaoController: MeBaseTableViewController {

    @IBOutlet weak var cell: PubBaseTextViewCell!
    
    @IBOutlet weak var phoneNum: UITextField!
    
    
    var postId:[String:String]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "请输入举报原因";
        
        ////navigationItem
        navigationItem.leftBarButtonItem = leftNavigationItem()
        navigationItem.rightBarButtonItem = rightNavigationItem()
        
    }

    
    func leftNavigationItem() -> UIBarButtonItem {
        let leftbtn = UIButton (frame: CGRect (x: 0, y: 0, width: 40, height: 30))
        leftbtn.setTitle("取消", for: .normal)
        leftbtn.setTitleColor(UIColor.darkGray, for: .normal)
        leftbtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        leftbtn.addTarget(self, action: #selector(navigationBackButtonAction), for: .touchUpInside)
        let leftitem = UIBarButtonItem.init(customView: leftbtn)
        return leftitem;
    }
    
    func rightNavigationItem() -> UIBarButtonItem{
        let rightbtn = UIButton (frame: CGRect (x: 0, y: 0, width: 40, height: 30))
        rightbtn.setTitle("提交", for: .normal)
        rightbtn.setTitleColor(tt_BarColor , for: .normal)
        rightbtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        rightbtn.addTarget(self, action: #selector(submintBtnAction), for: .touchUpInside)
        let rightitem = UIBarButtonItem.init(customView: rightbtn)
        
        
        return rightitem
    }
    
    ///举报该动态
    func _jubao() {

        
    }
    
    @objc func submintBtnAction() {
        guard String.isNullOrEmpty(cell._text).lengthOfBytes(using: String.Encoding.utf8) > 0 else {
            HUD.showText("输入内容不能为空", view: kAPPKeyWindow)
            return
        }

        guard String.isNullOrEmpty(phoneNum.text).lengthOfBytes(using: String.Encoding.utf8) > 0 else {
            HUD.showText("联系方式不能为空", view: kAPPKeyWindow)
            return
        }
        
        guard var d = postId else {return}
        d["reason"] = String.isNullOrEmpty(cell._text)
        d["uid"] = String.isNullOrEmpty(phoneNum.text)
        
        HUD.show()
        
        AlamofireHelper.post(url: jubao_url, parameters: d, successHandler: {[weak self] (res) in
            guard let msg = res["msg"] as? String else {HUD.dismiss(); return}
            HUD.show(successInfo: msg)
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2, execute: {
                guard let ss = self else {return}
                ss.dismiss(animated: true, completion: nil)
            })
            

        }) { (err) in
            HUD.show(info: (err?.localizedDescription)!)
        }
        
    }
    
    
    //MARK: - Actions
    @objc func navigationBackButtonAction() {
        self.dismiss(animated: true, completion: nil)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }



}
