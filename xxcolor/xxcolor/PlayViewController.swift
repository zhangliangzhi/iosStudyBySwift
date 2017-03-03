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
    

    @IBOutlet weak var scoreLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func timeEverySec() {
        iSec -= 1
        self.title =  NSLocalizedString("Remaining Time", comment: "") + ":" + "\(iSec)"
        
        if iSec <= 0 {
            GameOver()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
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
    
    func play1() {
        // 1. 先将原来的v移除
        let rv = self.view.viewWithTag(888)
        if (rv != nil) {
            rv?.removeFromSuperview()
        }
        
        scoreLabel.text = "\(self.a)" + " " + NSLocalizedString("point", comment: "")
        totalScore = self.a
        
        self.a += 1;
        if (self.a % 5 == 0) {
            self.p += 1;
        }
        let height = self.view.bounds.size.height / CGFloat(p)
        let width = self.view.bounds.size.width / CGFloat(p)
        

        
        
        let v:UIView = UIView(frame: CGRect(x: 0, y: 64, width: self.view.bounds.size.width, height: height*CGFloat(p)-100))
        v.tag = 888
        self.view.addSubview(v)
        
        self.view.backgroundColor = UIColor.white
        v.backgroundColor = UIColor.white
        
        
        let s = arc4random() % UInt32(( p * p ))
        let hue:CGFloat = ( CGFloat(arc4random() % 128) / 256.0 )+0.5;
        let saturation:CGFloat = ( CGFloat(arc4random() % 128) / 256.0 ) + 0.5;
        let brightness:CGFloat = ( CGFloat(arc4random() % 128) / 256.0 ) + 0.5;
        
        for i in 0..<p*p {
            let imageButton = UIButton(frame: CGRect(x: width*(CGFloat(i/p)+0.025), y: ((height*0.83) * CGFloat(i%p)), width: width*0.95, height: height*0.8))
            
            imageButton.autoresizingMask = [UIViewAutoresizing.flexibleTopMargin , UIViewAutoresizing.flexibleBottomMargin,.flexibleLeftMargin , .flexibleRightMargin]
            
            if (i == Int(s) ) {
                let a2 = CGFloat(a) * 0.01
                let a3:CGFloat = 0.5 + a2
                imageButton.backgroundColor = UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: a3)
                imageButton.addTarget(self, action: #selector(play1), for: .touchDown)
            }else{
                imageButton.backgroundColor = UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1)
                imageButton.addTarget(self, action: #selector(GameOver), for: .touchDown)
            }
            v.addSubview(imageButton)
        }
 
    }
    
    func GameOver() -> Void {
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
            let scoreReport = GKScore(leaderboardIdentifier: "1")
            scoreReport.value = Int64(totalScore)
            
            let scoreArray:[GKScore] = [scoreReport]
            GKScore.report(scoreArray, withCompletionHandler: nil)
        }
    }

}
