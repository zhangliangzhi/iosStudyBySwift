//
//  ResultViewController.swift
//  xxcolor
//
//  Created by ZhangLiangZhi on 2017/2/28.
//  Copyright © 2017年 xigk. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {


    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var btnOK: UIButton!
    @IBOutlet weak var bntRank: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = NSLocalizedString("Game Over", comment: "")
        // "💎"，💵
        scoreLabel.text = "\(gScore)" + " " + NSLocalizedString("point", comment: "")
        
        let cx = scoreLabel.center.x
        let cy = scoreLabel.center.y
        
        let cw = self.view.frame.width/2 - 75
        let oBtn: BootstrapBtn = BootstrapBtn(frame: CGRect(x:cw, y:cy+160, width:150, height:40), btButtonType: .Info)
        self.view.addSubview(oBtn)
        oBtn.setTitle(NSLocalizedString("OK", comment: ""), for: UIControlState.normal)
        oBtn.addTarget(self, action: #selector(OKAction), for: .touchUpInside)
        
        let rBtn: BootstrapBtn = BootstrapBtn(frame: CGRect(x:cw, y:cy+80, width:150, height:40), btButtonType: .Success)
        self.view.addSubview(rBtn)
        rBtn.setTitle(NSLocalizedString("play again", comment: ""), for: UIControlState.normal)
        rBtn.addTarget(self, action: #selector(ShowLocalRank), for: .touchUpInside)
        
        btnOK.setTitle(NSLocalizedString("OK", comment: ""), for: .normal)
        bntRank.setTitle(NSLocalizedString("play again", comment: ""), for: .normal)
        
        btnOK.removeFromSuperview()
        bntRank.removeFromSuperview()
        
        
        // 位置修正
        oBtn.snp.makeConstraints { (make) in
            make.width.equalTo(150)
            make.height.equalTo(40)
            make.centerX.equalTo(self.view)
            make.centerY.equalTo(self.view).offset(-20)
        }
        rBtn.snp.makeConstraints { (make) in
            make.width.equalTo(150)
            make.height.equalTo(40)
            make.centerX.equalTo(oBtn)
            make.bottom.equalTo(oBtn.snp.top).offset(-30)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func OKAction(_ sender: Any) {
        let rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()! as UIViewController
        
        self.present(rootViewController, animated: true) {
            
        }
    }
    
    @IBAction func ShowLocalRank(_ sender: Any) {
        // play again
        navigationController?.popViewController(animated: true)
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
