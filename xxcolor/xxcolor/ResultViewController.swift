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

        scoreLabel.text = "\(gScore)" + ":" + NSLocalizedString("point", comment: "")
        btnOK.setTitle(NSLocalizedString("OK", comment: ""), for: .normal)
        bntRank.setTitle(NSLocalizedString("Ranking", comment: ""), for: .normal)
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
