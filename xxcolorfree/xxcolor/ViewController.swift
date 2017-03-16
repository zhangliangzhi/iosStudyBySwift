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
import GameKit

let appDelegate = UIApplication.shared.delegate as! AppDelegate
let context = appDelegate.persistentContainer.viewContext

var arrGlobalSet:[CurGlobalSet] = []
var gGlobalSet:CurGlobalSet?

var gScore = 0

class ViewController: UIViewController, GKGameCenterControllerDelegate {

    var mainv:UIView!
    var playv:UIView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        autoPlayer()
        self.title = NSLocalizedString("Find Color", comment: "")
//        self.view.backgroundColor = UIColor.darkGray
        
        firstOpenAPP()
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
        
        let cw = self.view.frame.width/2 - 75

        let btnOneSec: BootstrapBtn = BootstrapBtn(frame: CGRect(x:cw, y:190, width:150, height:40), btButtonType: .Success)
        btnOneSec.setTitle(NSLocalizedString("Start Game", comment: ""), for: UIControlState.normal)
        btnOneSec.addTarget(self, action: #selector(playOneMin), for: .touchUpInside)
        self.view.addSubview(btnOneSec)
        
        let btnShowLocal: BootstrapBtn = BootstrapBtn(frame: CGRect(x:cw, y:260, width:150, height:40), btButtonType: .Warning)
        btnShowLocal.setTitle(NSLocalizedString("Local Ranking", comment: ""), for: UIControlState.normal)
        btnShowLocal.addTarget(self, action: #selector(showMyRank), for: .touchUpInside)
        self.view.addSubview(btnShowLocal)
        
        let gcBtn: BootstrapBtn = BootstrapBtn(frame: CGRect(x:cw, y:330, width:150, height:40), btButtonType: .Primary)
        gcBtn.setTitle(NSLocalizedString("All Rank", comment: ""), for: UIControlState.normal)
        gcBtn.addTarget(self, action: #selector(showGC), for: .touchUpInside)
        self.view.addSubview(gcBtn)
    }
    
    func showGC() -> Void {
        MobClick.event("UMGRANK")
        
        let GCVC = GKGameCenterViewController()
        GCVC.gameCenterDelegate = self
        self.present(GCVC, animated: true, completion: nil)
    }
    
    func autoPlayer() {
        let localPlayer = GKLocalPlayer.localPlayer()
        localPlayer.authenticateHandler = {
            (view, error) in
            if view != nil{
                self.present(view!, animated: true, completion:nil)
            }else{
                print(GKLocalPlayer.localPlayer().isAuthenticated)
            }
        }
    }
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
    
    func playOneMin() -> Void {
        let page = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "playID") as! PlayViewController
        navigationController?.pushViewController(page, animated: true)
    }
    
    
    func showMyRank() -> Void {
        MobClick.event("UMLRANK")
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

