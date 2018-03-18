//
//  MeHomeViewController.swift
//  DCTT
//
//  Created by wyg on 2018/3/18.
//  Copyright © 2018年 Light.W. All rights reserved.
//

import UIKit

//let _IMG_HEIGHT : CGFloat = 150

class MeHomeViewController: BaseViewController ,UITableViewDelegate,UITableViewDataSource {
    
    var tableView:UITableView!
    var imgv:UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        _initSubview()
    }

    
    
    func _initSubview()  {
        tableView = UITableView (frame: self.view.bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)

        let bg = UIView (frame: CGRect (x: 0, y: 0, width: tableView.frame.width, height: _IMG_HEIGHT - 0))
        imgv = UIImageView (frame: CGRect (x: 0, y: 0, width: tableView.frame.width, height: _IMG_HEIGHT))
        imgv.image = UIImage (named: "back_bg")
        
        bg.addSubview(imgv)
        bg.backgroundColor = UIColor.red
        tableView.tableHeaderView = bg
        tableView.tableFooterView = UIView()
        
        
        self.navigationController?.navigationBar.isTranslucent = true
    //navigationController?.navigationBar.setBackgroundImage(imgWithColor(tt_defafault_barColor.withAlphaComponent(0)), for: UIBarPosition.top, barMetrics: .default)
        
    navigationController?.navigationBar.setBackgroundImage(imgWithColor(tt_defafault_barColor.withAlphaComponent(0)), for: .default)
        
        tableView.register(UINib (nibName: "HomeCell", bundle: nil), forCellReuseIdentifier: "HomeCellReuseIdentifierId")
        
        
    }
    
    
    
    
    //MARK:
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let _y = scrollView.contentOffset.y + 64
        if _y < 0{
            //navigationController?.navigationBar.isTranslucent = true
            
            let s  = -_y / _IMG_HEIGHT
            let w = scrollView.frame.width * (1 + s)
            let h = _IMG_HEIGHT * (1 + s)
            
            imgv.frame = CGRect (x: -scrollView.frame.size.width * s * 0.5, y: _y - 64, width: w, height: h)
        }
    navigationController?.navigationBar.setBackgroundImage(imgWithColor(tt_defafault_barColor.withAlphaComponent(_y > 30 ? 1 : 0)), for: .default)
        
        
        
    }
    
    // MARK: - Table view data source
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 20
    }
    
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var identifier :String = "HomeCellReuseIdentifierId"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        
        // Configure the cell...
        
        return cell
    }
    
    
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
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
