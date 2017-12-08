//
//  TTImagePreviewController.swift
//  DCTT
//
//  Created by gener on 2017/12/8.
//  Copyright © 2017年 Light.W. All rights reserved.
//

import UIKit

class TTImagePreviewController: TTImageBaseViewController{

    override var prefersStatusBarHidden: Bool {
        get{
            return true;
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        addNavigationItem()
        
    }

    
    
    func addNavigationItem() {
        let _topBg = UIView .init(frame: CGRect (x: 0, y: 0, width: kCurrentScreenWidth, height: 50))
        _topBg.backgroundColor = tt_defafault_barColor
        view.addSubview(_topBg)
        
        let leftbtn = UIButton (frame: CGRect (x: 15, y: 10, width: 35, height: 35))
        leftbtn.setImage(UIImage (named: "close_night"), for: .normal)
        
        leftbtn.addTarget(self, action: #selector(navigationBackButtonAction), for: .touchUpInside)

        _topBg.addSubview(leftbtn)
        
    }
    
    func navigationBackButtonAction() {
        self.dismiss(animated: false, completion: nil)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        
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
