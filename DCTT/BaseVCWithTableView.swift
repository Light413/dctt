//
//  BaseVCWithTableView.swift
//  DCTT
//  暂时没用
//  Created by wyg on 2018/2/4.
//  Copyright © 2018年 Light.W. All rights reserved.
//

import UIKit

class BaseVCWithTableView: BaseViewController,UITableViewDelegate,UITableViewDataSource {

    var _tableView:UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        _initSubviews()
        
        ////navigationItem
        navigationItem.leftBarButtonItem = leftNavigationItem()
        navigationItem.rightBarButtonItem = rightNavigationItem()
        
    }

    func leftNavigationItem() -> UIBarButtonItem {
        let leftbtn = UIButton (frame: CGRect (x: 0, y: 0, width: 30, height: 30))
        leftbtn.setTitle("取消", for: .normal)
        leftbtn.setTitleColor(UIColor.darkGray, for: .normal)
        leftbtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        leftbtn.addTarget(self, action: #selector(navigationBackButtonAction), for: .touchUpInside)
        let leftitem = UIBarButtonItem.init(customView: leftbtn)
        return leftitem;
    }
    
    func rightNavigationItem() -> UIBarButtonItem{
        let rightbtn = UIButton (frame: CGRect (x: 0, y: 0, width: 30, height: 30))
        rightbtn.setTitle("发布", for: .normal)
        rightbtn.setTitleColor(UIColor.darkGray , for: .normal)//kAirplaneCell_head_selected_color
        rightbtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        rightbtn.addTarget(self, action: #selector(previewAction), for: .touchUpInside)
        let rightitem = UIBarButtonItem.init(customView: rightbtn)
        
        return rightitem
    }
    
    //MARK: - Actions
    @objc func navigationBackButtonAction() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func previewAction() {}
    func submintBtnAction(){}
    
    
    
    func _initSubviews()  {
        _tableView = UITableView.init(frame: CGRect (x: 10, y: 0, width: kCurrentScreenWidth - 20, height: kCurrentScreenHeight - 64), style: .grouped)
        _tableView.delegate = self
        _tableView.dataSource = self
        
        view.addSubview(_tableView)
        
        _tableView.register(UINib (nibName: "TableViewCellTextView", bundle: nil), forCellReuseIdentifier: "TableViewCellTextViewReuseIdentifier")
        _tableView.register(UINib (nibName: "TableViewCellSwitch", bundle: nil), forCellReuseIdentifier: "TableViewCellSwitchReuseIdentifier")
        _tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCellReuseIdentifier")
        
        //_tableView.backgroundView = nil
        _tableView.backgroundColor = UIColor.clear
    }
    
    
    //MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var identifierid = "UITableViewCellReuseIdentifier"
        
        switch indexPath.section {
        case 0: identifierid = "TableViewCellTextViewReuseIdentifier"; break
        case 1:identifierid = "TableViewCellSwitchReuseIdentifier";break
        case 2:identifierid = "UITableViewCellReuseIdentifier"
        default:break
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: identifierid, for: indexPath)
        
        if indexPath.section == 2 {
            cell.textLabel?.text = "选择问题的过期日期"
            cell.textLabel?.textColor = UIColor.darkGray
            cell.textLabel?.font = UIFont.systemFont(ofSize: 15)
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? 150 : 50
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section == 0 else {
            return nil
        }
        
        let lable = UILabel (frame: CGRect (x: 10, y: 20, width: 100, height: 30))
        lable.text = "问题描述"
        lable.textColor = UIColor.lightGray
        lable.font = UIFont.systemFont(ofSize: 13)
        
        let v = UIView (frame: CGRect (x: 0, y: 0, width: 100, height: 50))
        v.addSubview(lable)
        return v
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 50 : 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 8
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard indexPath.section == 2 else {
            return
        }
        
//        TTDatePickerView.show { (age) in
//            print(age)
//        }
        
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
