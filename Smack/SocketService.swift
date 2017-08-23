//
//  SocketService.swift
//  Smack
//
//  Created by Melisa Kısacık on 21.08.2017.
//  Copyright © 2017 MurathanBagdat. All rights reserved.
//

import Foundation
import SocketIO
import UIKit



class SocketService : NSObject{
    
    static let instance = SocketService()
    
    let socket = SocketIOClient(socketURL: URL(string: BASE_URL)!)
    
    
    override init() {
        super.init()
    }
    
    //app açıldığı yerde çağır app delegate
    func establishConnection(){
        socket.connect()
    }
    
    //app delegate kaparken
    func closeConnection(){
        socket.disconnect()
    }
    
    //appten channel açıldıgına dair bilgi verir servera (sıralamalar önemli aşağıdaki api kodundaki sıralamya ve event ismine göre!!)
    func addChannel(name :String, description : String , completion : @escaping CompletionHandler){
        
        socket.emit("newChannel", name , description)
        completion(true)
        
    }
    
    
    
    // serverdan gelen bilgilere tune olmak için bu func kullanılır
    func getChannel(comletion : @escaping CompletionHandler){
        
        socket.on("channelCreated") { (dataArray, ack) in
            
            guard let channelName = dataArray[0] as? String else {return}
            guard let channelDescription = dataArray[1] as? String else {return}
            guard let channelId = dataArray[2] as? String else {return}
            
            
            let newChannel = Channel(id: channelId, channelTitle: channelName, channelDescription: channelDescription)
            
            MessagesService.instance.channels.append(newChannel)
            comletion(true)
            
        }
    }
    // servere yayın yapar her mesaj gönderildiğinde
    func addMessage(messageBody : String , userId : String , channelId : String , completion : @escaping CompletionHandler){
        
        let user = UserDataService.instance
        
        socket.emit("newMessage", messageBody, userId, channelId , user.name , user.avatarName, user.avatarColor)
        
        completion(true)
        
    }
    // serverdan gelen mesajları dinler
    func getMessages(completion : @escaping CompletionHandler){
        
        socket.on("messageCreated") { (dataArray, ack) in
            
            guard let messageBody = dataArray[0] as? String else {return}
            // guard let userId = dataArray[1] as? String else {return}
            guard let channelId = dataArray[2] as? String else {return}
            guard let userName = dataArray[3] as? String else {return}
            guard let userAvatar = dataArray[4] as? String else {return}
            guard let userAvatarColor = dataArray[5] as? String else {return}
            guard let id = dataArray[6] as? String else {return}
            guard let timeStamp = dataArray[7] as? String else {return}
            
            
            if channelId == MessagesService.instance.selectedChannel?.id  && AuthServices.instance.isLoggedIn {
                
                let newMessage = Message(id: id, userName: userName, userAvatar: userAvatar, message: messageBody, channelId: channelId, userAvatarColor: userAvatarColor, timeStamp: timeStamp)
                MessagesService.instance.messages.append(newMessage)
                completion(true)
                
            }else{
                completion(false)
            }
                
            
            
            
        }
    }
    
    func currenUserIsTyping(channelId : String , completion : @escaping CompletionHandler){
        
        if AuthServices.instance.isLoggedIn{
        
        socket.emit("startType", UserDataService.instance.name , channelId)
            
            completion(true)
        }
    }
    
    func currentUserStopTyping(completion : @escaping CompletionHandler){
        
        if AuthServices.instance.isLoggedIn{
            
            socket.emit("stopType", UserDataService.instance.name)
            completion(true)
        }
    }
    
    func getTypingUser(_ completion : @escaping (_ typingUser : [String:String]) -> Void){
        
        if AuthServices.instance.isLoggedIn {
            
            socket.on("userTypingUpdate", callback: { (dataArray, ack) in
                
                guard let typingUser = dataArray[0] as? [String : String] else {return}
                
                completion(typingUser)
                
                
            })
            
        }
        
        
    }
    

}
    
    
    
    
    
    
    
    
    
    
    
    

