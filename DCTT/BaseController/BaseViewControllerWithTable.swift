//
//  BaseViewControllerWithTable.swift
//  Toolbox
//
//  Created by gener on 17/6/28.
//  Copyright © 2017年 Light. All rights reserved.
//

import UIKit

class BaseViewControllerWithTable: BaseViewController,UITableViewDelegate,UITableViewDataSource {

    var tableview:UITableView?
    var dataArray = [Any]()
    
    var cellSelectedAction:((Int) -> (Void))?
    var cellSelectedIndex : Int?
    var kTableviewCellRowHeight : Int = 0 //Cell高度
    
    var needtitleView:Bool = true
    var titleViewBtn:UIButton?
    let titleViewBtnRect = CGRect (x: 0, y: 0, width: 200, height: 40)
    
    private var headSectionHeight = 30.0
    private var headSectionNum = 0//head中显示数字
    var sectionHeadtitle:String?//section显示的内容
    var headNumShouldChange:Bool = false
    
    //MARK:
    override func viewDidLoad() {
        super.viewDidLoad()

        tableview = UITableView (frame: CGRect (x: 0, y: 0, width: 0, height: 0), style: .plain)
        tableview?.delegate = self
        tableview?.dataSource = self
        tableview?.backgroundColor = kTableviewBackgroundColor
        tableview?.separatorStyle = .none
        tableview?.tableFooterView = UIView()
        view.addSubview(tableview!)
        
        initSubview();
        guard needtitleView else {
            return
        }
        
        navigationItem.titleView = titleView()
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        /*
        if let btn = navigationItem.titleView {
            setTitleViewBtn(title: kAIRPLANE_SORTEDOPTION_KEY, button: btn as! UIButton)
        }
        */
        if let v = navigationItem.titleView {
            let _l = v.viewWithTag(222) as? UILabel
            if let _l = _l {
                 //_l.text = titleViewValue(title: kAIRPLANE_SORTEDOPTION_KEY)
            }
        }
    }
    
    //MARK: - titleView
    func titleView2() -> UIView {
        let button = UIButton (frame: CGRect (x: 0, y: 0, width: 200, height: 40))
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)//15 .13
        button.titleLabel?.textAlignment = .right
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitleColor(UIColor.white, for: .highlighted)
        button.setImage(UIImage (named: "cheveron-normal_gry"), for: .normal)//"cheveron-normal_gry"-backhighlighted
        button.setImage(UIImage (named: "cheveron-normal_gry"), for: .highlighted)
        //        button.imageView?.transform = CGAffineTransform(rotationAngle: CGFloat(-M_PI_2))
        button.addTarget(self, action: #selector(popPresentControllerButtonAction(_:)), for: .touchUpInside)
        button.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 20)
        button.imageEdgeInsets = UIEdgeInsets.init(top: 18, left: button.frame.width - 20 , bottom: 12, right: 5)
        //setTitleViewBtn(title: kAIRPLANE_SORTEDOPTION_KEY,button: button)
        
        return button
    }
    
    func titleView() -> UIView{
        let bgview = UIView (frame: titleViewBtnRect)
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.textColor = UIColor.white
        title.textAlignment = .center
        title.font = UIFont.boldSystemFont(ofSize: 20)
        title.tag = 222
        bgview.addSubview(title)
        
        let ig = UIImageView(image: UIImage(named:"backhighlighted"), highlightedImage: UIImage(named:"backhighlighted"))
        ig.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi/2))
        ig.translatesAutoresizingMaskIntoConstraints = false
        bgview.addSubview(ig)
     
        let _h = NSLayoutConstraint.constraints(withVisualFormat: "H:[title]-5-[ig(10)]", options: [], metrics: nil, views: ["title":title,"ig":ig])
        let _v = NSLayoutConstraint.constraints(withVisualFormat: "V:|[title]|", options: .alignAllTop, metrics: nil, views: ["title":title,"ig":ig])
        
        //设置ig.height
        bgview.addConstraint(NSLayoutConstraint.init(item: ig, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 10))
        //设置ig,title 水平对齐
        bgview.addConstraint(NSLayoutConstraint (item: ig, attribute: .centerY, relatedBy: .equal, toItem: title, attribute: .centerY, multiplier: 1, constant: 3))
        //设置title居中
        bgview.addConstraint(NSLayoutConstraint (item: title, attribute: .centerX, relatedBy: .equal, toItem: bgview, attribute: .centerX, multiplier: 1, constant: 0))
        
        bgview.addConstraints(_h)
        bgview.addConstraints(_v)
        
        let button = UIButton (frame: bgview.frame)
        button.addTarget(self, action: #selector(popPresentControllerButtonAction(_:)), for: .touchUpInside)
        bgview.addSubview(button)
        
        return bgview
    }
    
    func setTitleViewBtn(title:String,button:UIButton) {
        let str = titleViewValue(title: title)
        button.setTitle(str, for: .normal)
    }
    
    func titleViewValue(title:String) -> String {
       /* var str:String!
        
        if let airplane = kSelectedAirplane {
            let key:String! = kAirplaneKeyValue[title]
            let value = airplane.value(forKey: key) as! String
            
            if value != "" {
                str = title + " " +  value
            }else{
                str = "No \(title)"
            }
        }else{
            str = "No \(title)"
        }
        return str*/
        return ""
    }
    
    
    //MARK:-
    @objc func popPresentControllerButtonAction(_ button:UIButton){
        /*let rect = CGRect (x: 0, y: 0, width: 320, height: 160)
        let vc = PopViewController.init(nibName: "PopViewController", bundle: nil)
        vc.view.frame = rect
        vc.modalPresentationStyle = .popover
        vc.popoverPresentationController?.sourceView = button//指定原点，固定pop
        vc.popoverPresentationController?.sourceRect = titleViewBtnRect //pop的箭头位置在这个区域中间
        vc.preferredContentSize = CGSize (width: 320, height: 160)
        
        self.present(vc, animated: true, completion: nil)*/
    }
    
    
    //dataArray为空时提示cell
    func getCellForNodata(_ tableView:UITableView,info:String) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "historynodataidentifierid")
        if cell == nil {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: "historynodataidentifierid")
        }
        cell?.textLabel?.text = info
        cell?.textLabel?.textAlignment = .center
        cell?.textLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        cell?.isUserInteractionEnabled = false
        cell?.backgroundColor = UIColor.clear
        return cell!
    }
    
    public func initSubview(){
    
    }
    
    
    
    
    //MARK: - UITableViewDataSource
    //以下大多用于pop中的列表，其他情况下都在子类中重写
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count == 0 ? 1: dataArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier")
        if cell == nil
        {
            cell = UITableViewCell (style: .default, reuseIdentifier: "reuseIdentifier")
            cell?.textLabel?.textColor = UIColor.darkGray
        }
        
        if indexPath.row == cellSelectedIndex {
            cell?.accessoryType = .checkmark
        }
        
        cell?.textLabel?.text = dataArray[indexPath.row] as? String
        return cell!
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        return {
            if headSectionNum == 0 || headNumShouldChange {
                headSectionNum = dataArray.count
            }
            
            let v = UIView (frame: CGRect (x: 0, y: 0, width: kCurrentScreenWidth, height: 30))
            v.backgroundColor = kTableview_headView_bgColor
            let title = UILabel (frame: CGRect (x: 0, y: 0, width: v.frame.width, height: 30))
            title.textColor = UIColor.white
            title.font = UIFont.boldSystemFont(ofSize: 18)
            title.text = "\t\t\(sectionHeadtitle!)\t\t\(headSectionNum)"
            
            v.addSubview(title)
            return v
            }()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return CGFloat(kTableviewCellRowHeight == 0 ? 44 : kTableviewCellRowHeight);
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(sectionHeadtitle != nil && dataArray.count > 0 ? headSectionHeight : 0.0)
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let tmp = cellSelectedAction {
            tmp(indexPath.row)
            
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
