//
//  ViewController.swift
//  SwiftXor
//
//  Created by ZhangLiangZhi on 2017/5/3.
//  Copyright © 2017年 xigk. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        test()

        
        testocrand()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    let SKEY:[UInt32] = [888, 23, 1234, 2, 86, 68]
    func test(){
        var buffer = "abcde你\"n.好fg123".unicodeScalars
        var dst = [UInt32]()
        
        var ri:Int = 0
        for ch in buffer {
            let ic = SKEY[ri]
            ri += 1
            if ri >= (SKEY.count-1) {
                ri = 0
            }
            dst.append(ch.value ^ ic)
        }
        
        let home = NSHomeDirectory() as NSString
        let DocumentPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory,FileManager.SearchPathDomainMask.allDomainsMask, true)
        print("沙盒根目录:",home, DocumentPath)
        
        print(dst)
        var orgStr = String.UnicodeScalarView()
        
        // 再做一次进行校验，是否为原字符串
        ri = 0
        for i in 0 ..< dst.count {
            let ic = SKEY[ri]
            ri += 1
            if ri >= (SKEY.count-1) {
                ri = 0
            }
            var value = dst[ i ] ^ ic
            orgStr.append(UnicodeScalar(value)!)
        }
        
        print("Original string: \(orgStr)")
        
        
    }
    
    func testocrand() {
        ocseed(88)
        print(ocrand(),ocrand(),ocrand(),ocrand(),ocrand())
        
        ocseed(86)
        print(ocrand(),ocrand(),ocrand(),ocrand(),ocrand())
        
        ocseed(88)
        print(ocrand(),ocrand(),ocrand(),ocrand(),ocrand())
        
        ocseed(86)
        print(ocrand(),ocrand(),ocrand(),ocrand(),ocrand())
        
        
        let arr = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
        let newArr = arr.sorted { (_, _) -> Bool in
            arc4random() < arc4random()
        }
        print(newArr)
    }
}

