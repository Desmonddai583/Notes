//
//  ViewController.swift
//  09-懒加载的使用
//
//  Created by xiaomage on 16/4/1.
//  Copyright © 2016年 小码哥. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var names : [String] = {
        
        print("------")
        
        return ["why", "yz", "lmj"]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        _ = names.count
        _ = names.count
        _ = names.count
        _ = names.count
        _ = names.count
        _ = names.count
    }
}

