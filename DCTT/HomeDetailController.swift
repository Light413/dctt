//
//  HomeDetailController.swift
//  DCTT
//
//  Created by gener on 17/11/21.
//  Copyright © 2017年 Light.W. All rights reserved.
//

import UIKit

class HomeDetailController: BaseDetailController{

    var isPreview:Bool = false //是否处于预览状态
    
    ////....test
    var pre_text:String!
    var pre_imgs = [UIImage]()
    
    private var _titleView:UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        //titleview
        _titleView = titleView()
        _titleView.isHidden = true
        navigationItem.titleView = _titleView

    }

    
    
    //MARK: -
    
    func titleView() -> UIView {
        let _bgview = UIView (frame: CGRect (x: 0, y: 0, width: 100, height: 25))

        let icon = UIImageView (frame: CGRect (x: 0, y: 0, width: _bgview.frame.height, height: _bgview.frame.height))
        icon.image = UIImage (named: "ymtimg2.jpg")
        icon.layer.cornerRadius = _bgview.frame.height / 2
        icon.layer.masksToBounds = true
        _bgview.addSubview(icon)
        
        let btn = UIButton (frame: CGRect (x: icon.frame.maxX + 10, y: 0, width: 60, height: 25))
        btn.backgroundColor = UIColor (red: 17/255.0, green: 135/255.0, blue: 212/255.0, alpha: 1)
        btn.setTitle("关注", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        btn.layer.cornerRadius = 5
        btn.layer.masksToBounds = true
        btn.addTarget(self, action: #selector(watchBtnAction), for: .touchUpInside)
        _bgview.addSubview(btn)
        
        return _bgview
    }
    
    func watchBtnAction() {
        //关注
        
    }
    
    
    //MARK: - 
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        _titleView.isHidden = !(scrollView.contentOffset.y > 60)
    }
    
    
    
    //MARK: - UITableViewDelegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1 + 2 // + pic 个数
        }else{
        
        return 5 //评论数
        }
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCellReuseIdentifier", for: indexPath)
        
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let _text = "在具体使用的使用向WizDataBaseManager请求一个WizDataBase，然后使用。在这特意提一下一种常见的数据库应用场景，就是在使用MVC的使用模型控制器从数据库中读取数据然后去更新UI。读取数据库当然是一个很费事的操作，如果让主线程一直忙于读取数据库的话，将会降低UI的响应"
                
                cell.textLabel?.numberOfLines = 0
                cell.textLabel?.textColor = UIColor.darkGray
                
                let paragraphStyle = NSMutableParagraphStyle.init()
                paragraphStyle.lineSpacing = 5
                paragraphStyle.lineBreakMode = .byCharWrapping
                paragraphStyle.firstLineHeadIndent = 20
                
                let dic:[String:Any] = [NSFontAttributeName:UIFont.systemFont(ofSize: 16) , NSParagraphStyleAttributeName:paragraphStyle,NSKernAttributeName:1]
                let attriStr = NSAttributedString.init(string: _text, attributes: dic)
                cell.textLabel?.attributedText = attriStr
            }else{//带有图的cell
                cell = tableView.dequeueReusableCell(withIdentifier: "HomeDetailImgCellIdentifier", for: indexPath)
                
            }

        }else{
             cell = tableView.dequeueReusableCell(withIdentifier: "HomeDetailCommentCellIdentifier", for: indexPath)
        }
        

        cell.selectionStyle = .none
        
        return cell
    }
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = HomeDetailController()
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    



}
