//
//  MeHomePageController.swift
//  DCTT
//
//  Created by wyg on 2018/3/17.
//  Copyright © 2018年 Light.W. All rights reserved.
//

import UIKit
let _kTableViewHeaderHeight : CGFloat = 220//350
let _kTableViewMeInfoHeight:CGFloat = 170

import SwiftTTPageController

enum HomePageType:Int {
    case me
    case other
}

class MeHomePageController: MeBaseTableViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    var type:HomePageType = .me
    var uid:String!
    var imgv:UIImageView!
    let sectionHeight:CGFloat = 35
    var canScroll:Bool = true

    //////////
    var _cellPageController:TTPageViewController!
    var _cellSectionHeadView:TTHeadView!
    let sectionHeadTitles = ["动态"]
    var _meInfoView:MeHomeHeadView!
    private var kuserName:String = ""
    
    //MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        _initSubview()
    }

    func addCellPageController() -> TTPageViewController {
        ////pagevc
        var vcArr = [UIViewController]()
        let rec = CGRect (x: 0, y: 0, width: UIScreen.main.bounds.size.width > 320 ? kCurrentScreenWidth - 80 : kCurrentScreenWidth, height:kCurrentScreenHeight - 44 - sectionHeight)
        
        for _ in 0..<sectionHeadTitles.count {
            let v = MeHomeListController();
            v.uid = uid
            vcArr.append(v)
        }
        
        ////....待完善

        let pagevc = TTPageViewController(controllers:vcArr, frame: rec, delegate:self)
        
        self.addChildViewController(pagevc)
        
        return pagevc
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        navigationController?.navigationBar.setBackgroundImage(UIImage (named: "back_bg@2x"), for: .default)
        //navigationController?.navigationBar.isTranslucent = true
    }
 
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
    }
    
    func _initSubview()  {
        let bg = UIView (frame: CGRect (x: 0, y: 0, width: tableView.frame.width, height: _kTableViewHeaderHeight ))
        imgv = UIImageView (frame: CGRect (x: 0, y: 0, width: tableView.frame.width, height: 0))
        imgv.image = UIImage (named: "back_bg@2x")
        imgv.contentMode = .scaleToFill
        bg.addSubview(imgv)

        /////meinfo
        let meinfo = Bundle.main.loadNibNamed("MeHomeHeadView", owner: nil, options: nil)?.first as! MeHomeHeadView
        meinfo.frame = CGRect  (x: 0, y:_kTableViewHeaderHeight - _kTableViewMeInfoHeight, width: bg.frame.width, height: _kTableViewMeInfoHeight)
        meinfo.backgroundColor = tt_defafault_barColor //UIColor.white
        bg.addSubview(meinfo)
        _meInfoView = meinfo;
        
        tableView = MeInfoTableView.init(frame: tableView.frame, style: .grouped)
        tableView.separatorStyle = .none
        tableView.tableHeaderView = bg
        tableView.tableFooterView = UIView()
        bg.backgroundColor = UIColor.clear
        
        
        
        //navigationController?.navigationBar.setBackgroundImage(imgWithColor(UIColor (red: 250/255.0, green: 251/255.0, blue: 253/255.0, alpha: 0).withAlphaComponent(0)), for: UIBarPosition.top, barMetrics: .default)
        
        //tableView.register(UINib (nibName: "MeHomeCell", bundle: nil), forCellReuseIdentifier: "MeHomeCellIdentifier")
//        tableView.estimatedRowHeight = 80;
//        tableView.rowHeight = UITableViewAutomaticDimension
        
        
        //tableView.register(UINib (nibName: "MeHomeSuperCell", bundle: nil), forCellReuseIdentifier: "MeHomeSuperCellIdentifier")
        tableView.register(MeHomeCell2.self, forCellReuseIdentifier: "MeHomeSuperCellIdentifier")
        tableView.rowHeight = kCurrentScreenHeight - 44 - sectionHeight
        tableView.showsVerticalScrollIndicator = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(noti(_ :)), name: NSNotification.Name (rawValue: "superCanScrollNotification"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateProfile(_ :)), name: NSNotification.Name.init("updateProfileNotification"), object: nil)
        
    }
    
    func updateProfile(_ noti:Notification) {
        if let d = noti.userInfo as? [String:Any] {
            _meInfoView.fill(d)
            _meInfoView.avatarClickerAction = {[weak self] in
                guard let ss = self else {return}
                guard let avatar_url = d["avatar"] as? String else {return}
                
                let vc  = TTImagePreviewController2()
                vc.index = 0
                vc.dataArry = [avatar_url]
                
                ss.navigationController?.present(vc, animated: false, completion: nil)
            }
            
            let name = String.isNullOrEmpty(d["name"]);
            if name.lengthOfBytes(using: String.Encoding.utf8) > 0  {
                kuserName = name
            }else{
                kuserName = String.isNullOrEmpty(d["nickName"])
            }
            
        }
    }
    
    func noti(_ noti:NSNotification) {
        canScroll = true
        kchildViewCanScroll = false
        //print("super can")
    }

    //MARK: -
    let _offset_y:CGFloat = 55 - 64
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let _y = scrollView.contentOffset.y + 0
        if _y <= 0 {
            /*//navigationController?.navigationBar.isTranslucent = true
            let s  = -_y / _kTableViewHeaderHeight
            let w = scrollView.frame.width * (1 + s)
            let h = _kTableViewHeaderHeight * (1 + s)
            imgv.frame = CGRect (x: -scrollView.frame.size.width * s * 0.5, y: _y - 0, width: w, height: h)
        */
            title = "";
        }else{
            title = kuserName
        }
        
        if _y >= _kTableViewHeaderHeight - _offset_y {
            if canScroll {
                canScroll = false
                scrollView.contentOffset = CGPoint (x: 0, y: _kTableViewHeaderHeight - _offset_y)
                
                NotificationCenter.default.post(name: NSNotification.Name (rawValue: "childCanScrollNotification"), object: nil)
                kchildViewCanScroll = true
            }else {
                scrollView.contentOffset = CGPoint (x: 0, y: _kTableViewHeaderHeight - _offset_y)
            }
        } else {
            if !canScroll {
               scrollView.contentOffset = CGPoint (x: 0, y: _kTableViewHeaderHeight - _offset_y)
            }
        }
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        //_cellPageController.removeFromParentViewController()
        //print(self.description)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}

// MARK: - Table view data source
extension MeHomePageController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier :String = "MeHomeSuperCellIdentifier"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! MeHomeCell2
        
        _cellPageController = addCellPageController()
        cell.addWithController(_cellPageController)
        cell.selectionStyle = .none
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sectionHeight
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let bg = UIView (frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: sectionHeight))
        bg.backgroundColor = UIColor.white

        var attri = TTHeadTextAttribute()
        attri.itemWidth = 60
        attri.selectedFontSize  = 15
        attri.selectedTextColor = UIColor.darkGray
        attri.bottomLineColor = tt_themeColor
        
        let topview  = TTHeadView (frame: CGRect (x: 0, y: 5, width: tableView.frame.width - 20, height: 35), titles: sectionHeadTitles, delegate: self ,textAttributes:attri)
        bg.addSubview(topview)
        _cellSectionHeadView = topview
        return bg
    }
}

extension MeHomePageController:TTHeadViewDelegate,TTPageViewControllerDelegate {
    func tt_headViewSelectedAt(_ index: Int) {
        _cellPageController.scrollToPageAtIndex(index)
    }
    
    func tt_pageControllerSelectedAt(_ index: Int) {
        _cellSectionHeadView.scrollToItemAtIndex(index)
    }
    
}
class MeInfoTableView: UITableView ,UIGestureRecognizerDelegate{
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        /*
         <UIScreenEdgePanGestureRecognizer: 0x15f5afdc0; state = Began; delaysTouchesBegan = YES; view = <UILayoutContainerView 0x15f5ac7e0>; target= <(action=panGestureRec:, target=<DCTT.BaseNavigationController 0x15f893a00>)>>
         */
        //判断手势是否是NavigationController的侧滑返回手势
        if otherGestureRecognizer.isMember(of: UIScreenEdgePanGestureRecognizer.self) {
            return false
        }
        
        //判断是否UICollectionView侧滑手势
        if (otherGestureRecognizer.view?.isMember(of: UICollectionView.self))!{
            return false
        }
        
        return true
    }
    
    
}



