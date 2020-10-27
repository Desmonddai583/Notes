//
//  AppDelegate.swift
//  11-自定义Log
//
//  Created by xiaomage on 16/4/1.
//  Copyright © 2016年 小码哥. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // print("AppDelegate-123")
        XMGLog("123")
        
        return true
    }
}



func XMGLog<T>(messsage : T, file : String = __FILE__, funcName : String = __FUNCTION__, lineNum : Int = __LINE__) {
    
    #if DEBUG
    
    let fileName = (file as NSString).lastPathComponent
    
    print("\(fileName):(\(lineNum))-\(messsage)")
    
    #endif
}