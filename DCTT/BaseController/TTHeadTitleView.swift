//
//  TTHeadTitleView.swift
//  DCTT
//
//  Created by gener on 17/11/20.
//  Copyright © 2017年 Light.W. All rights reserved.
//

import UIKit

protocol TTHeadTitleDelegate {
    func titleClickedAtIndex(_ index:Int);

}


class TTHeadTitleView: UIView,UICollectionViewDelegate,UICollectionViewDataSource {
    var textSelectedColor:UIColor = UIColor.red //选中是字体颜色,默认红色
    var textDefaultColor:UIColor = UIColor.black //默认字体颜色，黑色
    
    private var _titles :[String]!
    private var _currentIndex: Int = 0//当前显示索引
    private var _collectionView:UICollectionView!
    private var _delegate:TTHeadTitleDelegate?
    private let _item_width:CGFloat = 50
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.init(colorLiteralRed: 231/255.0, green: 231/255.0, blue: 231/255.0, alpha: 1)
        _collectionView = colleciontView(frame: CGRect (x: 0, y: 0, width: frame.width, height: frame.height - 1))
        self.addSubview(_collectionView)
    }
    
    init(frame:CGRect,titles:[String],delegate:TTHeadTitleDelegate? = nil) {
        super.init(frame:frame)
        
        _titles = titles
        _delegate = delegate
        self.backgroundColor = UIColor.init(colorLiteralRed: 231/255.0, green: 231/255.0, blue: 231/255.0, alpha: 1)
        _collectionView = colleciontView(frame: CGRect (x: 0, y: 0, width: frame.width, height: frame.height - 1))
        self.addSubview(_collectionView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func colleciontView(frame:CGRect) -> UICollectionView {
        let _layout = UICollectionViewFlowLayout()
        _layout.itemSize = CGSize (width: _item_width, height: frame.height)
        _layout.minimumInteritemSpacing = 0
        _layout.minimumLineSpacing = 0
        _layout.scrollDirection = .horizontal
        
        let collectionview = UICollectionView (frame: frame, collectionViewLayout: _layout)
        collectionview.delegate  = self
        collectionview.dataSource = self
        collectionview.register(UICollectionViewCell.self, forCellWithReuseIdentifier: String (describing: UICollectionViewCell.self))
        collectionview.backgroundColor  = UIColor.white
        collectionview.showsHorizontalScrollIndicator = false
        collectionview.showsVerticalScrollIndicator = false
        collectionview.backgroundView = nil
        collectionview.backgroundColor = UIColor.white
        collectionview.contentInset = UIEdgeInsetsMake(0, 15, 0, 15)
        return collectionview
    }
    
    func scrollToItemAtIndex(_ index:Int) {
        _currentIndex = index
        _collectionView.reloadData()
        
        let item_width = (_collectionView.collectionViewLayout as! UICollectionViewFlowLayout).itemSize.width
        var offset = item_width * (CGFloat(index) + 0.5) - _collectionView.frame.width / 2
        let max = _collectionView.contentSize.width - _collectionView.frame.width
        
        if offset < 0 {
            offset = 0;
        }
        
        if offset > max {
            offset = max;
        }

        _collectionView.setContentOffset(CGPoint (x: offset, y: 0), animated: true)
    }

    
    
    //MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return _titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String (describing: UICollectionViewCell.self), for: indexPath)
        let v = _titles[indexPath.row]
        
        for _v in cell.contentView.subviews{
            _v.removeFromSuperview();
        }
        let l = UILabel.init(frame: CGRect (x: 0, y: 0, width: _item_width, height: self.frame.height))
        l.font = UIFont.systemFont(ofSize: _currentIndex == indexPath.row ? 17:16)
        l.textAlignment = .center
        l.text = v
        l.textColor = _currentIndex == indexPath.row ? textSelectedColor:textDefaultColor
        
        cell.contentView.addSubview(l)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.row
        guard index != _currentIndex else{ return }
        _currentIndex = index
        collectionView.reloadData()
        
        //delegate
        if let delegate = _delegate {
            delegate.titleClickedAtIndex(index)
        }
    }

    
    
}
