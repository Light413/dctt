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
    var vcArr = [HomeListController]()
    var pagevc :TTPageViewController!
    var topview : TTHeadView!
    let _logo_title = "郸城头条"
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get{
            return .lightContent
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        title = ""
        view.backgroundColor = UIColor.white
        automaticallyAdjustsScrollViewInsets = false;
//        t_barTintColor = UIColor.red;
        _init()
        
        print(UIFont.familyNames)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
//        self.navigationController?.navigationBar.barTintColor = UIColorFromHex(rgbValue: 0xFF4500)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let has =  UserDefaults.standard.value(forKey: "isFirstLaunch") as? String , has == "1"{
           return
        }
        
        _showAgreement2()
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
        let titles = ["推荐","热门话题"]
        let titlesId = [
            "最新":"0",
            "热门话题":"1",
//            "新鲜事":"10",
            "打听":"11",
            "吐槽":"12",
            "公告":"13",
        ]
        
        let _w :CGFloat = 50.0 * CGFloat(titles.count) < kCurrentScreenWidth ? 55 : 50
        var attri = TTHeadTextAttribute()
        attri.itemWidth = _w
        attri.defaultFontSize = 16
        attri.selectedFontSize = 16
        attri.selectedTextColor = UIColorFromHex(rgbValue: 0xff4500)
        attri.bottomLineColor = UIColorFromHex(rgbValue: 0xff4500)
        attri.bottomLineHeight = 2;
        let bg = UIView.init(frame: CGRect (x: 0, y: 0, width: kCurrentScreenWidth, height: 45));
        topview  = TTHeadView (frame: CGRect (x: 10, y: 8, width: kCurrentScreenWidth - 20, height: 32), titles: titles, delegate: self ,textAttributes:attri)
        bg.addSubview(topview);
        let lineView = UIView (frame: CGRect (x: 0, y: bg.frame.maxY - 0.5, width: kCurrentScreenWidth, height: 0.5));
        lineView.backgroundColor = UIColor.defatultSeparatorColor;
        //bg.addSubview(lineView);
//        bg.backgroundColor = UIColor.red;
//        topview.backgroundColor = UIColor.blue;
        
        ////pagevc
        for i in 0..<titles.count {
            let t = titles[i]
            let v = HomeListController(String.isNullOrEmpty(titlesId[t]));
            //v.view.frame =  CGRect (x: 0, y: 0, width: kCurrentScreenWidth, height: _h - 49)
            vcArr.append(v)
        }
        
        let rec = CGRect (x: 0, y: bg.frame.height, width: kCurrentScreenWidth, height: kCurrentScreenHeight - bg.frame.height - 49 - 50)
        pagevc = TTPageViewController(controllers:vcArr, frame: rec, delegate:self)
        
        self.addChild(pagevc)
        view.addSubview(bg)
        view.addSubview(pagevc.view)
        
        //navigationbar item
        let logo_lable = UILabel (frame: CGRect (x: 0, y: 0, width: kCurrentScreenWidth, height: 30))
        logo_lable.text = _logo_title
        logo_lable.font = UIFont.systemFont(ofSize: 17)
        logo_lable.textColor = UIColorFromHex(rgbValue: 0xdcdcdc);
        logo_lable.textAlignment = .center
//        navigationItem.titleView = logo_lable;
        
        /*
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
        self.addLeftItem();
        addRigthItem()
    }
    
    func addLeftItem(){
        let ig = Tools.scaleImage(UIImage (named: "home_logo")!, toSize: CGSize (width: 150, height: 30));
        let igv = UIImageView.init(image: UIImage (named: "home_logo")!);
        igv.frame = CGRect (x: 0, y: 0, width: 150, height: 30);
        let leftItem = UIBarButtonItem.init(customView: igv)
        
        self.navigationItem.leftBarButtonItem = leftItem;
    }
    
    func addRigthItem(){
        let btn = UIButton (frame: CGRect (x: 0, y: 0, width: 30, height: 30));
        btn.setTitle("发布", for: .normal);
        btn.setTitleColor(UIColorFromHex(rgbValue: 0x444444), for: .normal)
        btn.titleLabel?.font = UIFont .boldSystemFont(ofSize: 16);
//        btn.setBackgroundImage(UIImage (named: "icon_publish"), for: .normal)
        
        btn.addTarget(self, action: #selector(btnAction), for: .touchUpInside);
        let item = UIBarButtonItem.init(customView: btn)
        self.navigationItem.rightBarButtonItem = item;
    }
    
    @objc func btnAction(){
            print(111)
        let v = ViewController();
        self.navigationController?.pushViewController(v, animated: true);
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

}
