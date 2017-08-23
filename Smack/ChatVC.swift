//
//  ChatVC.swift
//  Smack
//
//  Created by Melisa Kısacık on 18.08.2017.
//  Copyright © 2017 MurathanBagdat. All rights reserved.
//

import UIKit
import UserNotifications


class ChatVC: UIViewController, UITableViewDataSource, UITableViewDelegate , UNUserNotificationCenterDelegate {
    
    
    // Outlets
    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var channelLabel: UILabel!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomLayoutConstraint2: NSLayoutConstraint!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var typingUsersLabel: UILabel!
    @IBOutlet weak var textBoxTralingConstraint: NSLayoutConstraint!
    @IBOutlet weak var tryToConnectView: UIView!
    @IBOutlet weak var tryingToConnectViewTextLabel: UILabel!


    
    //Variables
    var isTyping = false
    var timer = Timer()

   
    override func viewDidLoad() {
        super.viewDidLoad()
        let alertSound = SimpleSound(named: "clockalert")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableViewAutomaticDimension
        
        sendButton.isHidden = true
        textBoxTralingConstraint.constant = 15
        
        tryToConnectView.isHidden = true
        
       
        //keyboardStuff#######
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShowNotification(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHideNotification(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        //keyboardStuff#######
        
        
        
        //LocalNotification##
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.sound]) { (granted, error) in
            // Enable or disable features based on authorization.
        }
        center.delegate = self
        //LocalNotification##
        
        
        
        //SWRevealViewContorller#######
        menuBtn.addTarget(self, action: #selector(ChatVC.dismissTheKeyboard), for: .touchDown)
        menuBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())   //sürükliyerek açmak için
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())    //tap ile kapatmak için
        //SWRevealViewContorller#######
        
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.userDataDidChanged(_notif:)), name: NOTIF_USER_DATA_DID_CHANGED, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.channelSeleceted(_notif:)), name: NOTIF_CHANNEL_SELECTED, object: nil)
        
        
        //DismissingThKeyboard####
        let tab = UITapGestureRecognizer(target: self, action: #selector(ChatVC.dismissTheKeyboard))
        tableView.addGestureRecognizer(tab)
        //let pan = UIPanGestureRecognizer(target: self, action: #selector(ChatVC.dismissTheKeyboard))
        //self.view.addGestureRecognizer(pan)
        //DismissingTheKeyborad####

        
        if AuthServices.instance.isLoggedIn {
            tryToConnectView.isHidden = false
            AuthServices.instance.findUserByEmail(completion: { (success) in
                if success{
                
                    NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGED, object: nil)
                    self.tryToConnectView.isHidden = true
                }
            })
        }else{
            self.channelLabel.text = "Please Log In"
        }
        
        
        //Yazan userı görmek için
        SocketService.instance.getTypingUser { (typingUsers) in
            
            guard let channelId = MessagesService.instance.selectedChannel?.id else {return}
            var names = ""
            var numberOfTypers = 0
            
            for (typingUser , channel) in typingUsers {
                if channelId == channel && typingUser != UserDataService.instance.name {
                    
                    if names == ""{
                    
                        names = typingUser
                    }else{
                        
                        names  = "\(names), \(typingUser)"
                    }
                    
                    numberOfTypers += 1
                }
            }
            if numberOfTypers > 0 && AuthServices.instance.isLoggedIn {
                var verb = "is"
                if numberOfTypers > 1 {
                    verb = "are"
                }
                
                self.typingUsersLabel.text = "\(names) \(verb) typing.."
            }else{
                self.typingUsersLabel.text = ""
            }
        }
        
        //Mesajları almak için
        SocketService.instance.getMessages { (newMessage) in
            
            if AuthServices.instance.isLoggedIn{
                let selectedMessageId = MessagesService.instance.selectedChannel?.id
                
                if selectedMessageId == newMessage.channelId{
                    
                    MessagesService.instance.messages.append(newMessage)
                    alertSound.play()
                    self.tableView.reloadData()
                    self.scrolDownTheTableView()
                }
            }
        }
        
        //starting the timer
        scheduledTimerWithTimeInterval()
    }
    //end################################################################end
    
    //keyboardKapatma
    func dismissTheKeyboard(){
        self.view.endEditing(true)
    }
    
    //#####log in yada log out olduğuna chatVC de yapılacaklar#########
    func userDataDidChanged(_notif : Notification){
        if AuthServices.instance.isLoggedIn {
            
            onLoginGetMessages()
        }else{
            channelLabel.text = "Please Log In"
            tableView.reloadData()
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
    
    //######Channel seçildiğinde yapılacaklar########
    func channelSeleceted(_notif : Notification) {
        
        updateWithChannel()
    }
    
    func updateWithChannel(){
        
        let channelName = MessagesService.instance.selectedChannel?.channelTitle ?? "Unknown"
        
        channelLabel.text = "#\(channelName)"
        
        getMessagesForSelectedChannel()
    }
    
    func getMessagesForSelectedChannel() {
        
        tryToConnectView.isHidden = false
        tryingToConnectViewTextLabel.text = "Messages are coming.."
        
        MessagesService.instance.messages.removeAll()
        
        if let selectedChannelId = MessagesService.instance.selectedChannel?.id{
            
            MessagesService.instance.getMessagesByChannelId(channelId: selectedChannelId, comletion: { (succes) in
                if succes{
                    
                    self.tableView.reloadData()
                    self.scrolDownTheTableView()
                    self.tryToConnectView.isHidden = true        
                }
            })
            
        }else{
            // shown an alert
        }
    }
    
  //ACIONS#############
    @IBAction func sendButtonPrsd(_ sender: UIButton) {
        
        
        if AuthServices.instance.isLoggedIn{
            if messageTextField.text != ""{
                guard let message = messageTextField.text else {return}
                let userId = UserDataService.instance.id
                guard let selectedChannelId = MessagesService.instance.selectedChannel?.id else {return}
                
                SocketService.instance.addMessage(messageBody: message, userId: userId, channelId: selectedChannelId, completion: { (succes) in
                    if succes{
                        
                        SocketService.instance.currentUserStopTyping(completion: { (succes) in
                            if succes{
                                
                            }
                        })
                        self.messageTextField.text =  ""
                    }
                })
            }
        }
    }

    @IBAction func messageBoxEditing(_ sender: UITextField) {
        
        guard let selectedChannelId = MessagesService.instance.selectedChannel?.id else {return}
        
        if messageTextField.text == "" {
            isTyping = false
            UIView.animate(withDuration: 0.3, animations: {
                self.sendButton.isHidden = true
                self.textBoxTralingConstraint.constant = 15
            })
            
            SocketService.instance.currentUserStopTyping(completion: { (succes) in
                if succes{
                    
                }
            })
            
        }else{
            
            if isTyping == true {
                UIView.animate(withDuration: 0.3, animations: {
                    self.sendButton.isHidden = false
                    self.textBoxTralingConstraint.constant = 50
                })
                
                SocketService.instance.currenUserIsTyping(channelId: selectedChannelId , completion: { (succes) in
                    if succes{
                        
                    }
                })
            }
            
            isTyping = true
        }
        
        
    }
    @IBAction func refreshButtonPrsd(_ sender: UIButton) {
        if tryToConnectView.isHidden == false{
            
            if AuthServices.instance.isLoggedIn{
                AuthServices.instance.findUserByEmail(completion: { (success) in
                    if success{
                        
                        NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGED, object: nil)
                        self.tryToConnectView.isHidden = true
                    }
                })
            }else{
                self.channelLabel.text = "Please Log In"
            }
            
        }
        
    }
   
    //tableView DataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
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
   
    
    
    //SCORL DOWN THE KEYBOARD!!####
    func scrolDownTheTableView() {
        if MessagesService.instance.messages.count > 0 {
        let lastRow: Int = self.tableView.numberOfRows(inSection: 0) - 1
        let indexPath = IndexPath(row: lastRow, section: 0);
        self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
        }
    }
    
    
    
    //Handling keyboardAndView!#######
    
    func keyboardWillShowNotification(notification: NSNotification) {
        updateBottomLayoutConstraintWithNotification(notification:notification)
    }
    
    func keyboardWillHideNotification(notification: NSNotification) {
        updateBottomLayoutConstraintWithNotification(notification:notification)
    }
    
    
    func updateBottomLayoutConstraintWithNotification(notification: NSNotification) {
        let userInfo = notification.userInfo!
        
        let animationDuration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        let keyboardEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let convertedKeyboardEndFrame = view.convert(keyboardEndFrame, from: view.window)
        let rawAnimationCurve = (notification.userInfo![UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).uint32Value << 16
        let animationCurve = UIViewAnimationOptions(rawValue: UInt(rawAnimationCurve))
        
        bottomLayoutConstraint2.constant = (view.bounds).maxY - (convertedKeyboardEndFrame).minY
        
        UIView.animate(withDuration: animationDuration, delay: 0.0, options: [.beginFromCurrentState, animationCurve], animations: {
            self.view.layoutIfNeeded()
            self.scrolDownTheTableView()
        }, completion: nil)
    }

    // timer
    func scheduledTimerWithTimeInterval(){
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(ChatVC.reloadDate), userInfo: nil, repeats: true)
        
    }
    func reloadDate(){
        self.tableView.reloadData()
        
    }
    
    //SoundNotification
//    func soundNotification(){
//        let content = UNMutableNotificationContent()
//        content.sound = UNNotificationSound(named: "clockalarm.caf")
//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.3, repeats: false)
//        print("hit")
//        let request = UNNotificationRequest(identifier: "Alert", content: content, trigger: trigger)
//        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
//    }
//    
//    public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Swift.Void){
//        completionHandler([.sound])
//    }
// 
//    
    
    
    


}
