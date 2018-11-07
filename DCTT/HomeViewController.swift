//
//  HomeViewController.swift
//  DCTT
//
//  Created by wyg on 2017/11/11.
//  Copyright © 2017年 Light.W. All rights reserved.
//

import UIKit
import RxSwift
import SwiftTTPageController

class HomeViewController: BaseViewController ,TTPageViewControllerDelegate,TTHeadViewDelegate,UITextFieldDelegate{
    var vcArr = [BaseTableViewController]()
    var pagevc :TTPageViewController!
    var topview : TTHeadView!
    let _logo_title = "郸城头条"//-老家人自己的头条
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get{
            return .lightContent
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false;

        //t_barTintColor = t_barTintColor
        //self.navigationController?.navigationBar.barTintColor = t_barTintColor
        
        _init()

        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let has =  UserDefaults.standard.value(forKey: "isFirstLaunch") as? String , has == "1"{
           return
        }
        
        _showAgreement2()
    }
    
    func _showAgreement() {
        /*let vc = UIAlertController.init(title: "用户隐私政策概要",message: "\n本《隐私概要》将向你说明:\n1.为了帮助你浏览、发布信息、评论交流、注册认证，我们会收集你的部分必要信息;\n\n2.为了提供以上服务，我们可能会收集联络方式、位置、通讯录等部分敏感信息，你有权拒绝或撤销授权;\n\n3.未经你同意，我们不会从第三方获取、共享或提取你的信息;\n\n4.你可以访问、更正、删除你的个人信息，我们也将提供注销、投诉的方式。如果你点击不同意，我们将仅收集浏览内容所必须的信息，但发布信息、交流评论可能会受到影响。\n\n查看详细的 隐私政策", preferredStyle: .alert)
        let action = UIAlertAction.init(title:"不同意", style: .cancel){[weak self] (action) in
            guard let ss  = self else {return}
            ss.dismiss(animated: true, completion: nil)
        }
        
        action.setValue(UIColor.lightGray, forKey: "titleTextColor")
        
        let action2 = UIAlertAction.init(title: "同意", style: .default)
        
        vc.addAction(action)
        vc.addAction(action2)
                 self.navigationController?.present(vc, animated: true, completion: nil);
         */
    }
    
    func _showAgreement2() {
        let vc = SimplePrivacyController()
        let nav = BaseNavigationController(rootViewController: vc)
        //        vc.modalPresentationStyle = .popover;
        //        let rect = CGRect (x: 0, y: 0, width: 300, height: 200)
        //        vc.view.frame = rect
        //        vc.preferredContentSize = rect.size
        //vc.view.backgroundColor = UIColor.red
        
        self.present(nav, animated: true, completion: nil);
    }
    
    func _init() {
        //head
        let titles = ["最新","热门","问答","活动","吐槽","求助","娱乐"]
        let titlesId = [
            "最新":"0",
            "热门":"1",
            "问答":"12",
            "活动":"14",
            "吐槽":"13",
            "娱乐":"15",
            "求助":"11"
        ]
        
        let _w :CGFloat = 50.0 * CGFloat(titles.count) < kCurrentScreenWidth ? 55 : 50
        var attri = TTHeadTextAttribute()
        attri.itemWidth = _w
        attri.defaultFontSize = 16
        attri.selectedFontSize = 17
        
        topview  = TTHeadView (frame: CGRect (x: 0, y: 0, width: kCurrentScreenWidth - 30, height: 35), titles: titles, delegate: self ,textAttributes:attri)
        topview.backgroundColor = UIColor.clear
        self.navigationItem.titleView = topview
        
        ////pagevc
        for i in 0..<titles.count {
            let t = titles[i]
            
            let v = HomerListViewController(String.isNullOrEmpty(titlesId[t]));
            //v.view.frame =  CGRect (x: 0, y: 0, width: kCurrentScreenWidth, height: _h - 49)
            vcArr.append(v)
        }
        
        let rec = CGRect (x: 0, y: 0, width: kCurrentScreenWidth, height: kCurrentScreenHeight - 50)
        pagevc = TTPageViewController(controllers:vcArr, frame: rec, delegate:self)
        
        self.addChildViewController(pagevc)
        view.addSubview(pagevc.view)
        
        //navigationbar item
        /*let logo_lable = UILabel (frame: CGRect (x: 0, y: 0, width: kCurrentScreenWidth, height: 30))
        logo_lable.text = _logo_title
        logo_lable.font = UIFont.boldSystemFont(ofSize: 18)
        logo_lable.textColor = UIColor.white
        logo_lable.textAlignment = .center
        
        let left_item = UIBarButtonItem.init(customView: logo_lable)
        //navigationItem.leftBarButtonItem = left_item
        
        //search
        let tf = UITextField (frame: CGRect (x: 0, y: 0, width: kCurrentScreenWidth - 150, height: 30))
        tf.backgroundColor = UIColor.white
        tf.borderStyle = .roundedRect
        tf.text = "请输入搜索关键字"
        tf.textColor = UIColor.darkGray
        tf.font = UIFont .systemFont(ofSize: 14)
        tf.delegate = self
        tf.leftViewMode = .always
        let leftview = UIView (frame: CGRect (x: 0, y: 0, width: 25, height: 20))
        let img = UIImageView (image: UIImage (named: "search_subscibe_titilebar_press_night"))
        img.frame = CGRect (x: 10, y: 4, width: 12, height: 12)
        leftview.addSubview(img)
        tf.leftView = leftview
        
        //navigationItem.titleView = logo_lable*/
    }
    
    
    //MARK: -
    func tt_headViewSelectedAt(_ index: Int) {
        pagevc.scrollToPageAtIndex(index)
    }
    
    func tt_pageControllerSelectedAt(_ index: Int) {
        
        topview.scrollToItemAtIndex(index);
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let vc = HomeSearchViewController()

        self.navigationController?.pushViewController(vc, animated: true)
        
        return false
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
