//
//  RTabBarViewController.swift
//  ColorWar
//
//  Created by ZhangLiangZhi on 2017/6/6.
//  Copyright © 2017年 xigk. All rights reserved.
//

import UIKit

class RTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        creatSubViewControllers()
    }

    func creatSubViewControllers(){
        let v1  = MainViewController()
        let item1 : UITabBarItem = UITabBarItem (title: "象形字典", image: UIImage(named: "honor"), selectedImage: UIImage(named: "honor"))
        v1.tabBarItem = item1
        
        let v2 = MainViewController()
        let item2 : UITabBarItem = UITabBarItem (title: "荣誉", image: UIImage(named: "icon_Battle"), selectedImage: UIImage(named: "icon_Battle"))
        v2.tabBarItem = item2
        
        
        let v3 = MainViewController()
        let item3 : UITabBarItem = UITabBarItem (title: "字", image: UIImage(named: "icon_Battle"), selectedImage: UIImage(named: "icon_Battle"))
        v3.tabBarItem = item3
        
        
        
        let n1 = UINavigationController(rootViewController: v1)
        let n2 = UINavigationController(rootViewController: v2)
        let n3 = UINavigationController(rootViewController: v3)
        let tabArray = [n1, n2, n3]
        self.viewControllers = tabArray
        
        //默认选中的是游戏主界面视图
        self.selectedIndex = 0
    }
    
}
