//
//  TTImagePreviewController.swift
//  DCTT
//
//  Created by gener on 2017/12/8.
//  Copyright © 2017年 Light.W. All rights reserved.
//

import UIKit
import Photos

class TTImagePreviewController: UIViewController{

    override var prefersStatusBarHidden: Bool {
        get{
            return true;
        }
    }
    
    var dataArry = [PHAsset]()
    var selectedDataArr = [PHAsset]()
    var index:Int = 0 //选中的索引
    var maxImagesNumber:Int = 0
    var closeHandler:(([PHAsset]) -> Void)? //关闭视图前，选择结果处理的回调
    
    //privita variable
    fileprivate var _colloectionview:UICollectionView!
    fileprivate var _topBar:UIToolbar!
    fileprivate var _bottomBar:UIToolbar!
    fileprivate var _imgNumber:UILabel!
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
        
        collectionview.register(TTImagePreviewCell.self, forCellWithReuseIdentifier: "TTImagePreviewCellIdentifier")
        
        collectionview.backgroundColor  = UIColor.black
        collectionview.showsHorizontalScrollIndicator = false
        collectionview.showsVerticalScrollIndicator = false
        collectionview.alwaysBounceVertical = false
        collectionview.isPagingEnabled = true
        return collectionview
    }
    
    func addTooBar() {
        let _alpha:Float = 0.5
        _topBar = UIToolbar.init(frame: CGRect (x: 0, y: 0, width: kCurrentScreenWidth, height: 60))
        _topBar.barStyle = .black
        _topBar.isTranslucent = true
        _topBar.setBackgroundImage(imageWithColor(UIColor.init(red: 0, green: 0, blue: 0, alpha: CGFloat(_alpha))), forToolbarPosition: .any , barMetrics: .default)
        view.addSubview(_topBar)
        _imgNumber = UILabel.init(frame: CGRect (x: (_topBar.frame.width - 120)/2, y: (_topBar.frame.height - 40)/2, width: 120, height: 40))
        _imgNumber.textAlignment = .center
        _imgNumber.textColor = UIColor.white
        _imgNumber.font = UIFont.systemFont(ofSize: 15)
        _topBar.addSubview(_imgNumber)
        _imgNumber.text = "已选择\(selectedDataArr.count)张"
        
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
        
        let selectbtn = UIButton (frame: CGRect (x: kCurrentScreenWidth - 50, y: 0, width: 40, height: 40))
        selectbtn.setImage(UIImage (named: "ImgPic_select_preview-1"), for: .normal)
        selectbtn.setImage(UIImage (named: "ImgPic_select_ok_preview"), for: .selected)
        
        selectbtn.imageEdgeInsets = UIEdgeInsets.init(top: 5, left: 5, bottom: 5, right: 5)
        selectbtn.addTarget(self, action: #selector(selectImageAction(_:)), for: .touchUpInside)
        _bottomBar.addSubview(selectbtn)
        _selectButton = selectbtn
        
        let okbutton = UIButton (frame: CGRect (x: 0, y: 0, width: 60, height: 40))
        _bottomBar.addSubview(okbutton)
        okbutton.setTitle("完成", for: .normal)
        okbutton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        okbutton.setTitleColor(UIColor.white, for: .normal)
        okbutton.addTarget(self, action: #selector(finished), for: .touchUpInside)
    }
    
    
    //MARK: - Toolbar  EVENT
    @objc func _dismiss() {
        if let handler = self.closeHandler {
            handler(self.selectedDataArr);
        }

        _ = self.navigationController?.popViewController(animated: false)
    }
    
    @objc func selectImageAction(_ btn:UIButton) {
        guard let _index = _colloectionview.indexPathsForVisibleItems.last?.row else {return}
        let asset = dataArry[_index]
        
        let _b = selectedDataArr.contains(asset);
        if _b {
            selectedDataArr.remove(at: selectedDataArr.firstIndex(of: asset)!);
        }else{
            guard selectedDataArr.count < maxImagesNumber else {
                HUD.show(info: "最多只能选择 \(self.maxImagesNumber) 张图片!");
                return;
            }
            
            selectedDataArr.append(asset);
        }
        
        _imgNumber.text = "已选择\(selectedDataArr.count)张"
        btn.isSelected = !btn.isSelected
    }
    
    @objc func finished()  {
        NotificationCenter.default.post(name: NSNotification.Name (rawValue: "notification_selectedimage_completion"), object: nil, userInfo: ["images":selectedDataArr])
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
extension TTImagePreviewController : UICollectionViewDelegate , UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArry.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TTImagePreviewCellIdentifier", for: indexPath) as! TTImagePreviewCell
        
        let asset = dataArry[indexPath.row]
        cell.setImage(asset, type: .preview, isSelected: true)
        cell.imageClickedHandler = {
            UIView.animate(withDuration: 0.2, animations: { [weak self] in
                guard let strongSelf = self else {return}
                
                if !strongSelf._toolBarIsHiden {
                    strongSelf._topBar.transform = CGAffineTransform.init(translationX: 0, y: -strongSelf._topBar.frame.height)
                    strongSelf._bottomBar.transform = CGAffineTransform.init(translationX: 0, y:strongSelf._bottomBar.frame.height)
                }else{
                    strongSelf._topBar.transform = CGAffineTransform.identity
                    strongSelf._bottomBar.transform = CGAffineTransform.identity
                }
            }) { [weak self] (finished) in
                guard let strongSelf = self else {return}
                strongSelf._toolBarIsHiden = !strongSelf._toolBarIsHiden
            }
        }
        
        if index == indexPath.row{
            let _b = selectedDataArr.count > 0 ? selectedDataArr.contains(asset) : false
            _selectButton.isSelected = _b
        }
        
        
        return cell
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let i = lroundf(Float(scrollView.contentOffset.x / (kCurrentScreenWidth + 10)))
        
        if index != i {
            index = i
            let asset = dataArry[i]
            _selectButton.isSelected = selectedDataArr.count > 0 ? selectedDataArr.contains(asset) : false
        }
        
    }

    
    
}



