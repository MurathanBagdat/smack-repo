//
//  MessagesService.swift
//  Smack
//
//  Created by Melisa Kısacık on 21.08.2017.
//  Copyright © 2017 MurathanBagdat. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


class MessagesService {
    
    static let instance = MessagesService()
    
    var channels = [Channel]()
    var selectedChannel : Channel?
    var messages = [Message]()
    
    func findAllChannles(completion : @escaping CompletionHandler) {
        
        Alamofire.request(URL_FINDALLCHANNELS, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: HEADER_BearerOnly).responseJSON { (response) in
            
            if response.result.error == nil{
                
                guard let data = response.data else {return}
                
                if let json = JSON(data : data).array  {
                    
                    for item in json {
                        
                        let name = item["name"].stringValue
                        let id = item["_id"].stringValue
                        let description = item["description"].stringValue
                        
                        let channel = Channel(id: id, channelTitle: name , channelDescription: description)
                        
                        self.channels.append(channel)
        
                    }
                    NotificationCenter.default.post(name: NOTIF_CHANNELS_LOADED, object: nil)
                    completion(true)
                }
                
            }else{
                
                debugPrint(response.result.error as Any)
                completion(false)
            }
            
        }
    }
    
    func removeChannels(){
        channels.removeAll()
    }
    
    
    func getMessagesByChannelId(channelId : String, comletion : @escaping CompletionHandler){
        
        Alamofire.request("\(URL_GET_MESSAGES)\(channelId)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: HEADER_BearerOnly).responseJSON { (response) in
            
            if response.result.error == nil {
                
                guard let data = response.data else {return}
                
                guard let json = JSON(data : data).array else {return}
            
                
                for object in json {
                    
                    let name = object["userName"].stringValue
                    let messageBody = object["messageBody"].stringValue
                    let userAvatar = object["userAvatar"].stringValue
                    let userAvatarColor = object["userAvatarColor"].stringValue
                    let timeStamp = object["timeStamp"].stringValue
                    let id = object["_id"].stringValue
                    let channelId = object["channelId"].stringValue
                    
                    let message = Message(id: id, userName: name, userAvatar: userAvatar, message: messageBody, channelId: channelId, userAvatarColor: userAvatarColor, timeStamp: timeStamp)
                    
                    self.messages.append(message)
        
                }
                
                comletion(true)
                
                
            }else {
                
                debugPrint(response.result.error as Any)
                comletion(false)
            }
            
            
            
        }
        
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
