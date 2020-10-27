//
//  ViewController.swift
//  11-自定义Log
//
//  Created by xiaomage on 16/4/1.
//  Copyright © 2016年 小码哥. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1.获取打印所在的文件
        let file = (__FILE__ as NSString).lastPathComponent
        
        // 2.获取打印所在的方法
        let funcName = __FUNCTION__
        
        // 3.获取打印所在行数
        let lineNum = __LINE__
        
        // print("\(file):[\(funcName)](\(__LINE__))-123")
        // print("\(file):[\(funcName)](\(__LINE__))-123")
        
        XMGLog("hello swift")
    }
}

