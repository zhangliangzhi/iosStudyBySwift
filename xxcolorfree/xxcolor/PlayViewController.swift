//
//  PlayViewController.swift
//  xxcolor
//
//  Created by ZhangLiangZhi on 2017/2/28.
//  Copyright © 2017年 xigk. All rights reserved.
//

import UIKit
import CoreData
import GameKit
//import Firebase
import GoogleMobileAds

class PlayViewController: UIViewController {
    var _s = 0
    var _ss = 0
    var a = 0
    var p = 2
    var v:UIView!
    
    var totalScore = 0
    var interstitial: GADInterstitial!

    @IBOutlet weak var scoreLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    

    
    override func viewWillAppear(_ animated: Bool) {
        MobClick.event("UMPLAY")
        
        _s = 0
        _ss = 0
        a = 0
        p = 2
        totalScore = 0
        gScore = 0
        
        self.title = "\(0)" + " " + NSLocalizedString("point", comment: "")
        

        
        play1()
        addGoogleAdmob()
    }
    
    func addGoogleAdmob() -> Void {
        if (gGlobalSet?.ads)! == false {
            return
        }
        let admobbar = GADBannerView(adSize: GADAdSize(size: CGSize(width: 320, height: 50), flags: 0))
        self.view.addSubview(admobbar)
        
        
        // my id
        admobbar.adUnitID = "ca-app-pub-7431883824117566/8931319738"
        admobbar.rootViewController = self
        let requestbar = GADRequest()
//        requestbar.testDevices = kGADSimulatorID as? [Any]
        admobbar.load(requestbar)
        
//        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
//        bannerView.rootViewController = self
//        bannerView.loadRequest(GADRequest())
        
        
        admobbar.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.bottom.equalTo(self.view)
        }

        
        // 插页广告
        // my id
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-7431883824117566/1408052934")
        // test id
//        interstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910")
        let request = GADRequest()
        request.testDevices = ["2077ef9a63d2b398840261c8221a0c9b"]
        interstitial.load(request)
        
    }
    
    func play1() {
        // 1. 先将原来的v移除
        if (self.v != nil) {
            self.v.removeFromSuperview()
            self.v = nil
        }
        
        self.title = "\(self.a)" + " " + NSLocalizedString("point", comment: "")
        totalScore = self.a
        
        self.a += 1;
        if (self.a % 5 == 0) {
            self.p += 1;
        }

        v = UIView(frame: CGRect.zero)
        self.view.addSubview(v)
        v.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets(top: (navigationController?.navigationBar.frame.height)!, left: 0, bottom: 50, right: 0))
        }
        v.backgroundColor = UIColor.gray
        v.tag = 888
        
        self.view.backgroundColor = UIColor.white
        v.backgroundColor = UIColor.white
        
        
        let s = arc4random() % UInt32(( p * p ))
        let hue:CGFloat = ( CGFloat(arc4random() % 128) / 256.0 )+0.5;
        let saturation:CGFloat = ( CGFloat(arc4random() % 128) / 256.0 ) + 0.5;
        let brightness:CGFloat = ( CGFloat(arc4random() % 128) / 256.0 ) + 0.5;

        
        var arrBtns = [UIButton]()
        for i in 0..<p{
            for j in 0..<p {
                let indexOfKeys = i*p + j
                let btn = UIButton(type: .custom)
                v.addSubview(btn)
                arrBtns.append(btn)
                
                btn.backgroundColor = UIColor.red
                
                btn.layer.borderWidth = 5.0*(2.0/CGFloat(p)) + 0.5
                btn.layer.borderColor = UIColor.white.cgColor
                
                
                btn.snp.makeConstraints({ (make) in
                    make.width.equalTo(v.snp.width).multipliedBy(1.0/Double(p))
                    make.height.equalTo(v.snp.height).multipliedBy(1.0/Double(p))
                    
                    //添加垂直位置约束
                    if i == 0{
                        make.top.equalTo(0)
                    }else{
                        make.top.equalTo(arrBtns[indexOfKeys-p].snp.bottom)
                    }
                    
                    //添加水平位置约束
                    if j == 0{
                        make.left.equalTo(0)
                    }else{
                        make.left.equalTo(arrBtns[indexOfKeys-1].snp.right)
                    }
                    
                    
                })
                
                // 添加事件
                if (indexOfKeys == Int(s) ) {
                    let a2 = CGFloat(a) * 0.01
                    let a3:CGFloat = 0.5 + a2
                    btn.backgroundColor = UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: a3)
                    btn.addTarget(self, action: #selector(play1), for: .touchDown)
                }else{
                    btn.backgroundColor = UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1)
                    btn.addTarget(self, action: #selector(GameOver), for: .touchDown)
                }
            }
        }
 
    }
    
    func GameOver() -> Void {

        self.title = ""
        
        gScore = self.totalScore
        
        // 保存记录
        let one = NSEntityDescription.insertNewObject(forEntityName: "LocalRank", into: context) as! LocalRank
        one.score = Int32(totalScore)
        one.ptime = NSDate()
        context.insert(one)
        
        // 增加金币
        gGlobalSet?.coin += gScore
        
        // 保持数据库
        appDelegate.saveContext()
        
        // 上传GameCenter
        saveGameCenter()
        


        // 跳转结算界面
        let page = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "resultvc") as! ResultViewController
        navigationController?.pushViewController(page, animated: false)
        
        // 插页广告
        if (gGlobalSet?.ads)! == true {
            if interstitial.isReady {
                interstitial.present(fromRootViewController: self)
            }
        }

    }
    
    func saveGameCenter() -> Void {
        if GKLocalPlayer.localPlayer().isAuthenticated {
            let scoreReport = GKScore(leaderboardIdentifier: "Find_Color_Free_1")
            scoreReport.value = Int64(totalScore)
            
            let scoreArray:[GKScore] = [scoreReport]
            GKScore.report(scoreArray, withCompletionHandler: nil)
            
            // coin排行榜
            let coinReport = GKScore(leaderboardIdentifier: "Find_Color_Free_coin")
            coinReport.value = Int64((gGlobalSet?.coin)!)
            
            let coinArray:[GKScore] = [coinReport]
            GKScore.report(coinArray, withCompletionHandler: nil)
        }
    }

}
