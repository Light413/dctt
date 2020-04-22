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
    
    @IBOutlet weak var pageCtr: UIPageControl!
    var dataArray = [[String:String]]()
    
    var numberOfItem = 0
    
    var cellSelectedAction:(([String:String]) -> Void)?
    var nums : [[String:Any]]?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        _init()
        
        //_getNumber()
    }

    ///获取分类下的帖子数
    func _getNumber() {
        AlamofireHelper.post(url: get_servernumber_url, parameters: nil, successHandler: { [weak self](res) in
            guard let ss = self else {return}
            guard let arr = res["body"] as? [[String:Any]] else {return}
            ss.nums = arr
            ss._collectionView.reloadData()
        })
        
    }
    
    func _init() {
        let path = Bundle.main.path(forResource: "all_category_item", ofType: "plist")
        let _arr = NSArray.init(contentsOfFile: path!) as? [[[String:String]]]
        if let arr = _arr?.last {
            dataArray = dataArray + arr;
        }


        let offset:CGFloat = 0
        let _width = (kCurrentScreenWidth - offset *  2)
        
        let _layout = UICollectionViewFlowLayout()
        _layout.itemSize = CGSize (width: _width, height: 180 - 21)
        _layout.minimumInteritemSpacing = 0
        _layout.minimumLineSpacing = 0
        _layout.scrollDirection = .horizontal
        
        _collectionView.collectionViewLayout = _layout
        _collectionView.delegate  = self
        _collectionView.dataSource = self
        _collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "AllCategoryCellReuseIdentifierId")
        
        _collectionView.backgroundColor  = UIColor.white
        _collectionView.showsHorizontalScrollIndicator = false
        _collectionView.showsVerticalScrollIndicator = true
        _collectionView.contentInset = UIEdgeInsets.init(top: 0, left: offset, bottom: 0, right: offset)
        _collectionView.isPagingEnabled = true
        
        
        /////cell number
        numberOfItem = Int(ceilf(Float.init(dataArray.count) / 8.0))
        
        ////pageCtr
        pageCtr.numberOfPages = numberOfItem
        pageCtr.currentPage = 0

    }
    
    
    
    //MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfItem
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AllCategoryCellReuseIdentifierId", for: indexPath) //as! AllCategoryCell
//        let str = dataArray[indexPath.row]
//        cell.title.text = str
        
        //cell.backgroundColor =  indexPath.row == 0 ?UIColor.lightGray : UIColor.red
        
        cellWithAddItemButton(cell, indexPath: indexPath)
        
        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let n = scrollView.contentOffset.x / scrollView.frame.width
        pageCtr.currentPage = Int.init(n)
    }
    
    @objc func itemClickedAction(_ button:UIButton){
        if let handler = cellSelectedAction {
            let d = dataArray[button.tag];
            handler(d)
        }
    }
    
    func cellWithAddItemButton(_ cell:UICollectionViewCell,indexPath:IndexPath) {
        
        for _v in cell.contentView.subviews {
            if _v is UIButton {
                _v.removeFromSuperview();
            }
        }
        
        let w = cell.frame.width / 4.0
        let h = cell.frame.height / 2.0
        let icon_w:CGFloat = 30
        
        let row = indexPath.row
        let num = (dataArray.count - indexPath.row * 8)
        
        for i in 0..<num {
            let _row = floorf(Float(i / 4))
            let _col = i % 4
            let btn = UIButton (frame: CGRect (x: w * CGFloat(_col), y: h * CGFloat(_row), width: w, height: h))
            
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
            let index = i + row * 8
            let d = dataArray[index]
            let str = d["item_title"]
            btn.setTitle(str!, for: .normal)
            btn.tag = index
            btn.addTarget(self, action: #selector(itemClickedAction(_ :)), for: .touchUpInside)
            
            //btn.setTitle(dataArray[i + row * 8 ], for: .normal)
            btn.setTitleColor(UIColor.darkGray, for: .normal)
            btn.setImage(UIImage.init(named: "item_new_0\(i + 1)"), for: .normal)
            btn.setImage(UIImage.init(named: "item_new_0\(i + 1)"), for: .highlighted)
            
            btn.imageEdgeInsets = UIEdgeInsets.init(top: (h - icon_w) / 2.0, left: (w - icon_w) / 2.0, bottom: (h - icon_w) / 2.0, right: (w - icon_w) / 2.0)
            btn.titleEdgeInsets = UIEdgeInsets.init(top: h - 20, left: -50, bottom: 0, right: 0)
            
            cell.contentView.addSubview(btn)
            
            
            /*if let ns = nums {
                ////添加动态数
                let numLable = UILabel()
                numLable.font = UIFont.systemFont(ofSize: 10)
                numLable.textColor = UIColor.white
                numLable.textAlignment = .center
                numLable.backgroundColor = kButtonTitleColor
                numLable.layer.cornerRadius = 5
                numLable.layer.masksToBounds = true
                
                let type = String.isNullOrEmpty(d["item_key"]);
                let n = _number(type, arr: ns)
                
                let _n = Int(n)
                if _n! == 0 {continue;}
                
                let num:NSString = NSString.init(string: "\(_n!)")
                numLable.text = String.init(num)
                
                let size = num.boundingRect(with: CGSize.init(width: 50, height: 10), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName:numLable.font], context: nil)
                let _num_w :CGFloat = size.width + 10 > 20 ? size.width + 10 : 20
                numLable.frame = CGRect (x: w * 0.5 + 10, y: 15, width: _num_w, height: 12)
                
                btn.addSubview(numLable)
            }*/

        }


    }
    
    func _number(_ type:String , arr:[[String:Any]]) -> String {
        for d in arr {
            let k = String.isNullOrEmpty(d["type"])
            if k == type {
                return String.isNullOrEmpty(d["num"])
            }
        }
        
        
        return "0"
    }
    
}
