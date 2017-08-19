//
//  AuthServices.swift
//  Smack
//
//  Created by Melisa Kısacık on 19.08.2017.
//  Copyright © 2017 MurathanBagdat. All rights reserved.
//

import Foundation
import Alamofire

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
    
    
    var authToken : String{
        get {
            return defaults.value(forKey: TOKEN_Key) as! String
        }
        set{
            defaults.set(newValue, forKey: TOKEN_Key)
        }
    }
    
    
    var userEmail : String{
        get{
            return defaults.value(forKey: USER_EMAIL) as! String
        }
        set{
            defaults.set(newValue, forKey: USER_EMAIL)
        }
    }
    
    
    
    func registerUser (email : String , password : String , completion : @escaping CompletionHandler){
    
        let lowercasedEmail = email.lowercased()
        
        let header = [
            "Content-Type" : "application/json; charset=utf-8"
        ]
        
        let body : [String : Any] = [
            "email" : lowercasedEmail,
            "password" : password
        ]
        
        
        Alamofire.request(URL_REGISTER, method: .post, parameters: body , encoding: JSONEncoding.default , headers: header).responseString { (response) in
            
            if response.result.error == nil {
                
                completion(true)
                
            }else{
                
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
