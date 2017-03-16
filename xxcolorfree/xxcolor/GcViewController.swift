//
//  GcViewController.swift
//  xxcolor
//
//  Created by ZhangLiangZhi on 2017/2/26.
//  Copyright © 2017年 xigk. All rights reserved.
//

import UIKit
import GameKit

class GcViewController: UIViewController, GKGameCenterControllerDelegate {

    @IBOutlet weak var ScoreLbl: UILabel!
    
    var score = 0
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        autoPlayer()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        ScoreLbl.text = "\(score)"
    }
    
    @IBAction func AddScore(_ sender: Any) {
        score += 1
        ScoreLbl.text = "\(score)"
        SaveHightScore(num: score)
    }

    @IBAction func OpenGC(_ sender: Any) {
        let VC = self.view.window?.rootViewController
        let GCVC = GKGameCenterViewController()
        GCVC.gameCenterDelegate = self
        VC?.present(GCVC, animated: true, completion: nil)
    }
    
    func SaveHightScore(num:Int){
        if GKLocalPlayer.localPlayer().isAuthenticated {
            let scoreReport = GKScore(leaderboardIdentifier: "1")
            scoreReport.value = Int64(num)
            
            let scoreArray:[GKScore] = [scoreReport]
            GKScore.report(scoreArray, withCompletionHandler: nil)
        }
        
    }
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
