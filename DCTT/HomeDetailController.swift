//
//  HomeDetailController.swift
//  DCTT
//
//  Created by gener on 17/11/21.
//  Copyright © 2017年 Light.W. All rights reserved.
//

import UIKit

class HomeDetailController: BaseViewController ,UITableViewDelegate,UITableViewDataSource{

    var _tableview:UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initSubview()
    
    }

    //MARK: -
    func initSubview()  {
        _tableview = UITableView.init(frame: CGRect (x: 0, y: 0, width: kCurrentScreenWidth, height: kCurrentScreenHeight - 64 - 0), style: .plain)
        _tableview.delegate = self
        _tableview.dataSource = self
        
        //Register Cell
        _tableview.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCellReuseIdentifier")
        view.addSubview(_tableview)
        
        _tableview.register(UINib (nibName: "HomeDetailCommentCell", bundle: nil), forCellReuseIdentifier: "HomeDetailCommentCellIdentifier")
        
        //计算Cell高度
        _tableview.estimatedRowHeight = 70
        _tableview.rowHeight = UITableViewAutomaticDimension
        
        //headView
        let headview = Bundle.main.loadNibNamed("HomeDetailHeadView", owner: nil, options: nil)?.last as! HomeDetailHeadView
        _tableview.tableHeaderView = headview
        
    }
    
    
    //MARK: - UITableViewDelegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1 // + pic 个数
        }else{
        
        return 5 //评论数
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCellReuseIdentifier", for: indexPath)
        
        if indexPath.section == 0 {
            let _text = "在具体使用的使用向WizDataBaseManager请求一个WizDataBase，然后使用。在这特意提一下一种常见的数据库应用场景，就是在使用MVC的使用模型控制器从数据库中读取数据然后去更新UI。读取数据库当然是一个很费事的操作，如果让主线程一直忙于读取数据库的话，将会降低UI的响应"
            
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.textColor = UIColor.darkGray
            
            let paragraphStyle = NSMutableParagraphStyle.init()
            paragraphStyle.lineSpacing = 8
            paragraphStyle.lineBreakMode = .byCharWrapping
            paragraphStyle.firstLineHeadIndent = 20
            
            let dic:[String:Any] = [NSFontAttributeName:UIFont.systemFont(ofSize: 16) , NSParagraphStyleAttributeName:paragraphStyle,NSKernAttributeName:2]
            let attriStr = NSAttributedString.init(string: _text, attributes: dic)
            cell.textLabel?.attributedText = attriStr
            
        }else{
             cell = tableView.dequeueReusableCell(withIdentifier: "HomeDetailCommentCellIdentifier", for: indexPath)
        }
        
        

        
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    
    let _h:CGFloat = 80
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let _v = UIView (frame: CGRect (x: 0, y: 0, width: kCurrentScreenWidth, height: _h))
        
        ////
        let zanbtn = UIButton (frame: CGRect (x: (kCurrentScreenWidth - 200 - 50)/2, y: 10, width: 100, height: 30))
        zanbtn.layer.cornerRadius = 15
        zanbtn.layer.masksToBounds = true
        zanbtn.layer.borderWidth = 0.5
        zanbtn.layer.borderColor = UIColor.lightGray.cgColor
        
        zanbtn.setImage(UIImage (named: "comment_like_icon_night"), for: .normal)
        zanbtn.setImage(UIImage (named: "comment_like_icon_night"), for: .highlighted)
        _v.addSubview(zanbtn)
        
        ////
        let lovebtn = UIButton (frame: CGRect (x: zanbtn.frame.maxX + 50, y: 10, width: 100, height: 30))
        lovebtn.layer.cornerRadius = 15
        lovebtn.layer.masksToBounds = true
        lovebtn.layer.borderWidth = 0.5
        lovebtn.layer.borderColor = UIColor.lightGray.cgColor
        
        lovebtn.setImage(UIImage (named: "like_heart_textpage_press_night"), for: .normal)
        lovebtn.setImage(UIImage (named: "like_heart_textpage_press_night"), for: .highlighted)
        _v.addSubview(lovebtn)
        
        ////
        let commentLable =  UILabel (frame: CGRect (x: 10, y: _h - 25, width: 60, height: 20))
        commentLable.textColor = UIColor.darkGray
        commentLable.font = UIFont.systemFont(ofSize: 13)
        commentLable.text = "评论(20)"
        _v.addSubview(commentLable)
        
        return _v
        
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section == 0 ? _h : 0
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
