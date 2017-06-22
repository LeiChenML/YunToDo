//
//  FirstViewController.swift
//  YunToDo
//
//  Created by Apple on 2017/5/18.
//  Copyright © 2017年 NJU.EE. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tblTasks: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        let global = Global()

        navigationItem.title = global.getUserName() + "的任务表"

        
        if global.getOut() {
            // add todo in first VC
            
            let tasks1 = global.getTasks()
            let ddls1 = global.getDDLs()
            
            for i in 0 ..< tasks1.count {
                taskMager.addTask(name: tasks1[i], info: ddls1[i])
            }
            
            global.setOut(out: false)
        }
        
        tblTasks.reloadData();
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath){
        if(editingStyle == UITableViewCellEditingStyle.delete){

            let global = Global()
            global.removeTasksDDLs(task: taskMager.tasks[indexPath.row].name)
            
            taskMager.tasks.remove(at: indexPath.row)
            
            tblTasks.reloadData();
        }
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskMager.tasks.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "test")
        
        cell.textLabel?.text = taskMager.tasks[indexPath.row].name
        cell.detailTextLabel?.text = taskMager.tasks[indexPath.row].info
        
        return cell
    }
}

