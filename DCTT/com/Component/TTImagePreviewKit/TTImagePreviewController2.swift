//
//  TTImagePreviewController.swift
//  DCTT
//
//  Created by gener on 2017/12/8.
//  Copyright © 2017年 Light.W. All rights reserved.
//

import UIKit
import Photos

class TTImagePreviewController2: UIViewController{
    override var prefersStatusBarHidden: Bool {
        get{
            return true;
        }
    }
    
    var dataArry = [String]()
    var index:Int = 0 //选中的索引,开始为0
    
    //privita variable
    fileprivate var _colloectionview:UICollectionView!
    fileprivate var _topBar:UIToolbar!
    fileprivate var _bottomBar:UIToolbar!
    fileprivate var topBarTitle:UILabel!
    fileprivate var _selectButton:UIButton!
    fileprivate var _toolBarIsHiden = false
    
    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        let frame = CGRect (x: 0, y: 0, width: view.frame.width, height: kCurrentScreenHeight);
        _colloectionview = colleciontView(frame)
        view.addSubview(_colloectionview)

        addTooBar()
        
        _colloectionview.scrollToItem(at: IndexPath.init(item: index, section: 0), at: .left, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    fileprivate func colleciontView(_ frame:CGRect) -> UICollectionView {
        let _layout = UICollectionViewFlowLayout()
        _layout.itemSize = CGSize (width: frame.width + 10, height: frame.height)
        _layout.minimumInteritemSpacing = 0
        _layout.minimumLineSpacing = 0
        _layout.scrollDirection = .horizontal
        
        let collectionview = UICollectionView (frame: CGRect (x: frame.minX, y: frame.minY, width: frame.width + 10, height: frame.height), collectionViewLayout: _layout)
        collectionview.delegate  = self
        collectionview.dataSource = self
        
        collectionview.register(TTImagePreviewCell2.self, forCellWithReuseIdentifier: "TTImagePreviewCellIdentifier")
        
        collectionview.backgroundColor  = UIColor.black
        collectionview.showsHorizontalScrollIndicator = false
        collectionview.showsVerticalScrollIndicator = false
        collectionview.alwaysBounceVertical = false
        collectionview.isPagingEnabled = true
        return collectionview
    }
    
    func addTooBar() {
        let _alpha:Float = 0.5
        //_topBar = UIView(frame: CGRect (x: 0, y: 0, width: kCurrentScreenWidth, height: 60))
        _topBar = UIToolbar.init(frame: CGRect (x: 0, y: kIsIPhoneX ? 44 : 0, width: kCurrentScreenWidth, height: 60))
        _topBar.barStyle = .default
        _topBar.isTranslucent = true
        _topBar.setBackgroundImage(imageWithColor(UIColor.init(red: 0, green: 0, blue: 0, alpha: CGFloat(_alpha))), forToolbarPosition: .any , barMetrics: .default)
        view.addSubview(_topBar)
        _topBar.layoutIfNeeded()
        
        topBarTitle = UILabel.init(frame: CGRect (x: (_topBar.frame.width - 120)/2, y: (_topBar.frame.height - 40)/2, width: 120, height: 40))
        topBarTitle.textAlignment = .center
        topBarTitle.textColor = UIColor.white
        topBarTitle.font = UIFont.systemFont(ofSize: 16)
        _topBar.addSubview(topBarTitle)
        topBarTitle.text = "\(index + 1)/\(dataArry.count)"
        
        let backbtn = UIButton (frame: CGRect (x: 15, y: 10 + (_topBar.frame.height - 60)/2, width: 50, height: 50))
        backbtn.setImage(UIImage (named: "photo_detail_titlebar_close"), for: .normal)
        backbtn.imageEdgeInsets = UIEdgeInsets.init(top: -5, left: -10, bottom: 5, right: 10)
        backbtn.addTarget(self, action: #selector(_dismiss), for: .touchUpInside)
        _topBar.addSubview(backbtn)
        
        //bottomBar
        _bottomBar = UIToolbar.init(frame: CGRect (x: 0, y: kCurrentScreenHeight - 50, width: kCurrentScreenWidth, height: 60))
        _bottomBar.barStyle = .black
        _bottomBar.isTranslucent = true
        _bottomBar.setShadowImage(UIImage(), forToolbarPosition: .bottom)
        _bottomBar.setBackgroundImage(imageWithColor(UIColor.init(red: 0, green: 0, blue: 0, alpha: CGFloat(_alpha))), forToolbarPosition: .any , barMetrics: .default)
        view.addSubview(_bottomBar)
        
        _bottomBar.layoutIfNeeded()
        
        let selectbtn = UIButton (frame: CGRect (x: kCurrentScreenWidth - 80, y: 0, width: 40, height: 40))
        selectbtn.setTitle("保存", for: .normal)
        selectbtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        selectbtn.addTarget(self, action: #selector(saveImageAction(_:)), for: .touchUpInside)
        _bottomBar.addSubview(selectbtn)
        
    }
    
    
    //MARK: - Toolbar  EVENT
    @objc func _dismiss() {

        self.dismiss(animated: false, completion: nil)
    }
    

    @objc func saveImageAction(_ btn:UIButton)  {
        if let cell = _colloectionview.cellForItem(at: IndexPath.init(item: index, section: 0)) as? TTImagePreviewCell2 {
            if let ig = cell.igv.image {
                UIImageWriteToSavedPhotosAlbum(ig, self, #selector(image(image:didFinishSavingWithError:contextInfo:)), nil)
            }
        }
        
        
    }
    
    @objc func image(image:UIImage,didFinishSavingWithError error:NSError?,contextInfo:AnyObject) {
        HUD.show(successInfo: "已保存到相册")
    }
    
    func imageWithColor(_ color:UIColor) -> UIImage? {
        let rect = CGRect (x: 0, y: 0, width: 1, height: 1)
        
        UIGraphicsBeginImageContext(rect.size)
        
        let ctx = UIGraphicsGetCurrentContext()
        
        ctx?.setFillColor(color.cgColor)
        
        ctx?.fill(rect)
        
        let ig = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return ig
    
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}



//MARK: -
extension TTImagePreviewController2 : UICollectionViewDelegate , UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArry.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TTImagePreviewCellIdentifier", for: indexPath) as! TTImagePreviewCell2
        
        let asset = dataArry[indexPath.row]
        cell.setImage(asset)
        cell.imageClickedHandler = {
            UIView.animate(withDuration: 0.2, animations: { [weak self] in
                guard let strongSelf = self else {return}
                
                if !strongSelf._toolBarIsHiden {
                    strongSelf._topBar.transform = CGAffineTransform.init(translationX: 0, y: -strongSelf._topBar.frame.height - (kIsIPhoneX ? 44 : 0))
                    strongSelf._bottomBar.transform = CGAffineTransform.init(translationX: 0, y:strongSelf._bottomBar.frame.height + 0)
                }else{
                    strongSelf._topBar.transform = CGAffineTransform.identity
                    strongSelf._bottomBar.transform = CGAffineTransform.identity
                }
            }) { [weak self] (finished) in
                guard let strongSelf = self else {return}
                strongSelf._toolBarIsHiden = !strongSelf._toolBarIsHiden
            }
        }

        
        return cell
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let i = lroundf(Float(scrollView.contentOffset.x / (kCurrentScreenWidth + 10)))
        index = i
        
        topBarTitle.text = "\(i + 1)/\(dataArry.count)"
    }
}



