//
//  TaskManager.swift
//  YunToDo
//
//  Created by Apple on 2017/5/18.
//  Copyright © 2017年 NJU.EE. All rights reserved.
//

import UIKit

var taskMager: TaskManager = TaskManager()

struct task{
    var name = "Name"
    var info = "info"
}

class TaskManager: NSObject {
    
    var tasks = [task]()
    
    func addTask(name: String, info: String){
        tasks.append(task(name: name, info: info))
    }
    
    func removeAllTask() {
        tasks.removeAll()
    }
}
