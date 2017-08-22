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
        
        
        if AuthServices.instance.isLoggedIn {
            
            AuthServices.instance.findUserByEmail(completion: { (success) in
                if success{
                
                    NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGED, object: nil)
                }
            })
        }
        
    }
    
    
    func userDataDidChanged(_notif : Notification){   // log in yada log out olduğuna chatVC de yapılacaklar
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
  

}
