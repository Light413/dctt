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

struct TTHeadTextAttribute {
    var _defaultTextColor:UIColor = UIColor.darkGray
    var _defaultFontSize:CGFloat = 15
    var _selectedTextColor:UIColor = UIColor.black
    var _selectedFontSize:CGFloat = 16
    var itemWidth:CGFloat = 50
    
//    init(defaultColor:UIColor,defaultSize:CGFloat,selectedColor:UIColor,selectedSize:CGFloat) {
//        _defaultTextColor = defaultColor
//        _defaultFontSize = defaultSize
//        _selectedTextColor = selectedColor
//        _selectedFontSize = selectedSize
//    }
}


class TTHeadTitleView: UIView {
    /*设置字体属性*/
    var textAttribute:TTHeadTextAttribute!
    
    fileprivate var _titles :[String]!
    fileprivate var _currentIndex: Int = 0//当前显示索引
    fileprivate var _collectionView:UICollectionView!
    fileprivate var _delegate:TTHeadTitleDelegate?
    fileprivate let _locationWidth:CGFloat = 20
    fileprivate var location:UILabel!
    
    //MARK: -
    override init(frame: CGRect) {
        super.init(frame: frame)

        _collectionView = colleciontView(frame: CGRect (x: 0, y: 0, width: frame.width, height: frame.height))
        self.addSubview(_collectionView)
    }
    
    init(frame:CGRect,titles:[String],delegate:TTHeadTitleDelegate? = nil , textAttributes:TTHeadTextAttribute = TTHeadTextAttribute()) {
        super.init(frame:frame)
        _titles = titles
        _delegate = delegate
        textAttribute = textAttributes
        
        _collectionView = colleciontView(frame: CGRect (x: 0, y: 0, width: frame.width, height: frame.height))
        self.addSubview(_collectionView)
        
        //location
        location = UILabel (frame: CGRect (x: (textAttribute.itemWidth - _locationWidth)/2, y: _collectionView.frame.height - 3, width: _locationWidth, height: 3))
        location.backgroundColor = UIColor.orange
        location.layer.cornerRadius = 2
        location.layer.masksToBounds = true
        _collectionView.addSubview(location)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func colleciontView(frame:CGRect) -> UICollectionView {
        let _layout = UICollectionViewFlowLayout()
        _layout.itemSize = CGSize (width: textAttribute.itemWidth, height: frame.height)
        _layout.minimumInteritemSpacing = 0
        _layout.minimumLineSpacing = 0
        _layout.scrollDirection = .horizontal
        
        let collectionview = UICollectionView (frame: frame, collectionViewLayout: _layout)
        collectionview.delegate  = self
        collectionview.dataSource = self
        collectionview.register(UICollectionViewCell.self, forCellWithReuseIdentifier: String (describing: UICollectionViewCell.self))
        collectionview.showsHorizontalScrollIndicator = false
        collectionview.showsVerticalScrollIndicator = false
        collectionview.backgroundView = nil
        collectionview.backgroundColor = UIColor.init(red: 1, green: 1, blue: 1, alpha: 0)
        return collectionview
    }
    
    func scrollToItemAtIndex(_ index:Int) {
        _currentIndex = index
        _collectionView.reloadData()
        
        let item_width = (_collectionView.collectionViewLayout as! UICollectionViewFlowLayout).itemSize.width
        var offset = item_width * (CGFloat(index) + 0.5) - _collectionView.frame.width / 2
        let max = _collectionView.contentSize.width - _collectionView.frame.width + _collectionView.contentInset.left
        
        if offset < 0 { offset = -_collectionView.contentInset.left;}
        if offset > 0 && max > 0 && offset > max { offset = max;}

        let _x = CGFloat.init(index) * textAttribute.itemWidth + (item_width - 0) * 0.5
        UIView.animate(withDuration: 0.2) {[unowned self] in
           self.location.center = CGPoint (x: _x, y: self.location.center.y);
        }
        
        
        //...
        guard CGFloat.init(_titles.count) * textAttribute.itemWidth > self.frame.width else {return }
        _collectionView.setContentOffset(CGPoint (x: offset, y: 0), animated: true)
    }
 
}


extension TTHeadTitleView:UICollectionViewDelegate,UICollectionViewDataSource {
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
        
        let l = UILabel.init(frame: CGRect (x: 0, y: 0, width: textAttribute.itemWidth, height: self.frame.height))
        l.font = UIFont.systemFont(ofSize: _currentIndex == indexPath.row ? textAttribute._selectedFontSize:textAttribute._defaultFontSize, weight: UIFontWeightRegular)
        l.textAlignment = .center
        l.text = v
        l.textColor = _currentIndex == indexPath.row ? textAttribute._selectedTextColor:textAttribute._defaultTextColor
        
        cell.contentView.addSubview(l)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.row
        guard index != _currentIndex else{ return }
        _currentIndex = index
        collectionView.reloadData()
        
        scrollToItemAtIndex(index)

        if let delegate = _delegate {
            delegate.titleClickedAtIndex(index)
        }
    }

}
