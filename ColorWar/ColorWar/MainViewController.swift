//
//  MainViewController.swift
//  ColorWar
//
//  Created by ZhangLiangZhi on 2017/6/6.
//  Copyright © 2017年 xigk. All rights reserved.
//

import UIKit
import SnapKit
import CoreData


let appDelegate = UIApplication.shared.delegate as! AppDelegate
let context = appDelegate.persistentContainer.viewContext
var arrGlobalData:[GlobalData] = []
var curGlobal:GlobalData?


class MainViewController: UIViewController {

    var rootv:UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        rootv = UIView()
        self.view.addSubview(rootv)
        rootv.snp.makeConstraints { (make) in
            make.width.equalTo(self.view)
            make.centerX.equalTo(self.view)
            make.bottom.equalTo(self.view).offset(-44)
            make.top.equalTo(self.view).offset(64)
        }
        
        initUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.getCoreData()
        firstOpenAPP()
        
        
    }

    func initUI() {
        
    }
    
    // 第一次打开app，加入测试数据
    func firstOpenAPP() -> Void {
        // 初始化
        if arrGlobalData.count > 0 {
            return
        }
        
        let oneGlobalSet = NSEntityDescription.insertNewObject(forEntityName: "GlobalData", into: context) as! GlobalData
        
        oneGlobalSet.coin = 0
        oneGlobalSet.diamond = 0
        oneGlobalSet.exp = 0
        oneGlobalSet.id = 0
        oneGlobalSet.token = ""
        oneGlobalSet.level = 0
        oneGlobalSet.nickname = ""
        
        context.insert(oneGlobalSet)
        appDelegate.saveContext()
        self.getCoreData()
    }
    
    func getCoreData() -> Void {
        arrGlobalData = []
        
        do {
            arrGlobalData = try context.fetch(GlobalData.fetchRequest())
        }catch {
            print("Setting coreData error")
        }
        
        
        // last
        if arrGlobalData.count > 0 {
            curGlobal = arrGlobalData[0]
            
        }
    }

}
