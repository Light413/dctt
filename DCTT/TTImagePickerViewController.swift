//
//  TTImagePickerViewController.swift
//  DCTT
//
//  Created by gener on 2017/12/7.
//  Copyright © 2017年 Light.W. All rights reserved.
//

import UIKit
import Photos

class TTImagePickerViewController: BaseViewController ,UICollectionViewDelegate,UICollectionViewDataSource {

    var imageSelectedCompletionHandler:(([PHAsset]) -> Void)?
    var maxImagesNumber:Int = 0
    
    /*private variable*/
    private var imgDataArr = [PHAsset]()
    private var hasSelectedImageAsset = [PHAsset]()
    private var hasSelectNumber:UILabel!
    private var preViewBtn:UIButton!
    private var finishedBtn:UIButton!
    private var _colloectionview:UICollectionView!
    private let _barBtnColor:(disable:UIColor,enbale:UIColor) = (UIColor.lightGray,UIColor.black)
    
    private let kBottomBarHeight:CGFloat = 45
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        addNavigationItem()
        let frame = CGRect (x: 0, y: 0, width: view.frame.width, height: kCurrentScreenHeight - kBottomBarHeight);
        _colloectionview = colleciontView(frame)
        view.addSubview(_colloectionview)
        
        let bottomBtn = addBottomBar()
        preViewBtn = bottomBtn.preview
        finishedBtn = bottomBtn.finished
        
        //...
        let cameraRoll:PHAssetCollection = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumUserLibrary, options: nil).lastObject!
        
        let assets:PHFetchResult<PHAsset> = PHAsset.fetchAssets(in: cameraRoll, options: nil)
    
        assets.enumerateObjects({ [weak self ] (a, index, _b) in
            guard let strongSelf = self else{return}

            strongSelf.imgDataArr.insert(a, at: 0);

            
        })
        
        _colloectionview.reloadData()
        
        self.title = cameraRoll.localizedTitle
    }

    deinit {
        print("\(self.self) deinit")
    }
    
    //MARK:-
    fileprivate func colleciontView(_ frame:CGRect) -> UICollectionView {
        let _layout = UICollectionViewFlowLayout()
        let _w = (frame.width - 5) / 4
        
        _layout.itemSize = CGSize (width: _w, height: _w)
        _layout.minimumInteritemSpacing = 1
        _layout.minimumLineSpacing = 2
        _layout.scrollDirection = .vertical
        
        let collectionview = UICollectionView (frame: frame, collectionViewLayout: _layout)
        collectionview.delegate  = self
        collectionview.dataSource = self
        
        collectionview.register(UINib (nibName: "PublishImageCell", bundle: nil), forCellWithReuseIdentifier: "PublishImageCellIdentifier")

        collectionview.backgroundColor  = UIColor.white
        collectionview.showsHorizontalScrollIndicator = false
        collectionview.showsVerticalScrollIndicator = true
        collectionview.alwaysBounceVertical = true
        collectionview.contentInset = UIEdgeInsets.init(top: 5, left: 0, bottom: 0, right: 0)
        return collectionview
    }
    
    
    func addNavigationItem() {
        let leftbtn = UIButton (frame: CGRect (x: 0, y: 0, width: 30, height: 30))
        leftbtn.setImage(UIImage (named: "close_night"), for: .normal)
        
        leftbtn.addTarget(self, action: #selector(navigationBackButtonAction), for: .touchUpInside)
        let leftitem = UIBarButtonItem.init(customView: leftbtn)
        navigationItem.leftBarButtonItem = leftitem
        
        let numberLable = UILabel (frame: CGRect (x: 0, y: 0, width: 20, height: 20))
        numberLable.textColor = UIColor.white
        numberLable.font = UIFont.systemFont(ofSize: 15)
        numberLable.textAlignment = .center
        numberLable.layer.cornerRadius = numberLable.frame.width/2
        numberLable.layer.masksToBounds = true
        numberLable.backgroundColor = kAirplaneCell_head_selected_color
        
        let rightitem = UIBarButtonItem.init(customView: numberLable)
        
        let fixed = UIBarButtonItem  (barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        fixed.width = 10
        
        navigationItem.rightBarButtonItems = [fixed,rightitem]
        hasSelectNumber = numberLable
        hasSelectNumber.isHidden = true
    }
    
    @objc func navigationBackButtonAction() {
        self.dismiss(animated: true, completion: nil)
    }

    func addBottomBar() -> (preview:UIButton,finished:UIButton) {
        //bottomBar
        let _bottomBar = UIToolbar.init(frame: CGRect (x: 0, y: kCurrentScreenHeight - kBottomBarHeight - 100, width: kCurrentScreenWidth, height: kBottomBarHeight))
        _bottomBar.barStyle = .default
        _bottomBar.isTranslucent = true
        _bottomBar.setShadowImage(UIImage(), forToolbarPosition: .bottom)
        view.addSubview(_bottomBar)
        
        let previewbtn = UIButton (frame: CGRect (x: kCurrentScreenWidth - 50, y: 0, width: 40, height: 40))
        previewbtn.addTarget(self, action: #selector(previewBtnAction(_:)), for: .touchUpInside)
        previewbtn.setTitle("预览", for: .normal)
        previewbtn.setTitleColor(_barBtnColor.disable, for: .normal)
        previewbtn.isEnabled  = false
        previewbtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        _bottomBar.addSubview(previewbtn)
        
        let okbutton = UIButton (frame: CGRect (x: 0, y: 0, width: 60, height: 40))
        _bottomBar.addSubview(okbutton)
        okbutton.setTitle("完成", for: .normal)
        okbutton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        okbutton.setTitleColor(_barBtnColor.disable, for: .normal)
        okbutton.isEnabled = false
        okbutton.addTarget(self, action: #selector(finished), for: .touchUpInside)
        
        return (previewbtn,okbutton)
    }
    
    @objc func previewBtnAction( _ button:UIButton) {
        showPreviewController(0)
    }
    
    @objc func finished()  {
        if let handler = imageSelectedCompletionHandler {
            handler(hasSelectedImageAsset)
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: -
    func showPreviewController(_ index:Int , isPreview:Bool = true) {
        let vc = TTImagePreviewController();
        vc.dataArry = isPreview ? hasSelectedImageAsset : imgDataArr
        vc.selectedDataArr = hasSelectedImageAsset
        vc.index = index
        vc.maxImagesNumber = maxImagesNumber
        vc.closeHandler = {[weak self] selected in
            guard let strongSelf = self else {
                return
            }
            
            //重新刷新数据及状态
            strongSelf.hasSelectedImageAsset.removeAll()
            strongSelf.hasSelectedImageAsset = strongSelf.hasSelectedImageAsset + selected
            strongSelf._colloectionview.reloadData()
            strongSelf.setStatus()
        }
        
        self.navigationController?.pushViewController(vc, animated: false)//(vc, animated: false, completion: nil)
    }

    //设置按钮使能状态，已选中数字
    func setStatus()  {
        let bool = hasSelectedImageAsset.count > 0
        preViewBtn.setTitleColor(bool ? _barBtnColor.enbale : _barBtnColor.disable, for: .normal)
        preViewBtn.isEnabled = bool
        finishedBtn.setTitleColor(bool ? _barBtnColor.enbale : _barBtnColor.disable, for: .normal)
        finishedBtn.isEnabled = bool
        
        hasSelectNumber.isHidden = !bool
        hasSelectNumber.text = "\(hasSelectedImageAsset.count)"
    }
    
    
    //MARK:
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imgDataArr.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = "PublishImageCellIdentifier"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! PublishImageCell
        
        let asset = imgDataArr[indexPath.row]
        cell.cellSelectedHandler = {[weak self] bool -> Bool in
            guard let strongSelf = self else {return false}
            let _b = strongSelf.hasSelectedImageAsset.contains(asset);
            if _b {
                strongSelf.hasSelectedImageAsset.remove(at: strongSelf.hasSelectedImageAsset.firstIndex(of: asset)!);
            }else{
                if strongSelf.hasSelectedImageAsset.count < strongSelf.maxImagesNumber {
                    strongSelf.hasSelectedImageAsset.append(asset);
                }else{
                    HUD.show(info: "最多只能选择 \(strongSelf.maxImagesNumber) 张图片!")
                    return false
                }
                
            }
            
            strongSelf.setStatus();return true
        }
        
        let _b = hasSelectedImageAsset.contains(asset)
        cell.setImage(asset,type:.album,isSelected: _b)
        
        /*cell.viewWithTag(100)?.removeFromSuperview();
        
        let _mask = UIView (frame: cell.frame)
        _mask.backgroundColor = UIColor.black
        //_mask.alpha = 1
        _mask.tag = 100
        cell.addSubview(_mask)*/
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard self.hasSelectedImageAsset.count < self.maxImagesNumber else {
            let a = imgDataArr[indexPath.row]
            if hasSelectedImageAsset.contains(a) {
                showPreviewController(0 , isPreview: true)
            }else{
                HUD.show(info: "最多只能选择 \(self.maxImagesNumber) 张图片!");
            }
            
            return
        }
        
        showPreviewController(indexPath.row , isPreview: false)
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
