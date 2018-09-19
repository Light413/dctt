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
    var pageNumber:Int = 1;
    
    var _cellPageController:TTPageViewController!
    var _cellSectionHeadView:TTHeadView!

    let sectionHeadTitles = ["最新发布"]
    let sectionHeight:CGFloat = 40
    
    var canScroll:Bool = true

    ////
    private var dataArray = [[String:Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false;

        _init()
        
        //////
        loadData();

    }
    
    var _tableview:UITableView!
    
    func _init() {
        let frame = CGRect (x: 0, y: 0, width: view.frame.width, height: kCurrentScreenHeight - 64 - 49);
         _tableview = UITableView (frame: frame, style: .plain)
        
        _tableview.delegate = self
        _tableview.dataSource = self
        view.addSubview(_tableview);
 
        _tableview.register(UINib (nibName: "CategoryItemsCell", bundle: nil), forCellReuseIdentifier: "CategoryItemsCellReuseIdentifier")
        
        //_tableview.register(MeHomeCell2.self, forCellReuseIdentifier: "MeHomeSuperCellIdentifier")

        _tableview.estimatedRowHeight = 80;
        _tableview.rowHeight = UITableViewAutomaticDimension
        _tableview.tableFooterView = UIView();
        _tableview.showsVerticalScrollIndicator = false
        
        _tableview.separatorColor = UIColor (red: 232/255.0, green: 232/255.0, blue: 232/255.0, alpha: 1)
        
        _tableview.register(UINib (nibName: "HomeCell", bundle: nil), forCellReuseIdentifier: "HomeCellReuseIdentifierId")
        _tableview.register(UINib (nibName: "HomeCellWithImage", bundle: nil), forCellReuseIdentifier: "HomeCellWithImageIdentifierId")
        _tableview.register(UINib (nibName: "HomeCellWithImages", bundle: nil), forCellReuseIdentifier: "HomeCellWithImagesIdentifierId")
        _tableview.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCellReuseIdentifier")
        
        
        //NotificationCenter.default.addObserver(self, selector: #selector(noti(_ :)), name: NSNotification.Name (rawValue: "superCanScrollNotification"), object: nil)
        //test  refresh
        let header = TTRefreshHeader.init(refreshingBlock: {[weak self] in
            guard let strongSelf = self else{return}
            strongSelf.pageNumber = 1
            strongSelf._tableview.mj_footer.state = .idle
            strongSelf.loadData()
        })
        
        _tableview.mj_header = header;
        
        
        let footer = TTRefreshFooter  {  [weak self] in
            guard let strongSelf = self else{return}
            strongSelf.pageNumber = strongSelf.pageNumber + 1
            strongSelf.loadData();
        }
        
        _tableview.mj_footer = footer
        
    }
    
    func loadData() {
        HUD.show(withStatus: NSLocalizedString("Loading", comment: ""))
        let d = ["category":"life","subType":0] as [String : Any]
        
        AlamofireHelper.post(url: home_list_url, parameters: d, successHandler: {[weak self] (res) in
            HUD.dismiss()
            
            guard let ss = self else {return}
            if ss.pageNumber == 1{ ss.dataArray.removeAll()}
            
            if ss._tableview.mj_header.isRefreshing(){
                ss._tableview.mj_header.endRefreshing()
            }else if ss._tableview.mj_footer.isRefreshing() {
                ss._tableview.mj_footer.endRefreshing()
            }
            
            if let arr = res["body"] as? [[String:Any]] {
                ss.dataArray = ss.dataArray + arr;
                if arr.count < 20 {
                    ss._tableview.mj_footer.state = .noMoreData
                }else{
                    ss._tableview.mj_footer.isHidden = false
                }
            }else {
                ss._tableview.mj_footer.state = .noMoreData
            }
            
            
            ss._tableview.reloadData()

        }) { (error) in
            HUD.dismiss()
        }
        
        
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
        return section == 0 ? 1 : dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let identifier = "CategoryItemsCellReuseIdentifier"
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! CategoryItemsCell
            
            cell.cellSelectedAction = {[weak self] d in
                guard let ss = self else {return}
                let type = d["item_key"]!
                let t = d["item_title"];
                let v = HomerListViewController.init(type,category:"life")
                v.title = t
                
                ss.navigationController?.pushViewController(v, animated: true)
                
            }
            
            return cell

        }
        
        
        
        
//        let identifier :String = "MeHomeSuperCellIdentifier"
//        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! MeHomeCell2
//
//        _cellPageController = addCellPageController()
//        cell.addWithController(_cellPageController)
//        cell.selectionStyle = .none
//        cell.backgroundColor = UIColor.red
        
        let d = dataArray[indexPath.row]
        let type =  Int(String.isNullOrEmpty(d["imageNum"])) ?? 0
        
        var identifier :String = "HomeCellReuseIdentifierId"
        var cell = tableView.dequeueReusableCell(withIdentifier:  identifier, for: indexPath)
        
        switch type {
        case 0:
            (cell as! HomeCell).fill(d)
            
            break
        case let n where n < 3:
            identifier = "HomeCellWithImageIdentifierId"
            cell = tableView.dequeueReusableCell(withIdentifier:  identifier, for: indexPath)
            (cell as! HomeCellWithImage).fill(d)
            break
        case let n where n >= 3:
            
            identifier = "HomeCellWithImagesIdentifierId"
            cell = tableView.dequeueReusableCell(withIdentifier:  identifier, for: indexPath)
            (cell as! HomeCellWithImages).fill(d)
            
            break
        default:break
        }

        
        return cell
        
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if indexPath.section == 0 {
//            return 180;
//        }
//
//        return kCurrentScreenHeight - 49 - sectionHeight
//    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section > 0 else {return nil}
        
        /*let bg = UIView (frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: sectionHeight))
        
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
        
        return bg*/
        
        let v = CategorySectionHeaderView (frame: CGRect (x: 0, y: 0, width: tableView.frame.width, height: 40))

        return v
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section > 0 ? sectionHeight : 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return  0.01
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let d = dataArray[indexPath.row]
        let pid =  String.isNullOrEmpty(d["pid"])
        let vc = ServerDetailController(pid,type:kCategory_life)
        
        vc.data = d
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:-
    /*func addCellPageController() -> TTPageViewController {
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
        
    }*/
    
}

extension AllViewController:TTHeadViewDelegate,TTPageViewControllerDelegate {
    func tt_headViewSelectedAt(_ index: Int) {
        _cellPageController.scrollToPageAtIndex(index)
    }
    
    func tt_pageControllerSelectedAt(_ index: Int) {
        _cellSectionHeadView.scrollToItemAtIndex(index)
    }
    
}

