//
//  ChannelVC.swift
//  Smack
//
//  Created by Melisa Kısacık on 18.08.2017.
//  Copyright © 2017 MurathanBagdat. All rights reserved.
//

import UIKit

class ChannelVC: UIViewController , UITableViewDelegate, UITableViewDataSource {
    
    
    //Outlets
    @IBOutlet weak var userNameButton: UIButton!
    @IBOutlet weak var userProfileImage: CircleImage!
    @IBOutlet weak var tableView: UITableView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
        self.revealViewController().rearViewRevealWidth = view.frame.size.width - 60 // rear vc nin ne kadar açılacağının ölçüsü
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChannelVC.userDataDidChangde(_:)), name: NOTIF_USER_DATA_DID_CHANGED, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChannelVC.channelsAreLoaded(_notif:)), name: NOTIF_CHANNELS_LOADED, object: nil)
//        let tab = UITapGestureRecognizer(target: self, action: #selector(ChannelVC.dismissTheKeyboard))
//        tableView.addGestureRecognizer(tab)
        
        //Serverdan gelen channel sinyaline bağlı
        SocketService.instance.getChannel { (succes) in
            if succes {
                self.tableView.reloadData()
            }
        }
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
       setupUserInfo()
    }
    
    func channelsAreLoaded(_notif : Notification){
        
        tableView.reloadData()
    }
    
    func userDataDidChangde(_ notif : Notification) {   //log in yada log out oluduğunda channelVCde yapılacaklaklar
        
       setupUserInfo()
        
    }
    
    func setupUserInfo() {
        
        if AuthServices.instance.isLoggedIn {
            
            userNameButton.setTitle(UserDataService.instance.name, for: .normal)
            
            userProfileImage.image = UIImage(named: UserDataService.instance.avatarName)
            
            userProfileImage.backgroundColor = UserDataService.instance.returnUIColorFromString(component: UserDataService.instance.avatarColor)
            
        } else {
            
            userNameButton.setTitle("Login", for: .normal)
            
            userProfileImage.image = UIImage(named: "menuProfileIcon")
            
            userProfileImage.backgroundColor = UIColor.clear
            
            tableView.reloadData()
        }
    }
    
    // ACTIONS
    @IBAction func prepareForUnwind(segue : UIStoryboardSegue){}
    
    @IBAction func loginButtonPrsd(_ sender: UIButton) {
        
        if AuthServices.instance.isLoggedIn {
            
            let profile = ProfileVC()
            profile.modalPresentationStyle = .custom
            profile.modalTransitionStyle = .crossDissolve
            present(profile, animated: true, completion: nil)
            
        }else{
            
        performSegue(withIdentifier: TO_LOGINVC_SEGUE, sender: nil)
            
        }
    }
    @IBAction func addButtonPrsd(_ sender: UIButton) {
        
        if AuthServices.instance.isLoggedIn{
            
        let channelVC = CreateChannelVC()
        channelVC.modalPresentationStyle = .custom
        channelVC.modalTransitionStyle = .crossDissolve
        present(channelVC, animated: true, completion: nil)
            
        }else{
            
            // show an alert!
            
        }
    }

    //TABLEVIEW DATASOURCE CODE!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MessagesService.instance.channels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "channelCell") as? ChannelViewCell{
            
            let channel = MessagesService.instance.channels[indexPath.row]
            cell.configureCell(channel: channel)
            return cell
        }
        return ChannelViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let channel = MessagesService.instance.channels[indexPath.row]
        MessagesService.instance.selectedChannel = channel
        
        NotificationCenter.default.post(name: NOTIF_CHANNEL_SELECTED, object: nil)
        
        UIView.animate(withDuration: 1) {
        
            self.revealViewController().revealToggle(animated: true)

        }
 
        
  }

    //closing Keyboard
//    func dismissTheKeyboard(){
//        self.view.endEditing(true)
//    }

    
}
