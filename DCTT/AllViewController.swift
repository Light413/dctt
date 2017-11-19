//
//  AllViewController.swift
//  DCTT
//
//  Created by wyg on 2017/11/11.
//  Copyright © 2017年 Light.W. All rights reserved.
//

import UIKit

class AllViewController: BaseViewController,UIPageViewControllerDelegate,UIPageViewControllerDataSource {

    var vcArr = [BaseTableViewController]()
    var index = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false;
        
        for _ in 0..<5 {
            let v = BaseTableViewController();
            vcArr.append(v)
        }

        let pagevc = UIPageViewController.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pagevc.view.frame = CGRect (x: 0, y: 0, width: kCurrentScreenWidth, height: kCurrentScreenHeight - 64 - 49)
        
        pagevc.delegate = self
        pagevc.dataSource = self
        
        pagevc.setViewControllers([vcArr[0]], direction: .forward, animated: false, completion: nil)
        
        self.addChildViewController(pagevc)
        view.addSubview(pagevc.view)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        print(#function)
        index = index + 1
        if index >= vcArr.count {return nil}
        
        
        return vcArr[index]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        print(#function)
        index = index - 1
        if index < 0 {return nil}
        
        return vcArr[index]
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
