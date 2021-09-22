//
//  HomeListController.swift
//  DCTT
//
//  Created by wyg on 2021/3/1.
//  Copyright © 2021 Light.W. All rights reserved.
//

import UIKit
import SkeletonView
class HomeListController: BaseViewController {
    var tableView:UITableView!
    var vm:HomeListViewModel!;
    private var _type:String!
    private var _category:String!
    
    ///type:小分类 , category:大分类 sy-首页 life-生活服务
    init(_ type:String , category:String = "sy") {
        super.init(nibName: nil, bundle: nil)
        
        _type = type
        _category = category
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        self.navigationItem.title = ""
        vm = HomeListViewModel.init(self);
        
        addRigthItem()
        addLeftItem();
        
        tableView = vm.tableView;
        tableView.frame = CGRect (x: 0, y: 0, width: kCurrentScreenWidth, height: kCurrentScreenHeight - kNavigationBarHeight - kBottomToolBarHeight);
        
        self.view.addSubview(tableView);
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
            self.vm.loadData()
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        DispatchQueue.once(token: "showAnimatedGradientSkeleton\(_type)") {
            vm.showSkeletonAnimate()
        }
        
    }
    
    func addLeftItem(){
        let ig = Tools.scaleImage(UIImage (named: "home_logo")!, toSize: CGSize (width: 150, height: 30));
        let igv = UIImageView.init(image: UIImage (named: "home_logo")!);
        igv.frame = CGRect (x: 0, y: 0, width: 150, height: 29);
        let leftItem = UIBarButtonItem.init(customView: igv)
        
        self.navigationItem.leftBarButtonItem = leftItem;
    }
    func addRigthItem(){
        let btn = UIButton (frame: CGRect (x: 0, y: 0, width: 30, height: 30));
        btn.setTitle("发布", for: .normal);
        btn.titleLabel?.backgroundColor = UIColor.white;
        
        btn.setTitleColor(UIColorFromHex(rgbValue: 0x444444), for: .normal)
        btn.titleLabel?.font = UIFont .boldSystemFont(ofSize: 16);
        btn.addTarget(self, action: #selector(btnAction(btn:)), for: .touchUpInside);
        let item = UIBarButtonItem.init(customView: btn)
        self.navigationItem.rightBarButtonItem = item;
    }
    
    @objc func btnAction(btn:UIButton?){
        let v = ViewController();
        self.navigationController?.pushViewController(v, animated: true);
    }
    
}
