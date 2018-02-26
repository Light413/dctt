//
//  CategoryItemsCell.swift
//  DCTT
//
//  Created by wyg on 2018/2/26.
//  Copyright © 2018年 Light.W. All rights reserved.
//

import UIKit

class CategoryItemsCell: UITableViewCell, UICollectionViewDelegate,UICollectionViewDataSource {

    @IBOutlet weak var _collectionView: UICollectionView!
    
    var dataArray = [String]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        _init()
        
    }

    
    func _init() {
        let path = Bundle.main.path(forResource: "all_category_item", ofType: "plist")
        let _arr = NSArray.init(contentsOfFile: path!) as? [String]
        if let arr = _arr {
            dataArray = dataArray + arr;
        }


        let offset:CGFloat = 0
        let _width = (kCurrentScreenWidth - offset *  2)
        
        let _layout = UICollectionViewFlowLayout()
        _layout.itemSize = CGSize (width: _width, height: self.frame.height - 20)
        _layout.minimumInteritemSpacing = 0
        _layout.minimumLineSpacing = 0
        _layout.scrollDirection = .horizontal
        
        _collectionView.collectionViewLayout = _layout
        _collectionView.delegate  = self
        _collectionView.dataSource = self
        //_collectionView.register(UINib (nibName: "AllCategoryCell", bundle: nil), forCellWithReuseIdentifier: "AllCategoryCellReuseIdentifierId")
        
        _collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "AllCategoryCellReuseIdentifierId")
        
        _collectionView.backgroundColor  = UIColor.white
        _collectionView.showsHorizontalScrollIndicator = false
        _collectionView.showsVerticalScrollIndicator = true
        _collectionView.contentInset = UIEdgeInsetsMake(0, offset, 0, offset)
        _collectionView.isPagingEnabled = true
        
    }
    
    
    
    //MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Int(ceil(Double.init(dataArray.count) / 8.0))
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AllCategoryCellReuseIdentifierId", for: indexPath) //as! AllCategoryCell
//        let str = dataArray[indexPath.row]
//        cell.title.text = str
        
        //cell.backgroundColor =  indexPath.row == 0 ?UIColor.lightGray : UIColor.red
        
        cellWithAddItemButton(cell, indexPath: indexPath)
        
        return cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = FriendsDetailController()
        
        //self.navigationController?.pushViewController(vc, animated: true)
    }

    func cellWithAddItemButton(_ cell:UICollectionViewCell,indexPath:IndexPath) {
        for _v in cell.contentView.subviews {
            if _v is UIButton {
                _v.removeFromSuperview();
            }
        }
        
        let w = cell.frame.width / 4.0
        let h = cell.frame.height / 2.0
        
        for i in 0..<2 {
            for j in 0..<4 {
                let btn = UIButton (frame: CGRect (x: w * CGFloat(j), y: h * CGFloat(i), width: w, height: h))
                
                btn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
                //btn.setTitle("生活服务", for: .normal)
                btn.setTitleColor(UIColor.darkGray, for: .normal)
                btn.setImage(UIImage.init(named: "item_0\(j + 1)"), for: .normal)
                
//                btn.imageEdgeInsets = UIEdgeInsetsMake(0, (w - 26) / 2.0, 0, (w - 26) / 2.0)
//                btn.titleEdgeInsets = UIEdgeInsetsMake(h - 20, -20, 0, 0)
//                btn.contentHorizontalAlignment = .center
                

                cell.contentView.addSubview(btn)
                
            }

        }
        
    }
    
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
