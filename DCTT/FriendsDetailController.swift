//
//  FriendsDetailController.swift
//  DCTT
//
//  Created by gener on 17/11/21.
//  Copyright © 2017年 Light.W. All rights reserved.
//废弃

import UIKit

class FriendsDetailController: BaseDetailController{
    //var data:[String:Any]!
    
    private var imgArr = [String]()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //headView
        let headview = Bundle.main.loadNibNamed("FriendHeadView", owner: nil, options: nil)?.last as! FriendHeadView
        headview.frame = CGRect (x: 0, y: 0, width: kCurrentScreenWidth, height: 240)
        
        headview.fill(data)
        
        _tableview.tableHeaderView = headview
        
        _tableview.tableFooterView = UIView()

        navigationItem.titleView = titleView()
    }

    func titleView() -> UIView {
        let _bgview = UIView (frame: CGRect (x: 0, y: 0, width: 100, height: 25))
        
        let icon = UIImageView(frame: CGRect (x: 10, y: 0, width: _bgview.frame.height, height: _bgview.frame.height))
        

        
        /////用户信息
        var username = ""
        if let dic = data["user"] as? [String:Any] {
            if let igurl = dic["avatar"] as? String {
                let url = URL.init(string: igurl)
                icon.setImage(path: url!)
                
            }
            
            
            let name = String.isNullOrEmpty(dic["name"]);
            if name.lengthOfBytes(using: String.Encoding.utf8) > 0  {
                username = name;
            }
            else
                if let name = dic["nickName"] as? String {
                    username = name;
            }

        }

        //icon.image = UIImage (named: "ymtimg2.jpg")
        icon.layer.cornerRadius = _bgview.frame.height / 2
        icon.layer.masksToBounds = true
        _bgview.addSubview(icon)
        
        let btn = UIButton(frame: CGRect (x: 0, y: 0, width: 100, height: 25))
        btn.setTitle(username, for: .normal)
        btn.setTitleColor(UIColor.darkGray, for: .normal)
        btn.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: 30, bottom: 0, right: 0)
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
    
    @objc func watchBtnAction()  {
        
    }
    
    //MARK: - UITableViewDelegate
    override func numberOfSections(in tableView: UITableView) -> Int {
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
    
}
