//
//  HomeViewController.swift
//  DCTT
//
//  Created by wyg on 2017/11/11.
//  Copyright © 2017年 Light.W. All rights reserved.
//

import UIKit
import RxSwift

class HomeViewController: BaseViewController ,TTPageViewControllerDelegate,TTHeadTitleDelegate,UITextFieldDelegate{
    var vcArr = [BaseTableViewController]()
    var pagevc :TTPageViewController!
    var topview : TTHeadTitleView!
    let _logo_title = "郸城头条-老家人自己的头条"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false;

        t_barTintColor = tt_HomeBarColor
        self.navigationController?.navigationBar.barTintColor = t_barTintColor
        
        _init()

    }


    func _init() {
        //head
        let titles = ["最新","热门","问答","段子","美食","商家","娱乐"]
        topview  = TTHeadTitleView (frame: CGRect (x: 0, y: 0, width: kCurrentScreenWidth, height: 40), titles: titles, delegate: self)
        view.addSubview(topview)
        
        ////pagevc
        let _h = kCurrentScreenHeight - 64 - 0 - 40
        for _ in 0..<titles.count {
            let v = HomerListViewController();
            v.view.frame =  CGRect (x: 0, y: 0, width: kCurrentScreenWidth, height: _h - 49)
            vcArr.append(v)
        }
        
        let rec = CGRect (x: 0, y: topview.frame.maxY, width: kCurrentScreenWidth, height: _h)
        pagevc = TTPageViewController(controllers:vcArr, frame: rec, delegate:self)
        self.addChildViewController(pagevc)
        view.addSubview(pagevc.view)
        
        //navigationbar item
        let logo_lable = UILabel (frame: CGRect (x: 0, y: 0, width: kCurrentScreenWidth, height: 30))
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
        
        navigationItem.titleView = logo_lable
    }
    
    
    //MARK: -
    func titleClickedAtIndex(_ index: Int) {
        pagevc.scrollToPageAtIndex(index)
    }
    
    func pageViewControllerScrollTo(_ index: Int) {
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
