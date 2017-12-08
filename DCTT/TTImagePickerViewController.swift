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

//    override var prefersStatusBarHidden: Bool {
//        get{
//            return true;
//        }
//    }
    

    
    var imgDataArr = [PHAsset]()
    
    var hasSelectedIndex = [Int]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        addNavigationItem()
        let frame = CGRect (x: 0, y: 0, width: view.frame.width, height: kCurrentScreenHeight - 0);
        let _colloectionview = colleciontView(frame)
        view.addSubview(_colloectionview)
        
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
        print("----")
    }
    
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
        return collectionview
    }
    
    
    func addNavigationItem() {
        let leftbtn = UIButton (frame: CGRect (x: 0, y: 0, width: 30, height: 30))
        leftbtn.setImage(UIImage (named: "close_night"), for: .normal)

        leftbtn.addTarget(self, action: #selector(navigationBackButtonAction), for: .touchUpInside)
        let leftitem = UIBarButtonItem.init(customView: leftbtn)
        navigationItem.leftBarButtonItem = leftitem
        
    }
    
    func navigationBackButtonAction() {
        self.dismiss(animated: true, completion: nil)
    }

    //MARK:
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imgDataArr.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = "PublishImageCellIdentifier"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! PublishImageCell
        
        cell.cellSelectedHandler = {[weak self] bool in
            guard let strongSelf = self else {
                return
            }
            
            let _b = strongSelf.hasSelectedIndex.contains(indexPath.row);
            if _b {
                strongSelf.hasSelectedIndex.remove(at: strongSelf.hasSelectedIndex.index(of: indexPath.row)!);
            }else{
                strongSelf.hasSelectedIndex.append(indexPath.row);
            }
        }
        
        let _b = hasSelectedIndex.contains(indexPath.row)
        cell.setImage(imgDataArr[indexPath.row],type:.album,isSelected: _b)
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = TTImagePreviewController();
        
        self.navigationController?.present(vc, animated: false, completion: nil)

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
