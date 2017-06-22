//
//  loginViewController.swift
//  YunToDo
//
//  Created by Apple on 2017/6/9.
//  Copyright © 2017年 NJU.EE. All rights reserved.
//

import UIKit

class loginViewController: UIViewController {

    @IBOutlet weak var UserNameTextField: UITextField!
    @IBOutlet weak var PWDTextField: UITextField!
    let serverHelper = ServerHelper()
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        PWDTextField.isSecureTextEntry = true
//        UserNameTextField.delegate = self
//        PWDTextField.delegate = self

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewDidAppear(_ animated: Bool) {
        let global = Global()
        userNameLabel.text = global.getUserName()
        if global.getIfLogIn(){
            self.userNameLabel.text = Global.userName + "，您已登录！"
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
    @IBAction func loginButton(_ sender: Any) {
        serverHelper.validatePassword(username: UserNameTextField.text!, password: PWDTextField.text!) {
            success in
            
            if success {
                print("log in succeed")
                DispatchQueue.main.async {
                    self.alert(title: "登录成功", message: "欢迎使用云任务", succeed: true)
                }
                
                // finish user name, login, tasks & ddls
                let global = Global()
                global.setUserName(name: self.UserNameTextField.text!)
                global.setLogin(login: true)
                global.setTasksdDDLs()
                
                taskMager.tasks.removeAll()
                
                global.setOut(out: true)
                
//                self.userNameLabel.text = Global.userName + "，您已登录！"

            } else {
                DispatchQueue.main.async {
                    self.alert(title: "请重新输入", message: "您的账户或密码输入错误", succeed: false)
                }
            }
        }
    }

    @IBAction func SignUpButton(_ sender: Any) {
        serverHelper.registerNewUser(username: UserNameTextField.text!, password: PWDTextField.text!) {
            success in
            
            if success {
                print("log in succeed")
                DispatchQueue.main.async {
                    self.alert(title: "注册成功", message: "欢迎使用云任务", succeed: true)
                }
                
                // finish user name, login, tasks & ddls
                let global = Global()
                global.setUserName(name: self.UserNameTextField.text!)
                global.setLogin(login: true)
                global.setTasksdDDLs()
                
                taskMager.tasks.removeAll()
                
                global.setOut(out: true)
                
                self.userNameLabel.text = Global.userName + "，您已登录！"
            } else {
                DispatchQueue.main.async {
                    self.alert(title: "注册失败", message: "用户名已被占用", succeed: false)
                }
                
            }
        }
    }
    
    // Alert message
    func alert(title: String, message: String, succeed: Bool){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "好的", style: UIAlertActionStyle.default, handler: {(action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder();
        return true
    }
}
