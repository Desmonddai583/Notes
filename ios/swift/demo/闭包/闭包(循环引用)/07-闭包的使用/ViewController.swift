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
        
        /* weakself?.view
        如果前面的可选类型,没有值,后面所有的代码都不会执行
        如果前面的可选类型,有值,系统会自动将weakself进行解包,并且使用weakself
        */
        
        // 解决循环引用的方式一:
        /*
        // 0x0 --> nil
        weak var weakself = self
        tools.loadData { (jsonData) -> () in
            // print("在ViewController拿到数据:\(jsonData)")
            weakself?.view.backgroundColor = UIColor.redColor()
        }
         */
        
        // 解决循环引用的方式二:
        /*
        // unowned
        tools.loadData {[unowned self] (jsonData) -> () in
            // print("在ViewController拿到数据:\(jsonData)")
            self.view.backgroundColor = UIColor.redColor()
        }
         */
        
        // 解决循环引用的方式三: 推荐使用该方式
        tools.loadData {[weak self] (jsonData) -> () in
            // print("在ViewController拿到数据:\(jsonData)")
            self?.view.backgroundColor = UIColor.redColor()
        }
        
        // 尾随闭包:如果闭包作为方法的最后一个参数,那么闭包可以将()省略掉
        // 普通写法
        tools.loadData ({[weak self] (jsonData) -> () in
            // print("在ViewController拿到数据:\(jsonData)")
            self?.view.backgroundColor = UIColor.redColor()
        })
        
        // 尾随闭包的写法一:
        tools.loadData() {[weak self] (jsonData) -> () in
            // print("在ViewController拿到数据:\(jsonData)")
            self?.view.backgroundColor = UIColor.redColor()
        }
        
        // 尾随闭包的写法二:
        tools.loadData {[weak self] (jsonData) -> () in
            // print("在ViewController拿到数据:\(jsonData)")
            self?.view.backgroundColor = UIColor.redColor()
        }
    }
    
    // deinit相当OC中的dealloc方法,当对象销毁时会调用该函数
    deinit {
        print("ViewController -- deinit")
    }
}

