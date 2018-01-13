//
//  FriendsDetailController.swift
//  DCTT
//
//  Created by gener on 17/11/21.
//  Copyright © 2017年 Light.W. All rights reserved.
//

import UIKit

class FriendsDetailController: BaseViewController ,UITableViewDelegate,UITableViewDataSource{
    var _tableview:UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initSubview()
        
    }

    
    //MARK: -
    func initSubview()  {
        _tableview = UITableView.init(frame: CGRect (x: 0, y: 0, width: kCurrentScreenWidth, height: kCurrentScreenHeight - 64 - 40), style: .grouped)
        _tableview.delegate = self
        _tableview.dataSource = self
        _tableview.contentInset = UIEdgeInsetsMake(0, 0, 5, 0)
        
        _tableview.separatorStyle = .none
        
        //Register Cell
        _tableview.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCellReuseIdentifier")
        view.addSubview(_tableview)
        
        _tableview.register(UINib (nibName: "HomeDetailCommentCell", bundle: nil), forCellReuseIdentifier: "HomeDetailCommentCellIdentifier")
        
        //计算Cell高度
        _tableview.estimatedRowHeight = 70
        _tableview.rowHeight = UITableViewAutomaticDimension
        
        //headView
        let headview = Bundle.main.loadNibNamed("FriendHeadView", owner: nil, options: nil)?.last as! FriendHeadView
        _tableview.tableHeaderView = headview
        
        _tableview.tableFooterView = UIView()
        
        
        //bottom comment btn
        addBottomBar()

    }
    
    
    //toolBar
    func addBottomBar()  {
        let toolBar = UIToolbar.init(frame: CGRect (x: 0, y: _tableview.frame.maxY, width: kCurrentScreenWidth, height: 40))
        
        let writeBtn = UIButton (frame: CGRect (x: 0, y: 5, width: 100, height: 30))
        writeBtn.setTitle("写评论", for: .normal)
        writeBtn.setTitleColor(UIColor.darkGray, for: .normal)
        writeBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        writeBtn.layer.cornerRadius = 15
        writeBtn.layer.borderColor = UIColor.lightGray.cgColor
        writeBtn.layer.borderWidth = 0.5
        writeBtn.layer.masksToBounds = true
        writeBtn.setImage(UIImage (named: "comment"), for: .normal)
        writeBtn.imageEdgeInsets = UIEdgeInsetsMake(10, -10, 7, 0)
        writeBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 6, 0, 0)
        writeBtn.backgroundColor = kTableviewBackgroundColor
        writeBtn.tag = 100
        writeBtn.addTarget(self, action: #selector(toolBarButtonClicked(_ :)), for: .touchUpInside)
        let writeItem = UIBarButtonItem (customView: writeBtn)
        
        //收藏
        let scBtn = UIButton (frame: CGRect (x: 0, y: 5, width: 40, height: 30))
        scBtn.setImage(UIImage (named: "product_comment"), for: .normal)
        scBtn.setImage(UIImage (named: "product_comment_click"), for: .selected)
        scBtn.imageEdgeInsets = UIEdgeInsetsMake(5, 10, 5, 10)
        scBtn.tag = 101
        scBtn.addTarget(self, action: #selector(toolBarButtonClicked(_ :)), for: .touchUpInside)
        let scItem = UIBarButtonItem (customView: scBtn)
        
        let flex = UIBarButtonItem.init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        //举报
        let jbBtn = UIButton (frame: CGRect (x: 0, y: 5, width: 50, height: 30))
        jbBtn.setTitle("举报", for: .normal)
        jbBtn.setTitleColor(UIColor.lightGray, for: .normal)
        jbBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        jbBtn.tag = 102
        jbBtn.addTarget(self, action: #selector(toolBarButtonClicked(_ :)), for: .touchUpInside)
        let jcItem = UIBarButtonItem (customView: jbBtn)
        
        
        
        toolBar.items = [writeItem,flex,scItem,flex,jcItem]
        
        view.addSubview(toolBar)
    }
    
    func toolBarButtonClicked(_ button:UIButton) {
        button.isSelected = !button.isSelected
        
        switch button.tag {
        case 100://写评论
            break
        case 101://收藏
            break
        case 102://举报
            break
        default:break
        }
    }
    
    
    
    //MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeDetailCommentCellIdentifier", for: indexPath)
        
        cell.selectionStyle = .none

        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return  0.01
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
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
