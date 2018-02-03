//
//  PublishFriendViewController.swift
//  DCTT
//
//  Created by wyg on 2018/2/3.
//  Copyright © 2018年 Light.W. All rights reserved.
//

import UIKit

class PublishFriendViewController: BasePublishController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.        
        kMaxImagesNumber = 1
        
    }
    
    override func previewAction() {
        let vc = FriendsDetailController()
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    //MARK:
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:return 1;
        case 1:return imgDataArr.count > 0 ? 1 :  1;
        case 2:return 0;
        default:return 0;
        }
        
    }
    

    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize (width: kCurrentScreenWidth - 20, height: 80)
        }
        
        let _w = (kCurrentScreenWidth - 20 )
        
        return imgDataArr.count > 0 ? CGSize (width: _w, height: _w * 0.8): CGSize (width: _w / 3.0, height: 100)
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
