//
//  ViewController.swift
//  07-闭包的使用
//
//  Created by xiaomage on 16/4/1.
//  Copyright © 2016年 小码哥. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var tools : HttpTool = HttpTool()
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        tools.loadData { (jsonData) -> () in
            // print("在ViewController拿到数据:\(jsonData)")
            self.view.backgroundColor = UIColor.redColor()
        }
    }
}

