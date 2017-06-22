//
//  MySQLOps.swift
//  MinorDianping
//
//  Created by Apple on 2017/6/6.
//  Copyright © 2017年 NJU.EE. All rights reserved.
//

import Foundation

public class ServerHelper{
    let URL_REGISTER_USERS:String = "http://104.199.144.39/YunToDo/registerUser.php"
    let URL_FETCH_USERS:String = "http://104.199.144.39/YunToDo/selectUser.php"
    let URL_UPDATE_USERS:String = "http://104.199.144.39/YunToDo/updateUser.php"
    
    
    func registerNewUser(username: String, password: String, handler: @escaping (_ success: Bool)-> ()){
        var request = URLRequest(url: URL(string: URL_REGISTER_USERS)!)
        request.httpMethod = "POST"
        let postString = "username=\(username)&password=\(password)"
        request.httpBody = postString.data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request){
            data, response, error in
            if error != nil {
                print("error=\(String(describing: error))")
                return
            }
            //print("response = \(String(describing: response))")
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            do{
                let responseJSON = try JSONSerialization.jsonObject(with: data!) as! [String:Any]
                handler(responseJSON["status"]! as! String != "400")
            }
            catch{
                print(error)
            }
            print("REGISTER responseString = \(String(describing: responseString))")
        }
        task.resume();
    }
    
    func fetchUserInfoFromMySQL(username:String, attributeName:String, handler: @escaping (_ attributeValue: String?)-> ()){
        var request = URLRequest(url: URL(string: URL_FETCH_USERS)!)
        request.httpMethod = "POST"
        let getString = "username=\(username)&attributeName=\(attributeName)"
        request.httpBody = getString.data(using: String.Encoding.utf8)
        
        
        let task = URLSession.shared.dataTask(with: request){
            data, response, error in
            //exiting if there is some error
            if error != nil{
                print("error is \(String(describing: error))")
                return;
            }
            
            // parse the response
            do{
                // convert response to NSDictionary
                let userJSON = try JSONSerialization.jsonObject(with: data!) as! [String:Any]
                handler(userJSON[attributeName] as? String)
                
            }catch{
                print(error)
            }
        }
        task.resume()
    }
    
    func updateUserInfoToMySQL(username: String, attributeName: String, attributeValue: String, handler: @escaping (_ success: Bool)-> ()){
        var request = URLRequest(url: URL(string: URL_UPDATE_USERS)!)
        request.httpMethod = "POST"
        let getString = "username=\(username)&attributeName=\(attributeName)&attributeValue=\(attributeValue)"
        request.httpBody = getString.data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request){
            data, response, error in
            
            if error != nil{
                print("error is \(String(describing: error))")
                return;
            }
            
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            do{
                let responseJSON = try JSONSerialization.jsonObject(with: data!) as! [String:Any]
                handler(responseJSON["status"]! as! String != "400")
            }
            catch{
                print(error)
            }
            print("UPDATE responseString = \(String(describing: responseString))")
        }
        task.resume()
    }
    
    public func validatePassword(username: String, password: String, handler: @escaping (_ success: Bool)-> ()){
        let serverHelper = ServerHelper()
        serverHelper.fetchUserInfoFromMySQL(username: username, attributeName: "password"){
            pass in
            let passToString = pass! as NSString
            let subPass = passToString.substring(to: 40)
            let inputPassToSha1 = password.sha1() as NSString
            let subInputPassToSha1 = inputPassToSha1.substring(to: 40)
            
            handler(subPass == subInputPassToSha1)
        }
    }
}

extension String {
    func sha1() -> String {
        let data = self.data(using: String.Encoding.utf8)!
        var digest = [UInt8](repeating: 0, count:Int(CC_SHA1_DIGEST_LENGTH))
        data.withUnsafeBytes {
            _ = CC_SHA1($0, CC_LONG(data.count), &digest)
        }
        //return Data(bytes: digest).base64EncodedString()
        let hexBytes = digest.map { String(format: "%02hhx", $0) }
        return hexBytes.joined()
    }
}
