//
//  ViewController.swift
//  YungNetworkTool
//
//  Created by 2252055382@qq.com on 12/19/2020.
//  Copyright (c) 2020 2252055382@qq.com. All rights reserved.
//

import UIKit
import YungNetworkTool

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let task = DownloadTask(url: "http://dldir1.qq.com/qqfile/QQforMac/QQ_V6.5.2.dmg")
        let directoryURLs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        var filePath:String = ""
        if !directoryURLs.isEmpty {
            filePath =  directoryURLs[0].appendingPathComponent("files").appendingPathComponent(task.fileName).path
        }
        task.destinationURL = URL(fileURLWithPath: filePath)
        task.resume()
        task.startRequestsImmediately = false
        task.progressHandler = { progress in
            print("当前下载进度为: \(String(format: "%.2f", Double(progress.completedUnitCount)/Double(progress.totalUnitCount) * 100))%")
        }
        task.resultHandler = { (data, error) in
            print(data)
            print(error)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

