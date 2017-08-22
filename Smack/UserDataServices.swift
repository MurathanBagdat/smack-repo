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
    
    func returnUIColorFromString(component: String) -> UIColor {
        //"[0.5, 0.5, 0.5, 1]"
        
        let scanner = Scanner(string: component)
        let skipped = CharacterSet(charactersIn: "[], ")
        let upToComma = CharacterSet(charactersIn: ",")
        // let upTo = CharacterSet(charactersIn : "]")
        
        scanner.charactersToBeSkipped = skipped
        
        var r, g, b, a : NSString?
        
        scanner.scanUpToCharacters(from: upToComma, into: &r)
        
        scanner.scanUpToCharacters(from: upToComma, into: &g)
        
        scanner.scanUpToCharacters(from: upToComma, into: &b)

        scanner.scanUpToCharacters(from: upToComma , into: &a)
        
        
        
        guard let rUnwrapped = r else {return UIColor.lightGray}
        
        guard let gUnwrapped = g else {return UIColor.lightGray}
        
        guard let bUnwrapped = b else {return UIColor.lightGray}
        
        guard let aUnwrapped = a else {return UIColor.lightGray}
        
        let rCGFloat = CGFloat(rUnwrapped.doubleValue)
        let gCGFloat = CGFloat(gUnwrapped.doubleValue)
        let bCGFloat = CGFloat(bUnwrapped.doubleValue)
        let aCGFloat = CGFloat(aUnwrapped.doubleValue)
        
        let color = UIColor(red: rCGFloat, green: gCGFloat, blue: bCGFloat, alpha: aCGFloat)
        
        return color
        
    }
    
    func logoutUser() {
        self.id = ""
        self.avatarColor = ""
        self.avatarName = ""
        self.email = ""
        self.name = ""
        AuthServices.instance.isLoggedIn = false
        AuthServices.instance.userEmail = ""
        AuthServices.instance.authToken = ""
        MessagesService.instance.removeChannels()
        MessagesService.instance.removeMessages()
        
        
    }
    
    
    
    
    
    
    
    
}
