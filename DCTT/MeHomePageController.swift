//
//  MeHomePageController.swift
//  DCTT
//
//  Created by wyg on 2018/3/17.
//  Copyright © 2018年 Light.W. All rights reserved.
//

import UIKit
let _IMG_HEIGHT : CGFloat = 240

enum HomePageType:Int {
    case me
    case other
}

class MeHomePageController: MeBaseTableViewController {

    var type:HomePageType = .me
    var uid:String!
    
    var imgv:UIImageView!
    let sectionHeight:CGFloat = 50
    
    var canScroll:Bool = true

    //////////
    var _cellPageController:TTPageViewController!
    var _cellSectionHeadView:TTHeadTitleView!
    let sectionHeadTitles = ["动态","其他"]
    var _meInfoView:MeHomeHeadView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .none
        
        _initSubview()
        title = User.name()
        
        superNavigationController = self.navigationController
        
    }

    func addCellPageController() -> TTPageViewController {
        ////pagevc
        var vcArr = [UIViewController]()
        
        for _ in 0..<sectionHeadTitles.count {
            let v = MeHomeListController();
            v.uid = uid
            
            vcArr.append(v)
        }
        
        let rec = CGRect (x: 0, y: 0, width: kCurrentScreenWidth, height:kCurrentScreenHeight - 64 - sectionHeight)
        let pagevc = TTPageViewController(controllers:vcArr, frame: rec, delegate:self)
        
        self.addChildViewController(pagevc)
        
        return pagevc
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//
//        navigationController?.navigationBar.isTranslucent = false
//    navigationController?.navigationBar.setBackgroundImage(imgWithColor(tt_defafault_barColor.withAlphaComponent(1)), for: .default)
//
//    }
    
    func _initSubview()  {
        let bg = UIView (frame: CGRect (x: 0, y: 0, width: tableView.frame.width, height: _IMG_HEIGHT + 0))
        imgv = UIImageView (frame: CGRect (x: 0, y: 0, width: tableView.frame.width, height: _IMG_HEIGHT))
        imgv.image = UIImage (named: "back_bg")
        imgv.contentMode = .scaleToFill
        bg.addSubview(imgv)

        /////
        let meinfo = Bundle.main.loadNibNamed("MeHomeHeadView", owner: nil, options: nil)?.first as! MeHomeHeadView
        meinfo.frame = CGRect  (x: 0, y:_IMG_HEIGHT - 180, width: bg.frame.width, height: 180)
        meinfo.backgroundColor = UIColor.clear
        bg.addSubview(meinfo)
        _meInfoView = meinfo;
        
        tableView = MeInfoTableView.init(frame: tableView.frame, style: .plain)
        
        tableView.tableHeaderView = bg
        tableView.tableFooterView = UIView()
        bg.backgroundColor = UIColor.clear
//        navigationController?.navigationBar.isTranslucent = true
//
//    navigationController?.navigationBar.setBackgroundImage(imgWithColor(tt_defafault_barColor.withAlphaComponent(0)), for: UIBarPosition.top, barMetrics: .default)
        
        //tableView.register(UINib (nibName: "MeHomeCell", bundle: nil), forCellReuseIdentifier: "MeHomeCellIdentifier")
//        tableView.estimatedRowHeight = 80;
//        tableView.rowHeight = UITableViewAutomaticDimension
        
        
        //tableView.register(UINib (nibName: "MeHomeSuperCell", bundle: nil), forCellReuseIdentifier: "MeHomeSuperCellIdentifier")
        tableView.register(MeHomeCell2.self, forCellReuseIdentifier: "MeHomeSuperCellIdentifier")
        tableView.rowHeight = kCurrentScreenHeight - 64 - sectionHeight
       
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
                title = name
            }else{
                title = String.isNullOrEmpty(d["nickName"])
            }
            
        }
    }
    
    func noti(_ noti:NSNotification) {
        canScroll = true
        kchildViewCanScroll = false
        //print("super can")
    }

    

    //MARK: -
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let _y = scrollView.contentOffset.y + 0
        if _y <= 0 {
            //navigationController?.navigationBar.isTranslucent = true
            
            let s  = -_y / _IMG_HEIGHT
            let w = scrollView.frame.width * (1 + s)
            let h = _IMG_HEIGHT * (1 + s)

            imgv.frame = CGRect (x: -scrollView.frame.size.width * s * 0.5, y: _y - 0, width: w, height: h)

        }
        
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
        
    //navigationController?.navigationBar.setBackgroundImage(imgWithColor(tt_defafault_barColor.withAlphaComponent(_y > 30 ? 1 : 0)), for: .default)
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = HomeDetailController()
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }


    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sectionHeight
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let bg = UIView (frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: sectionHeight))
        
        var attri = TTHeadTextAttribute()
        attri.itemWidth = 60
        let topview  = TTHeadTitleView (frame: CGRect (x: 8, y: 8, width: tableView.frame.width - 20, height: 35), titles: sectionHeadTitles, delegate: self ,textAttributes:attri)
        bg.addSubview(topview)
        
        _cellSectionHeadView = topview
        
        let line = UIView(frame: CGRect(x: 0, y: sectionHeight - 5, width: tableView.frame.width, height: 5))
        line.backgroundColor = tt_bg_color
        //bg.addSubview(line)
        return bg
    }
    
    
}

extension MeHomePageController:TTHeadTitleDelegate,TTPageViewControllerDelegate {
    func titleClickedAtIndex(_ index: Int) {
        _cellPageController.scrollToPageAtIndex(index)
    }
    
    func pageViewControllerScrollTo(_ index: Int) {
        _cellSectionHeadView.scrollToItemAtIndex(index)
    }
    
}





class MeInfoTableView: UITableView ,UIGestureRecognizerDelegate{
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    
}



