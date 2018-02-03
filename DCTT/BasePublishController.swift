//
//  BasePublishController.swift
//  DCTT
//
//  Created by wyg on 2018/2/3.
//  Copyright © 2018年 Light.W. All rights reserved.
//

import UIKit
import Photos

class BasePublishController: BaseViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    var imgDataArr = [PHAsset]()
    
    var _colloectionview:UICollectionView!
    
    var kMaxImagesNumber:Int = 9
    private var presentViewController:UINavigationController!
    
    //MARK:
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = UIColor.white
        
        let frame = CGRect (x: 0, y: 0, width: view.frame.width, height: kCurrentScreenHeight - 64 - 45);
        _colloectionview = colleciontView(frame)
        view.addSubview(_colloectionview)
        view.backgroundColor = UIColor.red
        
        ///submint button
        let submintBtn = UIButton (frame: CGRect (x: 0, y: frame.maxY, width: frame.width, height: 45))
        submintBtn.setTitle("发布", for: .normal)
        submintBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        submintBtn.backgroundColor = tt_BarColor
        submintBtn.addTarget(self, action: #selector(submintBtnAction), for: .touchUpInside)
        
        view.addSubview(submintBtn)
        
        ////navigationItem
        navigationItem.leftBarButtonItem = leftNavigationItem()
        navigationItem.rightBarButtonItem = rightNavigationItem()
        
        ///监听图片选择完成事件
        NotificationCenter.default.addObserver(self, selector: #selector(selectImageCompletionNotification(_ :)), name: NSNotification.Name (rawValue: "notification_selectedimage_completion"), object: nil)
    }
    
    func selectImageCompletionNotification(_ notification:Notification)  {
        presentViewController.dismiss(animated: true) {
            
        }
        
        if let igs = notification.userInfo?["images"] as? [PHAsset] {
            self.imgDataArr = self.imgDataArr + igs
            self._colloectionview.reloadSections(IndexSet.init(integer: 1))
        }
        
    }
    
    func leftNavigationItem() -> UIBarButtonItem {
        let leftbtn = UIButton (frame: CGRect (x: 0, y: 0, width: 30, height: 30))
        leftbtn.setTitle("取消", for: .normal)
        leftbtn.setTitleColor(UIColor.darkGray, for: .normal)
        leftbtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        leftbtn.addTarget(self, action: #selector(navigationBackButtonAction), for: .touchUpInside)
        let leftitem = UIBarButtonItem.init(customView: leftbtn)
        return leftitem;
    }
    
    func rightNavigationItem() -> UIBarButtonItem{
        let rightbtn = UIButton (frame: CGRect (x: 0, y: 0, width: 30, height: 30))
        rightbtn.setTitle("预览", for: .normal)
        rightbtn.setTitleColor(UIColor.darkGray , for: .normal)//kAirplaneCell_head_selected_color
        rightbtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        rightbtn.addTarget(self, action: #selector(previewAction), for: .touchUpInside)
        let rightitem = UIBarButtonItem.init(customView: rightbtn)
        
        return rightitem
    }
    
    
    
    fileprivate func colleciontView(_ frame:CGRect) -> UICollectionView {
        let _layout = UICollectionViewFlowLayout()
        _layout.itemSize = CGSize (width: 10, height: 10)
        _layout.minimumInteritemSpacing = 0
        _layout.minimumLineSpacing = 5
        _layout.scrollDirection = .vertical
        
        let collectionview = UICollectionView (frame: frame, collectionViewLayout: _layout)
        collectionview.delegate  = self
        collectionview.dataSource = self
        
        collectionview.register(UINib (nibName: "PublishTextCell", bundle: nil), forCellWithReuseIdentifier: "PublishTextCellIdentifier")
        collectionview.register(UINib (nibName: "PublishImageCell", bundle: nil), forCellWithReuseIdentifier: "PublishImageCellIdentifier")
        collectionview.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "PublishAddIconCellIdentifier")
        
        
        collectionview.register(UINib (nibName: "PublishCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "PublishCollectionReusableViewIdentifier")
        collectionview.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: String (describing: UICollectionReusableView.self))
        
        collectionview.backgroundColor  = UIColor.white
        collectionview.showsHorizontalScrollIndicator = false
        collectionview.showsVerticalScrollIndicator = true
        collectionview.alwaysBounceVertical = true
        return collectionview
    }
    
    ///显示相册视图
    func showImagePicker()  {
        let vc = TTImagePickerViewController()
        //最大选择的数
        vc.maxImagesNumber = kMaxImagesNumber - imgDataArr.count
        
        vc.imageSelectedCompletionHandler = {[weak self]  images in
            guard let strongSelf = self else {
                return
            }
            
            strongSelf.imgDataArr = strongSelf.imgDataArr + images
            strongSelf._colloectionview.reloadSections(IndexSet.init(integer: 1))
        }
        
        presentViewController = UINavigationController(rootViewController:vc)
        self.navigationController?.present(presentViewController, animated: true, completion: nil)
    }
    
    //MARK: - Actions
    func navigationBackButtonAction() {
        self.dismiss(animated: true, completion: nil)
    }

    func previewAction() {}
    func submintBtnAction(){}
    
    //MARK:
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:return 1;
        case 1:return imgDataArr.count + 1 > 9 ? 9 : imgDataArr.count + 1;
        case 2:return 0;
        default:return 0;
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = (indexPath.section == 0) ? "PublishTextCellIdentifier": imgDataArr.count == indexPath.row ? "PublishAddIconCellIdentifier":"PublishImageCellIdentifier"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
        
        let section = indexPath.section
        if section == 0 {
            
        }else if section == 1 {
            if indexPath.row < imgDataArr.count {
                let cell = cell as! PublishImageCell
                cell.cellSelectedHandler = {[weak self] b -> Bool in
                    guard let strongSelf = self else {return false}
                    strongSelf.imgDataArr.remove(at: indexPath.row)
                    strongSelf._colloectionview.reloadData()
                    return true
                }
                
                let asset = imgDataArr[indexPath.row]
                cell.setImage(asset, type: .publish)
                cell.backgroundColor = UIColor.white;
            }else{
                for _v in cell.contentView.subviews {
                    _v.removeFromSuperview();
                }
                
                let igv = UIImageView (frame: CGRect (x: (cell.frame.width - 30)/2, y: (cell.frame.height - 30)/2, width: 30, height: 30))
                igv.image = UIImage (named: "addicon_repost")
                cell.contentView.addSubview(igv)
                cell.backgroundColor = UIColor (colorLiteralRed: 244/255.0, green: 245/255.0, blue: 246/255.0, alpha: 1)
            }
        }else{
            cell.backgroundColor = UIColor.white;
        }
        
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if imgDataArr.count == indexPath.row {
            let alertViewContronller = UIAlertController.init(title: "添加照片", message: nil, preferredStyle: .actionSheet)
            let action1 = UIAlertAction.init(title: "从相册选择", style: .default, handler: { [weak self] (action) in
                guard let strongSelf = self else {return}
                strongSelf.showImagePicker()
            })
            
            let action2 = UIAlertAction.init(title: "拍照", style: .default, handler: { (action) in
                
            })
            
            let action3 = UIAlertAction.init(title: "取消", style: .cancel, handler: nil)
            
            alertViewContronller.addAction(action1)
            alertViewContronller.addAction(action2)
            alertViewContronller.addAction(action3)
            
            self.navigationController?.present(alertViewContronller, animated: true, completion: nil)
        }else{//...大图显示
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionFooter {
            let identifier = indexPath.section < 2 ? String (describing: UICollectionReusableView.self):"PublishCollectionReusableViewIdentifier"
            
            let _v = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: identifier, for: indexPath)
            
            var _c:UIColor!
            switch indexPath.section {
            case 0:_c = UIColor.white;break
            case 1:_c = kTableviewBackgroundColor;break
            case 2:_c = UIColor.white;break
                
            default:break
            }
            
            _v.backgroundColor = _c
            
            return _v
            
        }
        
        let v = UICollectionReusableView()
        v.backgroundColor = UIColor.white
        
        return v
    }
    
    
    //MARK:
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize (width: kCurrentScreenWidth - 20, height: 100)
        }
        
        let _w = (kCurrentScreenWidth - 20 - 10) / 3
        
        return CGSize (width: _w, height: 100)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize (width: collectionView.frame.width, height: section > 1 ? 50:(section == 0 ? 0:10))
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section < 2 {
            return UIEdgeInsetsMake(5, 10, 5, 10)
        }
        
        return UIEdgeInsets.zero
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
