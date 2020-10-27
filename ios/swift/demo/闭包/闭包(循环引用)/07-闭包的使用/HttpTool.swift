//
//  HttpTool.swift
//  07-闭包的使用
//
//  Created by xiaomage on 16/4/1.
//  Copyright © 2016年 小码哥. All rights reserved.
//

import UIKit

class HttpTool: NSObject {
    
    var callBack : ((jsonData : String) -> ())?
    
    // 闭包的类型: (参数列表) -> (返回值类型)
    func loadData(callBack : (jsonData : String) -> ()) {
        
        self.callBack = callBack
        
        dispatch_async(dispatch_get_global_queue(0, 0)) { () -> Void in
            print("发送网络请求:\(NSThread.currentThread())")
            
            dispatch_sync(dispatch_get_main_queue(), { () -> Void in
                print("获取到数据,并且进行回调:\(NSThread.currentThread())")
                
                callBack(jsonData: "jsonData数据")
            })
        }
    }
}
