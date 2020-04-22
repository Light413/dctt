//
//  PublishServerController.swift
//  DCTT
//暂时没用
//  Created by wyg on 2018/1/27.
//  Copyright © 2018年 Light.W. All rights reserved.
//

import UIKit

class PublishServerController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        addNavigationItem()
        title = "生活服务";
        
    }

    func addNavigationItem() {
        let leftbtn = UIButton (frame: CGRect (x: 0, y: 0, width: 30, height: 30))
        //leftbtn.setTitle("取消", for: .normal)
        leftbtn.setImage(UIImage (named: "close_night"), for: .normal)
        
        leftbtn.setTitleColor(UIColor.darkGray, for: .normal)
        leftbtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        leftbtn.addTarget(self, action: #selector(navigationBackButtonAction), for: .touchUpInside)
        let leftitem = UIBarButtonItem.init(customView: leftbtn)
        navigationItem.leftBarButtonItem = leftitem
        
        //        let rightbtn = UIButton (frame: CGRect (x: 0, y: 0, width: 30, height: 30))
        //        rightbtn.setTitle("发布", for: .normal)
        //        rightbtn.setTitleColor(kAirplaneCell_head_selected_color, for: .normal)
        //        rightbtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        //        rightbtn.addTarget(self, action: #selector(navigationBackButtonAction), for: .touchUpInside)
        //        let rightitem = UIBarButtonItem.init(customView: rightbtn)
        //        //navigationItem.rightBarButtonItem = rightitem
        
    }
    
    @objc func navigationBackButtonAction() {
        self.dismiss(animated: true, completion: nil)
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
