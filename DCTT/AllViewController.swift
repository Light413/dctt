//
//  AllViewController.swift
//  DCTT
//
//  Created by wyg on 2017/11/11.
//  Copyright © 2017年 Light.W. All rights reserved.
//

import UIKit

class AllViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {

    var dataArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false;

        let path = Bundle.main.path(forResource: "all_category_item", ofType: "plist")
        let _arr = NSArray.init(contentsOfFile: path!) as? [String]
        if let arr = _arr {
            dataArray = dataArray + arr;
        }
        
        _init()
    }
    
    func _init() {
        let frame = CGRect (x: 0, y: 0, width: view.frame.width, height: kCurrentScreenHeight - 64 - 49);
        let _tableview = UITableView (frame: frame, style: .grouped)
        
        _tableview.delegate = self
        _tableview.dataSource = self
        view.addSubview(_tableview);
 
        _tableview.register(UINib (nibName: "CategoryItemsCell", bundle: nil), forCellReuseIdentifier: "CategoryItemsCellReuseIdentifier")
        
        _tableview.register(UINib (nibName: "HomeCellWithImages", bundle: nil), forCellReuseIdentifier: "HomeCellWithImagesIdentifierId")
        
//        _tableview.rowHeight = UITableViewAutomaticDimension
//        _tableview.estimatedRowHeight = 100

    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section > 0 ? 10 : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = indexPath.section > 0 ? "HomeCellWithImagesIdentifierId":"CategoryItemsCellReuseIdentifier"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        
        return cell
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 200;
        }
        
        return 150
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section > 0 else {return nil}
        
        let v = CategorySectionHeaderView (frame: CGRect (x: 0, y: 0, width: tableView.frame.width, height: 40))
        
        return v
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section > 0 ? 40 : 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section == 0 ? 5 : 0.01
    }
    
    
    /*fileprivate func colleciontView(_ frame:CGRect) -> UICollectionView {
        let offset:CGFloat = 10
        //let _width = (kCurrentScreenWidth - offset *  2 - 8) / 3.0
        let _width = (kCurrentScreenWidth - offset *  2 - 5) / 2.0
        
        let _layout = UICollectionViewFlowLayout()
        _layout.itemSize = CGSize (width: _width, height: _width * 0.5)
        _layout.minimumInteritemSpacing = 2
        _layout.minimumLineSpacing = 8
        _layout.scrollDirection = .horizontal
        
        let collectionview = UICollectionView (frame: frame, collectionViewLayout: _layout)
        collectionview.delegate  = self
        collectionview.dataSource = self
        collectionview.register(UINib (nibName: "AllCategoryCell", bundle: nil), forCellWithReuseIdentifier: "AllCategoryCellReuseIdentifierId")
        collectionview.backgroundColor  = UIColor.white
        collectionview.showsHorizontalScrollIndicator = false
        collectionview.showsVerticalScrollIndicator = true
        collectionview.contentInset = UIEdgeInsetsMake(15, offset, 10, offset)
        collectionview.isPagingEnabled = true
        
        return collectionview
    }
    
    
    //MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AllCategoryCellReuseIdentifierId", for: indexPath) as! AllCategoryCell
        let str = dataArray[indexPath.row]
        cell.title.text = str

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = FriendsDetailController()
        
        self.navigationController?.pushViewController(vc, animated: true)
    }*/
    
    

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
