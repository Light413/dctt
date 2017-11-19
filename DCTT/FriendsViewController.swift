//
//  FriendsViewController.swift
//  DCTT
//
//  Created by wyg on 2017/11/11.
//  Copyright © 2017年 Light.W. All rights reserved.
//

import UIKit

class FriendsViewController: BaseViewController,UIScrollViewDelegate {

    let _scrollview = UIScrollView()
    let _height = kCurrentScreenHeight - 64 - 49
    var vcArr = [BaseTableViewController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        _scrollview.frame = CGRect(x: 0, y: 0, width: kCurrentScreenWidth, height: _height)
        _scrollview.contentSize = CGSize (width: kCurrentScreenWidth * 5, height: _height)
        _scrollview.isPagingEnabled = true
        _scrollview.showsHorizontalScrollIndicator = false
        _scrollview.delegate  = self
        
        automaticallyAdjustsScrollViewInsets = false
        view.addSubview(_scrollview)
        
        for i in 0..<5 {
            let v = BaseTableViewController();
            var ds = [String]()
            v.view.frame =  CGRect (x: CGFloat.init(i) * kCurrentScreenWidth, y: 0, width: _scrollview.frame.width, height: _scrollview.frame.height)
            
            for n in 0..<10 {
                ds.append("\(n + 1)")
            }
            v.dataArray = ds

            self.addChildViewController(v)
            vcArr.append(v)
            _scrollview.addSubview(v.view)
        }

    }


    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index = scrollView.contentOffset.x / kCurrentScreenWidth
        print(lrintf(Float(index)))

//        let  i = lrintf(Float(index))
//        let v = vcArr[i]
//        v.tableView.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: .none, animated: false)
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
