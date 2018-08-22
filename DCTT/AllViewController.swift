//
//  AllViewController.swift
//  DCTT
//
//  Created by wyg on 2017/11/11.
//  Copyright © 2017年 Light.W. All rights reserved.
//

import UIKit
import SwiftTTPageController

class AllViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {

    var dataArray = [String]()
    
    var _cellPageController:TTPageViewController!
    var _cellSectionHeadView:TTHeadView!

    let sectionHeadTitles = ["最新发布"]
    let sectionHeight:CGFloat = 50
    
    var canScroll:Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false;

        let path = Bundle.main.path(forResource: "all_category_item", ofType: "plist")
        let _arr = NSArray.init(contentsOfFile: path!) as? [String]
        if let arr = _arr {
            dataArray = dataArray + arr;
        }
        
        _init()
    }
    
    func _init() {
        let frame = CGRect (x: 0, y: 0, width: view.frame.width, height: kCurrentScreenHeight - 64 - 49);
        let _tableview = MeInfoTableView (frame: frame, style: .plain)
        
        _tableview.delegate = self
        _tableview.dataSource = self
        view.addSubview(_tableview);
 
        _tableview.register(UINib (nibName: "CategoryItemsCell", bundle: nil), forCellReuseIdentifier: "CategoryItemsCellReuseIdentifier")
        
        _tableview.register(UINib (nibName: "HomeCellWithImages", bundle: nil), forCellReuseIdentifier: "HomeCellWithImagesIdentifierId")
        
        _tableview.register(MeHomeCell2.self, forCellReuseIdentifier: "MeHomeSuperCellIdentifier")
        
        _tableview.showsVerticalScrollIndicator = false;
        
        NotificationCenter.default.addObserver(self, selector: #selector(noti(_ :)), name: NSNotification.Name (rawValue: "superCanScrollNotification"), object: nil)

    }
    
    func noti(_ noti:NSNotification) {
        canScroll = true
        kchildViewCanScroll = false
        //print("super can")
    }

    //MARK: -
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let identifier = "CategoryItemsCellReuseIdentifier"
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
            return cell

        }
        
        let identifier :String = "MeHomeSuperCellIdentifier"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! MeHomeCell2
        
        _cellPageController = addCellPageController()
        cell.addWithController(_cellPageController)
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.red
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 180;
        }
        
        return kCurrentScreenHeight - 49 - sectionHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section > 0 else {return nil}
        
        let bg = UIView (frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: sectionHeight))
        
        var attri = TTHeadTextAttribute()
        attri.itemWidth = 90
        attri.selectedFontSize = 15
        
        let topview  = TTHeadView (frame: CGRect (x: 0, y: 3, width: tableView.frame.width - 20, height: 40), titles: sectionHeadTitles, delegate: self ,textAttributes:attri)
        bg.addSubview(topview)
        
        _cellSectionHeadView = topview
        
        let line0 = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 1))
        line0.backgroundColor = kTableviewBackgroundColor
        
        bg.addSubview(line0)
        bg.backgroundColor = UIColor.white
        
        return bg
        
//        let v = CategorySectionHeaderView (frame: CGRect (x: 0, y: 0, width: tableView.frame.width, height: 40))
//
//        return v
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section > 0 ? sectionHeight : 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return  0.01
    }
    
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:-
    func addCellPageController() -> TTPageViewController {
        ////pagevc
        var vcArr = [UIViewController]()
        
        for _ in 0..<sectionHeadTitles.count {
            let v = ServerListController();
            
            vcArr.append(v)
        }
        
        let rec = CGRect (x: 0, y: 0, width: kCurrentScreenWidth, height:kCurrentScreenHeight - 49 - sectionHeight)
        let pagevc = TTPageViewController(controllers:vcArr, frame: rec, delegate:self)
        
        self.addChildViewController(pagevc)
        
        return pagevc
    }

    
     func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let _y = scrollView.contentOffset.y + 0

        if _y >= _IMG_HEIGHT {
            if canScroll {
                canScroll = false
                scrollView.contentOffset = CGPoint (x: 0, y: _IMG_HEIGHT)
                
                NotificationCenter.default.post(name: NSNotification.Name (rawValue: "childCanScrollNotification"), object: nil)
                kchildViewCanScroll = true
            }else {
                scrollView.contentOffset = CGPoint (x: 0, y: _IMG_HEIGHT)
            }
        } else {
            if !canScroll {
                scrollView.contentOffset = CGPoint (x: 0, y: _IMG_HEIGHT)
            }
        }
        
    }
    
}

extension AllViewController:TTHeadViewDelegate,TTPageViewControllerDelegate {
    func tt_headViewSelectedAt(_ index: Int) {
        _cellPageController.scrollToPageAtIndex(index)
    }
    
    func tt_pageControllerSelectedAt(_ index: Int) {
        _cellSectionHeadView.scrollToItemAtIndex(index)
    }
    
}

