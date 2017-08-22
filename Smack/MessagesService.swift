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
                        
                        NotificationCenter.default.post(name: NOTIF_CHANNELS_LOADED, object: nil)
                    }
                    
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
    
    
    
    
    
}
