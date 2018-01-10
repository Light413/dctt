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
        _tableview.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCellReuseIdentifier")
        view.addSubview(_tableview)
        
        _tableview.estimatedRowHeight = 70
        _tableview.rowHeight = UITableViewAutomaticDimension
        
    }
    
    
    //MARK: - UITableViewDelegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCellReuseIdentifier", for: indexPath)
        
        cell.textLabel?.text = "在具体使用的使用向WizDataBaseManager请求一个WizDataBase，然后使用。在这特意提一下一种常见的数据库应用场景，就是在使用MVC的使用模型控制器从数据库中读取数据然后去更新UI。读取数据库当然是一个很费事的操作，如果让主线程一直忙于读取数据库的话，将会降低UI的响应"
        cell.textLabel?.numberOfLines = 0
        
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
