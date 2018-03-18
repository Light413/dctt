//
//  MeHomePageController.swift
//  DCTT
//
//  Created by wyg on 2018/3/17.
//  Copyright © 2018年 Light.W. All rights reserved.
//

import UIKit
let _IMG_HEIGHT : CGFloat = 150

class MeHomePageController: MeBaseTableViewController {

    var imgv:UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.backgroundColor = kTableviewBackgroundColor
        tableView.separatorColor = UIColor (red: 232/255.0, green: 232/255.0, blue: 232/255.0, alpha: 1)
        
        _initSubview()
        
    }

    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        navigationController?.navigationBar.isTranslucent = false
    navigationController?.navigationBar.setBackgroundImage(imgWithColor(tt_defafault_barColor.withAlphaComponent(1)), for: .default)

    }
    
    func _initSubview()  {
        
        let bg = UIView (frame: CGRect (x: 0, y: 0, width: tableView.frame.width, height: _IMG_HEIGHT - 64))
        imgv = UIImageView (frame: CGRect (x: 0, y: -64, width: tableView.frame.width, height: _IMG_HEIGHT))
        imgv.image = UIImage (named: "back_bg")
        bg.addSubview(imgv)

        tableView.tableHeaderView = bg
        tableView.tableFooterView = UIView()
        
        navigationController?.navigationBar.isTranslucent = true
    navigationController?.navigationBar.setBackgroundImage(imgWithColor(tt_defafault_barColor.withAlphaComponent(0)), for: UIBarPosition.top, barMetrics: .default)
        
        tableView.register(UINib (nibName: "HomeCell", bundle: nil), forCellReuseIdentifier: "HomeCellReuseIdentifierId")

    
        
    }
    

    //MARK:
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let _y = scrollView.contentOffset.y + 64
        if _y < 0{
            //navigationController?.navigationBar.isTranslucent = true
            
            let s  = -_y / _IMG_HEIGHT
            let w = scrollView.frame.width * (1 + s)
            let h = _IMG_HEIGHT * (1 + s)

            imgv.frame = CGRect (x: -scrollView.frame.size.width * s * 0.5, y: _y - 64, width: w, height: h)
        }
    navigationController?.navigationBar.setBackgroundImage(imgWithColor(tt_defafault_barColor.withAlphaComponent(_y > 30 ? 1 : 0)), for: .default)

        
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 20
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var identifier :String = "HomeCellReuseIdentifierId"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)

        // Configure the cell...

        return cell
    }
    
    
   override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
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
