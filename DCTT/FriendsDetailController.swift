//
//  FriendsDetailController.swift
//  DCTT
//
//  Created by gener on 17/11/21.
//  Copyright © 2017年 Light.W. All rights reserved.
//

import UIKit

class FriendsDetailController: BaseDetailController{

    override func viewDidLoad() {
        super.viewDidLoad()
        //headView
        let headview = Bundle.main.loadNibNamed("FriendHeadView", owner: nil, options: nil)?.last as! FriendHeadView
        _tableview.tableHeaderView = headview
        
        _tableview.tableFooterView = UIView()

        navigationItem.titleView = titleView()
    }

    func titleView() -> UIView {
        let _bgview = UIView (frame: CGRect (x: 0, y: 0, width: 100, height: 25))
        
        let icon = UIImageView(frame: CGRect (x: 10, y: 0, width: _bgview.frame.height, height: _bgview.frame.height))
        icon.image = UIImage (named: "ymtimg2.jpg")
        icon.layer.cornerRadius = _bgview.frame.height / 2
        icon.layer.masksToBounds = true
        _bgview.addSubview(icon)
        
        let btn = UIButton(frame: CGRect (x: 0, y: 0, width: 100, height: 25))
        btn.setTitle("小丸子", for: .normal)
        btn.setTitleColor(UIColor.darkGray, for: .normal)
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, 30, 0, 0)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.layer.cornerRadius = 5
        btn.layer.masksToBounds = true
        btn.addTarget(self, action: #selector(watchBtnAction), for: .touchUpInside)
        _bgview.addSubview(btn)
        
        /*icon.translatesAutoresizingMaskIntoConstraints = false
        btn.translatesAutoresizingMaskIntoConstraints = false
        
        let h = "H:|[icon(25)][btn(80)]"
        _bgview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: h, options: .alignAllCenterX, metrics: nil, views: ["icon":icon,"btn":btn]))
       let v = "V:[btn(25)]"
       _bgview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: v, options: .alignAllCenterY, metrics: nil, views: ["icon":icon,"btn":btn]))
       
        _bgview.addConstraint(NSLayoutConstraint.init(item: icon, attribute: .height, relatedBy: .equal, toItem: btn, attribute: .height, multiplier: 1, constant: 0))
        */
        return _bgview
    }
    
    func watchBtnAction()  {
        
    }
    
    //MARK: - UITableViewDelegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 0
        }else{
            
            return 5 //评论数
        }
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeDetailCommentCellIdentifier", for: indexPath)
        
        cell.selectionStyle = .none

        return cell
        
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
