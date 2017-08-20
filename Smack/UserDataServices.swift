//
//  UserDataServices.swift
//  Smack
//
//  Created by Melisa Kısacık on 20.08.2017.
//  Copyright © 2017 MurathanBagdat. All rights reserved.
//

import Foundation

class UserDataService {
    static let instance = UserDataService()
    
    
    public private(set) var id = ""
    public private(set) var avatarColor = ""
    public private(set) var avatarName = ""
    public private(set) var email = ""
    public private(set) var name = ""
    
    
    func setUserData(id : String, color : String, avatarName : String, email : String, name: String){
        
        self.id = id
        self.avatarColor = color
        self.avatarName = avatarName
        self.email = email
        self.name = name
        
    }
    
    func setAvatarNama(avatarName : String){
        self.avatarName = avatarName
    }
}
