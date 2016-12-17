//: Playground - noun: a place where people can play

import UIKit


//获取当前时间
let now = Date()

// 创建一个日期格式器
//let dformatter = DateFormatter()
//dformatter.dateFormat = "yyyy年MM月dd日 HH:mm:ss"
//print("当前日期时间：\(dformatter.string(from: now as Date))")

//当前时间的时间戳
//let timeInterval:TimeInterval = now.timeIntervalSince1970
//let timeStamp = Int(timeInterval)
print("当前时间的时间戳：\(now.timeIntervalSince1970)")
print("当前时间的时间戳：\(now.timeIntervalSinceNow)")
print("当前时间的时间戳：\(now.timeIntervalSince1970)")
print("当前时间的时间戳：\(now.timeIntervalSince1970)")

let dformatter = DateFormatter()
dformatter.dateFormat = "yyyy年MM月dd日 HH:mm:ss"
print("当前日期时间：\(dformatter.string(from: now as Date))")
for <#item#> in 0...100 {
    print("当前时间的时间戳：\(now.timeIntervalSince1970 * 100000)")
}

