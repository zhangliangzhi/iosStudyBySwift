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

class PlayViewController: UIViewController {
    var _s = 0
    var _ss = 0
    var a = 0
    var p = 2
    var timer:Timer!
    var iSec = 60
    var totalScore = 0
    
    var v:UIView!
    
    var buyView:UIView!
    var isPause = false
    var arrBtns = [UIButton]()
    var curBtnIndex = 0
    var vipUseCount = 0

    @IBOutlet weak var scoreLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dItem = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(descDiamon))
        navigationItem.leftBarButtonItem = dItem
        
        let barItem = UIBarButtonItem(title: NSLocalizedString("Use Diamond", comment: "")+strzs, style: .plain, target: self, action: #selector(goHelpTips))
        navigationItem.rightBarButtonItem = barItem
    }

    func timeEverySec() {
        if isPause {
            return
        }
        
        iSec -= 1
        self.title =  NSLocalizedString("Remaining Time", comment: "") + ":" + "\(iSec)"
        
        if iSec <= 0 {
            GameOver()
        }
    }
    
    func descDiamon() {
        let dia = " " + String(format: "%d", (gGlobalSet?.diamon)!) + " "
        let strShow = NSLocalizedString("You have", comment: "") + dia + strzs
        TipsSwift.showTopWithText(strShow)
        
        let title = NSLocalizedString("Buy Diamond", comment: "")
        let msg = NSLocalizedString("TO BUY DIAMOND", comment: "")
        let sok = NSLocalizedString("OK", comment: "")
        let scancle = NSLocalizedString("Cancle", comment: "")
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: sok, style: .default, handler: { (action) in
            ShopViewController.buy320()
        }))
        alert.addAction(UIAlertAction(title: scancle, style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func tobuyDiamond() {
        
    }
    
    func reSetDiamond() {
        let dia = String(format: "%d", (gGlobalSet?.diamon)!) + " "
        self.navigationItem.leftBarButtonItem?.title = dia + strzs
    }
    
    override func viewWillAppear(_ animated: Bool) {
        MobClick.event("UMPLAY")
        
        reSetDiamond()
        vipUseCount = 0
        _s = 0
        _ss = 0
        a = 0
        p = 2
        totalScore = 0
        gScore = 0
        
        scoreLabel.text = "\(0)" + " " + NSLocalizedString("point", comment: "")
        self.title = NSLocalizedString("Remaining Time", comment: "") + ":60"
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timeEverySec), userInfo: nil, repeats: true)
        iSec = 60
        
        play1()
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func play1() {
        if isPause {
            return
        }
        // 1. 先将原来的v移除
        if(self.v != nil){
            self.v.removeFromSuperview()
            self.v = nil
            curBtnIndex = 0
            arrBtns = []
        }
        
        scoreLabel.text = "\(self.a)" + " " + NSLocalizedString("point", comment: "")
        totalScore = self.a
        
        self.a += 1;
        if (self.a % 5 == 0) {
            self.p += 1;
        }

        v = UIView(frame: CGRect.zero)
        self.view.addSubview(v)
        v.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets(top: (navigationController?.navigationBar.frame.height)!, left: 0, bottom: 30, right: 0))
        }
        v.backgroundColor = UIColor.gray
        v.tag = 888
        
        self.view.backgroundColor = UIColor.white
        v.backgroundColor = UIColor.white
        
        
        let s = arc4random() % UInt32(( p * p ))
        let hue:CGFloat = ( CGFloat(arc4random() % 128) / 256.0 )+0.5;
        let saturation:CGFloat = ( CGFloat(arc4random() % 128) / 256.0 ) + 0.5;
        let brightness:CGFloat = ( CGFloat(arc4random() % 128) / 256.0 ) + 0.5;
        
        
        arrBtns = []
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
                curBtnIndex = Int(s)
                if (indexOfKeys == Int(s) ) {
                    let a2 = CGFloat(a) * 0.01
                    var a3:CGFloat = 0.5 + a2
//                    print(self.totalScore, "OKhere",a3)
                    if a >= 45 {
                        let mindex:Int = Int( arc4random() % UInt32(ARR_MAX_COLOR.count - 2) )
                        print(mindex)
                        a3 = CGFloat(ARR_MAX_COLOR[mindex] )
                    }
//                    print(self.totalScore, "OKhere",a3)
                    
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
        if isPause {
            return
        }
        timer.invalidate()
        timer = nil
        self.title = ""
        
        gScore = self.totalScore
        
        // 保存记录
        let one = NSEntityDescription.insertNewObject(forEntityName: "LocalRank", into: context) as! LocalRank
        one.score = Int32(totalScore)
        one.ptime = NSDate()
        context.insert(one)
        appDelegate.saveContext()
        
        // 上传GameCenter
        saveGameCenter()
        
        // 跳转结算界面
        let page = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "resultvc") as! ResultViewController
        navigationController?.pushViewController(page, animated: false)
    }
    
    func saveGameCenter() -> Void {
        if GKLocalPlayer.localPlayer().isAuthenticated {
            var strID = "1"
            if vipUseCount > 0 {
                strID = "Find_Color_IN_Time"
            }
            let scoreReport = GKScore(leaderboardIdentifier: strID)
            scoreReport.value = Int64(totalScore)
            
            let scoreArray:[GKScore] = [scoreReport]
            GKScore.report(scoreArray, withCompletionHandler: nil)
        }
    }

    func goHelpTips() -> Void {
        MobClick.event("UMSHOPUSE")
        closeBuyView2()
        isPause = true
        buyView = UIView()
        self.view.addSubview(buyView)
        buyView.snp.makeConstraints { (make) in
            make.center.equalTo(self.view)
            make.width.equalTo(self.view).multipliedBy(0.85)
            make.height.equalTo(150)
        }
        buyView.backgroundColor = UIColor.white
        
        let closeBtn = UIButton(type: .custom)
        closeBtn.setImage(UIImage(named: "close"), for: .normal)
        buyView.addSubview(closeBtn)
        closeBtn.snp.makeConstraints { (make) in
            make.left.equalTo(buyView.snp.left).offset(-10)
            make.top.equalTo(buyView.snp.top).offset(-10)
        }
        closeBtn.addTarget(self, action: #selector(closeBuyView1), for: .touchUpInside)
        
        // add second button
        let btnAddSec = BootstrapBtn(frame: CGRect(x: 0, y: 0, width: 250, height: 50), btButtonType: .Success)
        buyView.addSubview(btnAddSec)
        btnAddSec.addTarget(self, action: #selector(addSecond), for: .touchUpInside)
        btnAddSec.setTitle(NSLocalizedString("addsec", comment: "")+strzs, for: .normal)
        btnAddSec.snp.makeConstraints { (make) in
            make.centerX.equalTo(buyView)
            make.centerY.equalTo(buyView).offset(-20)
        }
        
        let takeDiamond = Int32(self.totalScore)
        // tell me which one buttom
        let btnShowme = BootstrapBtn(frame: CGRect(x: 0, y: 0, width: 250, height: 50), btButtonType: .Success)
        buyView.addSubview(btnShowme)
        btnShowme.addTarget(self, action: #selector(showMeWhichOne), for: .touchUpInside)
        btnShowme.setTitle(NSLocalizedString("showme", comment: "") + ("-" + "\(takeDiamond)" + "💎"), for: .normal)
        btnShowme.snp.makeConstraints { (make) in
            make.centerX.equalTo(buyView)
            make.centerY.equalTo(buyView).offset(20)
        }
        
        // have total diamond
        let dia = String(format: "%d", (gGlobalSet?.diamon)!) + " "
        let strDiamond = dia + strzs
        
        let lblDiamond = UILabel()
        buyView.addSubview(lblDiamond)
        lblDiamond.text = strDiamond
        lblDiamond.textColor = UIColor.black
        lblDiamond.font = UIFont(name: "Arial-BoldMT", size: 20)
        lblDiamond.textAlignment = .center //文字中心对齐
        lblDiamond.snp.makeConstraints { (make) in
            make.centerX.equalTo(buyView)
            make.top.equalTo(buyView)
        }
    }
    
    func closeBuyView1() {
        MobClick.event("UMSHOPCLOSE")
        if buyView != nil {
            buyView.removeFromSuperview()
            buyView = nil
        }
        isPause = false
        reSetDiamond()
    }
    func closeBuyView2() {
        if buyView != nil {
            buyView.removeFromSuperview()
            buyView = nil
        }
        isPause = false
        reSetDiamond()
    }
    
    // add 10 second -10 diamond
    func addSecond() {
        MobClick.event("UMSHOP10")
        if (gGlobalSet?.diamon)! < 10 {
            TipsSwift.showCenterWithText(NSLocalizedString("nodiamond", comment: ""))
            return
        }
        MobClick.event("UMSHOP10GO")
        gGlobalSet?.diamon -= 10
        appDelegate.saveContext()
        TipsSwift.showCenterWithText("-10💎")
        iSec += 10
        closeBuyView2()
    }
    
    // tell me which one. -30 diamond
    func showMeWhichOne() {
        MobClick.event("UMSHOP30")
        let takeDiamond = Int32(self.totalScore)
        if (gGlobalSet?.diamon)! < takeDiamond {
            TipsSwift.showCenterWithText(NSLocalizedString("nodiamond", comment: ""))
            return
        }
        MobClick.event("UMSHOP30GO")
        gGlobalSet?.diamon -= takeDiamond
        appDelegate.saveContext()
        closeBuyView2()
        let btn = arrBtns[curBtnIndex]
        btn.layer.borderColor = UIColor.orange.cgColor
        if self.totalScore >= 47 {
            btn.layer.borderColor = UIColor.black.cgColor
        }
        
        TipsSwift.showCenterWithText("-" + "\(takeDiamond)" + "💎")
        vipUseCount += 1
    }
    
}
