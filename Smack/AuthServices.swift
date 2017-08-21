//
//  AuthServices.swift
//  Smack
//
//  Created by Melisa Kısacık on 19.08.2017.
//  Copyright © 2017 MurathanBagdat. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class AuthServices {
    
    static let instance = AuthServices()
    
    let defaults = UserDefaults.standard
    
    var isLoggedIn : Bool {
        get {
            return defaults.bool(forKey: LOGED_IN_KEY)
        }
        set {
            defaults.set(newValue, forKey: LOGED_IN_KEY)
        }
    }
    
    
    var authToken : String {
        get {
            return defaults.value(forKey: TOKEN_Key) as! String
        }
        set{
            defaults.set(newValue, forKey: TOKEN_Key)
        }
    }
    
    
    var userEmail : String {
        get{
            return defaults.value(forKey: USER_EMAIL) as! String
        }
        set{
            defaults.set(newValue, forKey: USER_EMAIL)
        }
    }
    
    
    
    func registerUser (email : String , password : String , completion : @escaping CompletionHandler)  {
        
        let lowercasedEmail = email.lowercased()
        
        let body : [String : Any] = [
            "email" : lowercasedEmail,
            "password" : password
        ]
        
        
        Alamofire.request(URL_REGISTER, method: .post, parameters: body , encoding: JSONEncoding.default , headers: HEADER ).responseString { (response) in
            
            if response.result.error == nil {
                
                completion(true)
                
            }else{
                
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
    
    
    func loginUser(email : String, password : String , completion : @escaping CompletionHandler) {
        
        let lowercasedEmail = email.lowercased()
        
        let body : [String : Any] = [
            "email" : lowercasedEmail,
            "password" : password
        ]
        
        Alamofire.request(URL_LOGIN, method: .post , parameters: body, encoding: JSONEncoding.default, headers: HEADER).responseJSON { (response) in
            if response.result.error == nil {
                
                guard let data = response.data else {return}
                
                let json = JSON(data : data)
                
                self.userEmail = json["user"].stringValue
                self.authToken = json["token"].stringValue
                self.isLoggedIn = true
                
                completion(true)
                
            }else{
                
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
        
    }
    
    func createUser(name : String, email : String , avatarName : String , avatarColor : String , completion : @escaping CompletionHandler){
        
        let body : [String : Any] = [
            "name" : name,
            "email" : email.lowercased(),
            "avatarName" : avatarName,
            "avatarColor" : avatarColor
        ]
        
        Alamofire.request(URL_ADD_USER, method: .post, parameters: body, encoding: JSONEncoding.default, headers: HEADER_Bearer).responseJSON { (response) in
            
            if response.result.error == nil {
                
                guard let data = response.data else {return}
                
                self.setupUserInfo(data: data)
                
                completion(true)
                
            }else{
                
                completion(false)
                print("Failed")
                
            }
        }
        
    }
    
    func findUserByEmail(completion : @escaping CompletionHandler) {
        
        
        Alamofire.request(URL_FIND_USER + userEmail, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: HEADER_BearerOnly ).responseJSON { (response) in
            
            if response.result.error == nil {
    
                guard let data = response.data else {return}
                print(data)
                print(JSON(data: data))
                let json = JSON(data : data)
                print(json)
                
                self.setupUserInfo(data: data)
                
                completion(true)
                
            }else {
                
                completion(false)
                print("Failed FindUserByEmail ")
            }
        }
        
    }
    
    
    func setupUserInfo(data : Data){
        
        let json = JSON(data : data)
        
        let name = json["name"].stringValue
        let email = json["email"].stringValue
        let id = json["_id"].stringValue
        let avatarName = json["avatarName"].stringValue
        let avatarColor = json["avatarColor"].stringValue
        
        UserDataService.instance.setUserData(id: id, color: avatarColor, avatarName: avatarName, email: email, name: name)
        
    }
    
    
    
}









