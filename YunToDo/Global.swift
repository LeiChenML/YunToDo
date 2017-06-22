//
//  Global.swift
//  YunToDo
//
//  Created by Apple on 2017/6/7.
//  Copyright © 2017年 NJU.EE. All rights reserved.
//

import Foundation

class Global {
    static var userName = "游客"
    static var ifLogin = false
    static var tasks = [String]()
    static var ddls = [String]()
    static var logout = false
    
    func getUserName() -> String{
        return Global.userName
    }
    
    func getIfLogIn() -> Bool{
        return Global.ifLogin
    }
    
    func getTasks() ->[String] {
        return Global.tasks
    }
    
    func getDDLs() ->[String] {
        return Global.ddls
    }
    
    func getOut() -> Bool {
        return Global.logout
    }
    
    func setOut(out: Bool) {
        Global.logout = out
    }
    
    func setTasksdDDLs() {
        let serverHelper = ServerHelper()
        serverHelper.fetchUserInfoFromMySQL(username: Global.userName, attributeName: "tasks"){
            ret in
            if let tasksinString = ret {
                var tasksSeparated = tasksinString.components(separatedBy: "[t]")
                tasksSeparated.remove(at: tasksSeparated.count - 1)
                tasksSeparated.remove(at: 0)
                Global.tasks = tasksSeparated
            }
        }
        
        serverHelper.fetchUserInfoFromMySQL(username: Global.userName, attributeName: "due"){
            ret in
            if let ddlsinString = ret {
                var ddlSeparated = ddlsinString.components(separatedBy: "[d]")
                ddlSeparated.remove(at: ddlSeparated.count - 1)
                ddlSeparated.remove(at: 0)
                Global.ddls = ddlSeparated
            }
        }
    }
    
    func setUserName(name: String) {
        Global.userName = name
    }
    
    func setLogin(login: Bool) {
        Global.ifLogin = login
    }
    
    func addTasks(task: String) {
        Global.tasks += [task]
    }
    
    func addDDL(ddl: String) {
        Global.ddls += [ddl]
    }

    func update() {
        var str = "[t]"
        for each in Global.tasks {
            str += each + "[t]"
        }
        let serverhelper = ServerHelper()
        serverhelper.updateUserInfoToMySQL(username: Global.userName, attributeName: "tasks", attributeValue: str) {
            success in
        }
        
        str = "[d]"
        for each in Global.ddls {
            str += each + "[d]"
        }
        serverhelper.updateUserInfoToMySQL(username: Global.userName, attributeName: "due", attributeValue: str) {
            success in
        }
    }
    
    func removeTasksDDLs(task: String) {
        
        // remove tasks and ddl in Global
        for i in 0 ..< Global.tasks.count {
            if task == Global.tasks[i] {
                Global.tasks.remove(at: i)
                Global.ddls.remove(at: i)
                break
            }
        }
        
        // remove task and ddl in the server
        update()
    }
}
