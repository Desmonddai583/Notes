//
//  ViewController.swift
//  06-AFNetworking的封装
//
//  Created by xiaomage on 16/4/6.
//  Copyright © 2016年 小码哥. All rights reserved.
//

import UIKit

/*
    1> 通过shareInstance拿到的永远是一个实例
    2> 不管三七二十一,永远只要一个实例
 */

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        NetworkTools.shareInstance.request(.GET, urlString: "http://httpbin.org/get", parameters: ["name" : "why"]) { (result, error) -> () in
            if error != nil {
                print(error)
                return
            }
            
            print(result)
        }
    }
}

