//
//  ChatVC.swift
//  Smack
//
//  Created by Melisa Kısacık on 18.08.2017.
//  Copyright © 2017 MurathanBagdat. All rights reserved.
//

import UIKit

class ChatVC: UIViewController {
    
    
    // Outlets
    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var channelLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())  //sürükliyerek açmak için
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())  //tap ile kapatmak için
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.userDataDidChanged(_notif:)), name: NOTIF_USER_DATA_DID_CHANGED, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.channelSeleceted(_notif:)), name: NOTIF_CHANNEL_SELECTED, object: nil)
        
        
        if AuthServices.instance.isLoggedIn {
            
            AuthServices.instance.findUserByEmail(completion: { (success) in
                if success{
                
                    NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGED, object: nil)
                }
            })
        }
        
    }
    
    // log in yada log out olduğuna chatVC de yapılacaklar

    func userDataDidChanged(_notif : Notification){
        if AuthServices.instance.isLoggedIn {
            
            onLoginGetMessages()
        }else{
            channelLabel.text = "Please Log In"
        }
    }

    func onLoginGetMessages(){
        
        MessagesService.instance.findAllChannles { (succes) in
            if succes{
                //do stuff with channels
            }
        }
    }
    
    //Channel seçildiğinde yapılacaklar
    func channelSeleceted(_notif : Notification){
        
        updateWithChannel()
    }
    
    func updateWithChannel(){
        
        let channelName = MessagesService.instance.selectedChannel?.channelTitle ?? "Unknown"
        channelLabel.text = "#\(channelName)"
        
    }
  

}
