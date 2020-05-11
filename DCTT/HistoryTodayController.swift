//
//  HistoryTodayController.swift
//  DCTT
//
//  Created by wyg on 2018/10/22.
//  Copyright © 2018年 Light.W. All rights reserved.
//

import UIKit
import Alamofire

class HistoryTodayController: MeBaseTableViewController {

    let url = "http://apicloud.mob.com/appstore/history/query"
    var dataArray = [[String:Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "历史上今天"
        
        tableView.register(UINib (nibName: "TodayViewCell", bundle: nil), forCellReuseIdentifier: "TodayViewCellIdentifier")
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableView.automaticDimension
        
        load()
    }
    
    func load() {
        HUD.show(withStatus: "数据加载中")
        let date = Tools.dateToString(Date(), formatter: "MMdd")
        
//        Alamofire.request(url, parameters: ["key":"2803e9fa0ba26" , "day":date]).responseJSON {[weak self] (res) in
//            if let dic = res.result.value as? [String:Any]{
//                DispatchQueue.main.async {
//                    HUD.dismiss()
//                    
//                    if String.isNullOrEmpty(dic["retCode"]) == "200" {
//                        if let arr = dic["result"] as? [[String:Any]]{
//                            guard let ss = self else {return}
//                            
//                            ss.dataArray = ss.dataArray + arr
//                            ss.tableView.reloadData()
//                        }
//                    }else{
//                        HUD.showText("服务器返回错误", view: kAPPKeyWindow)
//                    }
//                }
//                
//            }
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dataArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodayViewCellIdentifier", for: indexPath)
as! TodayViewCell
        // Configure the cell...

        let d = dataArray[indexPath.row]
        cell.fill(d)
        
        return cell
    }
 

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let d = dataArray[indexPath.row]
        
        //guard let v = UIStoryboard (name: "life", bundle: nil).instantiateViewController(withIdentifier: "HistoryDetailControllerSbid") as? HistoryDetailController else {return}
        let v = HistoryDetailController()
        v.info = d
        self.navigationController?.pushViewController(v, animated: true)
        
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
