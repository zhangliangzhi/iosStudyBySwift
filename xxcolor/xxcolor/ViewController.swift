//
//  ViewController.swift
//  xxcolor
//
//  Created by ZhangLiangZhi on 2017/2/20.
//  Copyright © 2017年 xigk. All rights reserved.
//

import UIKit
import CoreData
import SnapKit

let appDelegate = UIApplication.shared.delegate as! AppDelegate
let context = appDelegate.persistentContainer.viewContext

var arrGlobalSet:[CurGlobalSet] = []
var gGlobalSet:CurGlobalSet?

var gScore = 0

class ViewController: UIViewController {

    var mainv:UIView!
    var playv:UIView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        self.title = NSLocalizedString("Find Color", comment: "")
        
//        firstOpenAPP()
        self.mainv = UIView()
        self.view.addSubview(self.mainv)
        self.playv = UIView()
        self.view.addSubview(self.playv)
        mainv.snp.makeConstraints { (make) in
            make.center.equalTo(self.view)
            make.width.height.equalTo(self.view)
        }
        playv.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        
        let cw = self.view.frame.width/2 - 50

        let btnOneSec: BootstrapBtn = BootstrapBtn(frame: CGRect(x:cw, y:190, width:100, height:40), btButtonType: .Primary)
        btnOneSec.setTitle(NSLocalizedString("Start Game", comment: ""), for: UIControlState.normal)
        btnOneSec.addTarget(self, action: #selector(playOneMin), for: .touchUpInside)
        self.view.addSubview(btnOneSec)
        
        let btnShowLocal: BootstrapBtn = BootstrapBtn(frame: CGRect(x:cw, y:260, width:100, height:40), btButtonType: .Primary)
        btnShowLocal.setTitle(NSLocalizedString("Ranking", comment: ""), for: UIControlState.normal)
        btnShowLocal.addTarget(self, action: #selector(showMyRank), for: .touchUpInside)
        self.view.addSubview(btnShowLocal)
    }
    
    func playOneMin() -> Void {
        let page = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "playID") as! PlayViewController
        navigationController?.pushViewController(page, animated: true)
    }
    
    
    func showMyRank() -> Void {
        navigationController?.pushViewController(LocalRankViewController(), animated: true)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // 获取数据
    func getCoreData() -> Void {
        arrGlobalSet = []
        do {
            arrGlobalSet = try context.fetch(CurGlobalSet.fetchRequest())
        }catch {
            print("Setting coreData error")
        }
        
        if arrGlobalSet.count > 0 {
            gGlobalSet = arrGlobalSet[0]
        }
    }
    
    // 第一次打开app，加入测试数据
    func firstOpenAPP() -> Void {
        getCoreData()
        
        // 初始化
        if arrGlobalSet.count > 0 {
            return
        }
        let oneGlobalSet = NSEntityDescription.insertNewObject(forEntityName: "CurGlobalSet", into: context) as! CurGlobalSet
        
        
        oneGlobalSet.openCount = 1      // 打开app次数
        oneGlobalSet.evaluate = 0       // 是否评分
        
        context.insert(oneGlobalSet)
        appDelegate.saveContext()
        
        getCoreData()
    }
    
}

