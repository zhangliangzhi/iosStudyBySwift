//
//  ShopViewController.swift
//  xxcolor
//
//  Created by ZhangLiangZhi on 2017/4/5.
//  Copyright © 2017年 xigk. All rights reserved.
//

import UIKit
import SnapKit

class ShopViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
        
        self.title = NSLocalizedString("Buy Diamond", comment: "")
        
        addDiamonView()
    }
    
    func addDiamonView() -> Void {
        let btn60 = UIButton()
        self.view.addSubview(btn60)
        btn60.addTarget(self, action: #selector(buyDiamond60), for: .touchUpInside)
        
        let btn320 = UIButton()
        self.view.addSubview(btn320)
        btn320.addTarget(self, action: #selector(buyDiamond60), for: .touchUpInside)
        
        let btn3800 = UIButton()
        self.view.addSubview(btn3800)
        btn3800.addTarget(self, action: #selector(buyDiamond60), for: .touchUpInside)
        
        btn60.setTitleColor(UIColor.white, for: .normal)
        btn60.layer.borderColor = UIColor(red: 80/255, green: 183/255, blue: 221/255, alpha: 1).cgColor
        btn60.layer.borderWidth = 1.0
        btn60.backgroundColor = UIColor(red: 233/255, green: 152/255, blue: 0/255, alpha: 1)
        
        btn320.setTitleColor(UIColor.white, for: .normal)
        btn320.layer.borderColor = UIColor(red: 80/255, green: 183/255, blue: 221/255, alpha: 1).cgColor
        btn320.layer.borderWidth = 1.0
        btn320.backgroundColor = UIColor(red: 233/255, green: 152/255, blue: 0/255, alpha: 1)
        
        btn3800.setTitleColor(UIColor.white, for: .normal)
        btn3800.layer.borderColor = UIColor(red: 80/255, green: 183/255, blue: 221/255, alpha: 1).cgColor
        btn3800.layer.borderWidth = 1.0
        btn3800.backgroundColor = UIColor(red: 233/255, green: 152/255, blue: 0/255, alpha: 1)
        
        btn320.snp.makeConstraints { (make) in
            make.width.equalTo(self.view).multipliedBy(0.88)
            make.height.equalTo(self.view).multipliedBy(0.2)
            make.center.equalTo(self.view)
        }
        btn60.snp.makeConstraints { (make) in
            make.bottom.equalTo(btn320.snp.top).offset(-30)
            make.width.equalTo(self.view).multipliedBy(0.88)
            make.height.equalTo(self.view).multipliedBy(0.2)
            make.centerX.equalTo(self.view)
        }
        btn3800.snp.makeConstraints { (make) in
            make.top.equalTo(btn320.snp.bottom).offset(30)
            make.width.equalTo(self.view).multipliedBy(0.88)
            make.height.equalTo(self.view).multipliedBy(0.2)
            make.centerX.equalTo(self.view)
        }
        
        // 钻石的图片
        let img60 = UIImageView(image: UIImage(named: "diamond"))
        btn60.addSubview(img60)
        img60.snp.makeConstraints { (make) in
            make.centerX.equalTo(btn60)
            make.centerY.equalTo(btn60).offset(-10)
        }
        
        // 320钻
        let img320 = UIImageView(image: UIImage(named: "diamond"))
        btn320.addSubview(img320)
        img320.snp.makeConstraints { (make) in
            make.centerX.equalTo(btn320).offset(-25)
            make.centerY.equalTo(btn320).offset(-10)
        }
        let img320b = UIImageView(image: UIImage(named: "diamond"))
        btn320.addSubview(img320b)
        img320b.snp.makeConstraints { (make) in
            make.centerX.equalTo(btn320).offset(25)
            make.centerY.equalTo(btn320).offset(-10)
        }
        
        // 3800钻
        let img3a = UIImageView(image: UIImage(named: "diamond"))
        btn3800.addSubview(img3a)
        img3a.snp.makeConstraints { (make) in
            make.center.equalTo(btn3800).offset(0)
            make.centerY.equalTo(btn3800).offset(-10)
        }
        let img3b = UIImageView(image: UIImage(named: "diamond"))
        btn3800.addSubview(img3b)
        img3b.snp.makeConstraints { (make) in
            make.centerX.equalTo(btn3800).offset(-50)
            make.centerY.equalTo(btn3800).offset(-10)
        }
        let img3c = UIImageView(image: UIImage(named: "diamond"))
        btn3800.addSubview(img3c)
        img3c.snp.makeConstraints { (make) in
            make.centerX.equalTo(btn3800).offset(50)
            make.centerY.equalTo(btn3800).offset(-10)
        }
        
        // 文本
        let lbl60 = UILabel()
        btn60.addSubview(lbl60)
        lbl60.text = NSLocalizedString("money1", comment: "")
        lbl60.textColor = UIColor.white
        lbl60.font = UIFont(name: "Arial-BoldMT", size: 25)
        lbl60.textAlignment = .center //文字中心对齐
        lbl60.snp.makeConstraints { (make) in
            make.centerX.equalTo(btn60)
            make.centerY.equalTo(btn60).offset(25)
        }
        
        let lbl320 = UILabel()
        btn320.addSubview(lbl320)
        lbl320.text = NSLocalizedString("money5", comment: "")
        lbl320.textColor = UIColor.white
        lbl320.font = UIFont(name: "Arial-BoldMT", size: 25)
        lbl320.textAlignment = .center //文字中心对齐
        lbl320.snp.makeConstraints { (make) in
            make.centerX.equalTo(btn320)
            make.centerY.equalTo(btn320).offset(25)
        }
        
        let lbl3800 = UILabel()
        btn3800.addSubview(lbl3800)
        lbl3800.text = NSLocalizedString("money50", comment: "")
        lbl3800.textColor = UIColor.white
        lbl3800.font = UIFont(name: "Arial-BoldMT", size: 25)
        lbl3800.textAlignment = .center //文字中心对齐
        lbl3800.snp.makeConstraints { (make) in
            make.centerX.equalTo(btn3800)
            make.centerY.equalTo(btn3800).offset(25)
        }
        
        // 钻石数量
        let lblnum60 = UILabel()
        btn60.addSubview(lblnum60)
        lblnum60.text = "60"
        lblnum60.textColor = UIColor.white
        lblnum60.font = UIFont(name: "Arial-BoldMT", size: 25)
        lblnum60.textAlignment = .center //文字中心对齐
        lblnum60.snp.makeConstraints { (make) in
            make.right.equalTo(img60.snp.left).offset(-5)
            make.centerY.equalTo(img60)
        }
        
        let lblnum320 = UILabel()
        btn320.addSubview(lblnum320)
        lblnum320.text = "320"
        lblnum320.textColor = UIColor.white
        lblnum320.font = UIFont(name: "Arial-BoldMT", size: 25)
        lblnum320.textAlignment = .center //文字中心对齐
        lblnum320.snp.makeConstraints { (make) in
            make.right.equalTo(img320.snp.left).offset(-5)
            make.centerY.equalTo(img320)
        }
        
        let lblnum3800 = UILabel()
        btn3800.addSubview(lblnum3800)
        lblnum3800.text = "3800"
        lblnum3800.textColor = UIColor.white
        lblnum3800.font = UIFont(name: "Arial-BoldMT", size: 25)
        lblnum3800.textAlignment = .center //文字中心对齐
        lblnum3800.snp.makeConstraints { (make) in
            make.right.equalTo(img3b.snp.left).offset(-5)
            make.centerY.equalTo(img3b)
        }
        
        // 钻石, 在右侧添加一个按钮
        let barButtonItem = UIBarButtonItem(title: "0 "+strzs, style: UIBarButtonItemStyle.plain, target: self, action: #selector(descDiamon))
        self.navigationItem.rightBarButtonItem = barButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let dia = String(format: "%d", (gGlobalSet?.diamon)!) + " "
        self.navigationItem.rightBarButtonItem?.title = dia + strzs
        
    }
    
    func descDiamon() {
        let dia = " " + String(format: "%d", (gGlobalSet?.diamon)!) + " "
        let strShow = NSLocalizedString("You have", comment: "") + dia + strzs
        TipsSwift.showTopWithText(strShow)
    }
    
    func buyDiamond60() {
        
    }
    
    func buyDiamond320() {
        
    }
    
    func buyDiamond380() {
        
    }
}
