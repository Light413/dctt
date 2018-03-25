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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .none
        
        _initSubview()
        
        title = "正儿八经的程序员GG"
    }

    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        /*navigationController?.navigationBar.isTranslucent = false
    navigationController?.navigationBar.setBackgroundImage(imgWithColor(tt_defafault_barColor.withAlphaComponent(1)), for: .default)*/

    }
    
    func _initSubview()  {
        
        let bg = UIView (frame: CGRect (x: 0, y: 0, width: tableView.frame.width, height: _IMG_HEIGHT + 0))
        imgv = UIImageView (frame: CGRect (x: 0, y: 0, width: tableView.frame.width, height: _IMG_HEIGHT))
        imgv.image = UIImage (named: "back_bg")
        bg.addSubview(imgv)

        /////
        let meinfo = Bundle.main.loadNibNamed("MeHomeHeadView", owner: nil, options: nil)?.first as! UIView
        meinfo.frame = CGRect  (x: 0, y:_IMG_HEIGHT - 160, width: bg.frame.width, height: 160)
        meinfo.backgroundColor = UIColor.clear
        
        bg.addSubview(meinfo)
        
        tableView.tableHeaderView = bg
        tableView.tableFooterView = UIView()
        
        /*navigationController?.navigationBar.isTranslucent = true
    navigationController?.navigationBar.setBackgroundImage(imgWithColor(tt_defafault_barColor.withAlphaComponent(0)), for: UIBarPosition.top, barMetrics: .default)*/
        
        tableView.register(UINib (nibName: "MeHomeCell", bundle: nil), forCellReuseIdentifier: "MeHomeCellIdentifier")

        tableView.estimatedRowHeight = 80;
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.sectionHeaderHeight = 20
    }
    

    //MARK:
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let _y = scrollView.contentOffset.y + 0
        if _y < 0{
            //navigationController?.navigationBar.isTranslucent = true
            
            let s  = -_y / _IMG_HEIGHT
            let w = scrollView.frame.width * (1 + s)
            let h = _IMG_HEIGHT * (1 + s)

            imgv.frame = CGRect (x: -scrollView.frame.size.width * s * 0.5, y: _y - 0, width: w, height: h)
        }
    //navigationController?.navigationBar.setBackgroundImage(imgWithColor(tt_defafault_barColor.withAlphaComponent(_y > 30 ? 1 : 0)), for: .default)

        
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 20
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var identifier :String = "MeHomeCellIdentifier"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)

        // Configure the cell...

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = HomeDetailController()
        
        self.navigationController?.pushViewController(vc, animated: true)

    }
    
    
    
    
    
}
