//
//  ChatVC.swift
//  Smack
//
//  Created by Melisa Kısacık on 18.08.2017.
//  Copyright © 2017 MurathanBagdat. All rights reserved.
//

import UIKit

class ChatVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    // Outlets
    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var channelLabel: UILabel!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!

    
    //Variables
    
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.view.bindToKeyboard()
        
        menuBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())  //sürükliyerek açmak için
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())  //tap ile kapatmak için
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.userDataDidChanged(_notif:)), name: NOTIF_USER_DATA_DID_CHANGED, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.channelSeleceted(_notif:)), name: NOTIF_CHANNEL_SELECTED, object: nil)
        
        let tab = UITapGestureRecognizer(target: self, action: #selector(ChatVC.dismissTheKeyboard))
        tableView.addGestureRecognizer(tab)
        
        if AuthServices.instance.isLoggedIn {
            
            AuthServices.instance.findUserByEmail(completion: { (success) in
                if success{
                
                    NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGED, object: nil)
                }
            })
        }
        
        SocketService.instance.getMessages { (succes) in
            if succes{
                self.tableView.reloadData()
            }
        }
        
    }

    
    //keyboardKapatma
    func dismissTheKeyboard(){
        self.view.endEditing(true)
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
                
                if MessagesService.instance.channels.count > 0 {
                    
                    MessagesService.instance.selectedChannel = MessagesService.instance.channels[0]
                    
                    self.updateWithChannel()
                    
                }else{
                    
                    self.channelLabel.text = "No Channel Yet"
                }
            }
        }
    }
    
    
    
    //Handling keyboardAndView!!
    
    
    
    //Channel seçildiğinde yapılacaklar
    func channelSeleceted(_notif : Notification) {
        
        updateWithChannel()
    }
    
    func updateWithChannel(){
        
        let channelName = MessagesService.instance.selectedChannel?.channelTitle ?? "Unknown"
        
        channelLabel.text = "#\(channelName)"
        
        getMessagesForSelectedChannel()
    }
    
    func getMessagesForSelectedChannel(){
        
        
        MessagesService.instance.messages.removeAll()
        
        if let selectedChannelId = MessagesService.instance.selectedChannel?.id{
            
            MessagesService.instance.getMessagesByChannelId(channelId: selectedChannelId, comletion: { (succes) in
                if succes{
                    
                    self.tableView.reloadData()
                }
            })
            
        }else{
            // shown an alert
        }
    }
    
  //Actions
    @IBAction func sendButtonPrsd(_ sender: UIButton) {
        
        
        if AuthServices.instance.isLoggedIn{
   
            guard let message = messageTextField.text else {return}
            let userId = UserDataService.instance.id
            guard let selectedChannelId = MessagesService.instance.selectedChannel?.id else {return}
     
            SocketService.instance.addMessage(messageBody: message, userId: userId, channelId: selectedChannelId, completion: { (succes) in
                if succes{
                    messageTextField.text =  ""
                }
            })
        }
    }

    
    //tableView DataSource
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return MessagesService.instance.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "chatCell", for: indexPath) as? MessageCell{
            
            let message = MessagesService.instance.messages[indexPath.row]
            
            cell.configureCell(message: message)
            
            return cell
            
        }
        return MessageCell()
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        
//    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
