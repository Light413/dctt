//
//  HomeSearchViewController.swift
//  DCTT
//
//  Created by gener on 17/11/22.
//  Copyright © 2017年 Light.W. All rights reserved.
//

import UIKit

class HomeSearchViewController: BaseViewController ,TTSearchBarDelegate{
    override func viewDidLoad() {
        super.viewDidLoad()

        let _topBg = UIView .init(frame: CGRect (x: 0, y: 0, width: kCurrentScreenWidth, height: 64))
        _topBg.backgroundColor = UIColor.white
        view.addSubview(_topBg)
        
        //search
        let search = TTSearchBarView (frame: CGRect (x: 15, y: 27, width: _topBg.frame.width - 20, height: 30))
        search.delegate = self
        _topBg.addSubview(search)
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        
    }

    
    ////TTSearchBarDelegate
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print(textField.text)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) {
        
    }
    
    func cancle() {
        _ = self.navigationController?.popViewController(animated: true)
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
