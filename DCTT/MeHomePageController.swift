//
//  MeHomePageController.swift
//  DCTT
//
//  Created by wyg on 2018/3/17.
//  Copyright © 2018年 Light.W. All rights reserved.
//

import UIKit
let _IMG_HEIGHT : CGFloat = 240

class MeHomePageController: MeBaseTableViewController {

    var imgv:UIImageView!
    let sectionHeight:CGFloat = 45
    
    var canScroll:Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .none
        
        _initSubview()
        
        title = User.name()
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
        let meinfo = Bundle.main.loadNibNamed("MeHomeHeadView", owner: nil, options: nil)?.first as! UIView
        meinfo.frame = CGRect  (x: 0, y:_IMG_HEIGHT - 180, width: bg.frame.width, height: 180)
        meinfo.backgroundColor = UIColor.clear
        bg.addSubview(meinfo)
        
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
    }
    
    func noti(_ noti:NSNotification) {
        canScroll = true
        print("super can")
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
        var identifier :String = "MeHomeSuperCellIdentifier"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! MeHomeCell2
        
        cell.superVC = self
        cell.add()
        
        // Configure the cell...
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
        let titles = ["动态","其他"]
        let bg = UIView (frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: sectionHeight))
        let topview  = TTHeadTitleView (frame: CGRect (x: 0, y: 0, width: tableView.frame.width, height: 40), titles: titles, delegate: nil)
        
        bg.addSubview(topview)
        
        let line = UIView(frame: CGRect(x: 0, y: sectionHeight - 5, width: tableView.frame.width, height: 5))
        line.backgroundColor = tt_bg_color
        //bg.addSubview(line)
        return bg
    }
    
    
}

class MeInfoTableView: UITableView ,UIGestureRecognizerDelegate{
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
//        print(gestureRecognizer.self);
//        if gestureRecognizer.name is UIScrollViewPanGestureRecognizer {
//            print("UIScrollViewPanGestureRecognizer")
//        }
        
        return true
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    
}



