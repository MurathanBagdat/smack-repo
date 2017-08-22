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
    
    
    func establishConnection(){  //app açıldığı yerde çağır app delegate
        socket.connect()
    }
    
    func closeConnection(){
        socket.disconnect()      //app delegate kaparken
    }
    
    
    func addChannel(name :String, description : String , completion : @escaping CompletionHandler){  //appten channel açıldıgına dair bilgi verir servera sıralamalar önemli aşağıdaki api kodundaki sıralamya ve event ismine göre!!
        
        socket.emit("newChannel", name , description)
        completion(true)
        
    }
    
    func getChannel(comletion : @escaping CompletionHandler){
        
        
        // serverdan gelen bilgilere tune olmak için bu func kullanılır
        socket.on("channelCreated") { (dataArray, ack) in
            
            guard let channelName = dataArray[0] as? String else {return}
            guard let channelDescription = dataArray[1] as? String else {return}
            guard let channelId = dataArray[2] as? String else {return}


            let newChannel = Channel(id: channelId, channelTitle: channelName, channelDescription: channelDescription)
            
            MessagesService.instance.channels.append(newChannel)
            comletion(true)
            
        
        
        
        }
        
        
    }
    
    
    
    
    
    
}
