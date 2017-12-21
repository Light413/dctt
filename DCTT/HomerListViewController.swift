//
//  HomerListViewController.swift
//  DCTT
//
//  Created by wyg on 2017/12/21.
//  Copyright © 2017年 Light.W. All rights reserved.
//

import UIKit
import MJRefresh

class HomerListViewController: BaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        //....test
        
        for n in 0..<20 {
            dataArray.append("\(n + 1)")
        }
        
        tableView.register(UINib (nibName: "HomeCell", bundle: nil), forCellReuseIdentifier: "HomeCellReuseIdentifierId")
        tableView.register(UINib (nibName: "HomeCellWithImage", bundle: nil), forCellReuseIdentifier: "HomeCellWithImageIdentifierId")
        tableView.register(UINib (nibName: "HomeCellWithImages", bundle: nil), forCellReuseIdentifier: "HomeCellWithImagesIdentifierId")
        
        //test  refresh
        let header = TTRefreshHeader.init(refreshingBlock: {[weak self] in
            guard let strongSelf = self else{return}
            
            print("refresh start...")
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                print("refresh end...")
                strongSelf.dataArray.removeAll()
                strongSelf.dataArray = strongSelf.dataArray + ["1","2","3","4","5"]
                strongSelf.tableView.reloadData()
                strongSelf.tableView.mj_header.endRefreshing()
                strongSelf.tableView.mj_footer.state = MJRefreshState.idle
            }
            
        })
        
        tableView.mj_header = header;
        
        
        let footer = TTRefreshFooter  {  [weak self] in
            guard let strongSelf = self else{return}
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                print("footer refresh end...")
                
                strongSelf.dataArray = strongSelf.dataArray + ["1","2","3","4","5"]
                
                strongSelf.tableView.reloadData()
                
                if strongSelf.dataArray.count > 20 {
                    strongSelf.tableView.mj_footer.endRefreshingWithNoMoreData()
                }else{
                    strongSelf.tableView.mj_footer.endRefreshing()
                }
            }
        }
        tableView.mj_footer = footer
        
        //...
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
    
    }

    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var identifier :String = "HomeCellReuseIdentifierId"
        switch indexPath.row % 3 {
        case 0:
            identifier = "HomeCellReuseIdentifierId"
            break
        case 1:
            identifier = "HomeCellWithImageIdentifierId"
            break
        case 2:identifier = "HomeCellWithImagesIdentifierId"
            break
        default:break
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier:  identifier, for: indexPath) //as! HomeCell
        
        //cell.textLabel?.text = dataArray[indexPath.row]
        
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
