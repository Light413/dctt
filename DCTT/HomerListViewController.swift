//
//  HomerListViewController.swift
//  DCTT
//
//  Created by wyg on 2017/12/21.
//  Copyright © 2017年 Light.W. All rights reserved.
//

import UIKit
import MJRefresh
import Alamofire

class HomerListViewController: BaseTableViewController {
    var pageNumber:Int = 1;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib (nibName: "HomeCell", bundle: nil), forCellReuseIdentifier: "HomeCellReuseIdentifierId")
        tableView.register(UINib (nibName: "HomeCellWithImage", bundle: nil), forCellReuseIdentifier: "HomeCellWithImageIdentifierId")
        tableView.register(UINib (nibName: "HomeCellWithImages", bundle: nil), forCellReuseIdentifier: "HomeCellWithImagesIdentifierId")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCellReuseIdentifier")
        
        //test  refresh
        let header = TTRefreshHeader.init(refreshingBlock: {[weak self] in
            guard let strongSelf = self else{return}
            strongSelf.pageNumber = 1
            strongSelf.tableView.mj_footer.state = .idle
            strongSelf.loadData()
        })
        
        tableView.mj_header = header;
        
        
        let footer = TTRefreshFooter  {  [weak self] in
            guard let strongSelf = self else{return}
            strongSelf.pageNumber = strongSelf.pageNumber + 1
            strongSelf.loadData();
        }
        
        tableView.mj_footer = footer
        tableView.mj_footer.isHidden = true
        
        //...
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        
        //
        //loadData()
        tableView.mj_header.beginRefreshing()
    }

    
    func loadData() {
        //HUD.show(withStatus: NSLocalizedString("Loading", comment: ""))
        
        AlamofireHelper.post(url: home_list_url, parameters: nil, successHandler: {[weak self] (res) in
            HUD.dismiss()
            
            guard let ss = self else {return}
            if ss.pageNumber == 1{ ss.dataArray.removeAll()}
            
            if ss.tableView.mj_header.isRefreshing(){
                ss.tableView.mj_header.endRefreshing()
            }else if ss.tableView.mj_footer.isRefreshing() {
                ss.tableView.mj_footer.endRefreshing()
            }

            if let arr = res["body"] as? [[String:Any]] {
                ss.dataArray = ss.dataArray + arr;
                if arr.count < 20 {
                    ss.tableView.mj_footer.state = .noMoreData
                }else{
                    ss.tableView.mj_footer.isHidden = false
                }
            }else {
                ss.tableView.mj_footer.state = .noMoreData
            }
            
            
            ss.tableView.reloadData()
            //print(res);
        }) { (error) in
            HUD.dismiss()
        }

        
    }
    
    
    
    //MARK:-
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let d = dataArray[indexPath.row]
        let type =  Int(String.isNullOrEmpty(d["imageNum"])) ?? 0
        
        var identifier :String = "HomeCellReuseIdentifierId"
        var cell = tableView.dequeueReusableCell(withIdentifier:  identifier, for: indexPath)

        switch type {
        case 0:
            (cell as! HomeCell).msg.text = d["content"] as? String
            
            break
        case let n where n < 3:
            identifier = "HomeCellWithImageIdentifierId"
            cell = tableView.dequeueReusableCell(withIdentifier:  identifier, for: indexPath)
            (cell as! HomeCellWithImage).fill(d)
            break
        case let n where n >= 3:
            
            identifier = "HomeCellWithImagesIdentifierId"
            cell = tableView.dequeueReusableCell(withIdentifier:  identifier, for: indexPath)
            (cell as! HomeCellWithImages).fill(d)
            
            break
        default:break
        }
        

        
        //cell.textLabel?.text = dataArray[indexPath.row]
        cell.selectionStyle = .default
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = HomeDetailController()
        
        self.navigationController?.pushViewController(vc, animated: true)
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
