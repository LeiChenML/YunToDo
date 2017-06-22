//
//  SecondViewController.swift
//  YunToDo
//
//  Created by Apple on 2017/5/18.
//  Copyright © 2017年 NJU.EE. All rights reserved.

import UIKit

class SecondViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var txtTask: UITextField!
    
    @IBOutlet var txtInfo: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func btnAddTask_Click(sender: UIButton){
        taskMager.addTask(name: txtTask.text!, info: txtInfo.text!)
        
        let global = Global()
        global.addTasks(task: txtTask.text!)
        global.addDDL(ddl: txtInfo.text!)
        global.update()
        
        self.view.endEditing(true)
        txtTask.text = ""
        txtInfo.text = ""
        self.tabBarController?.selectedIndex = 0
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder();
        return true
    }
}

