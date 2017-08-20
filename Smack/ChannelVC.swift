//
//  ChannelVC.swift
//  Smack
//
//  Created by Melisa Kısacık on 18.08.2017.
//  Copyright © 2017 MurathanBagdat. All rights reserved.
//

import UIKit

class ChannelVC: UIViewController {
    
    
    //Outlets
    @IBOutlet weak var userNameButton: UIButton!
    @IBOutlet weak var userProfileImage: CircleImage!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.revealViewController().rearViewRevealWidth = view.frame.size.width - 60 // rear vc nin ne kadar açılacağının ölçüsü
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChannelVC.userDataDidChangde(_:)), name: NOTIF_USER_DATA_DID_CHANGED, object: nil)
    }
    
    func userDataDidChangde(_ notif : Notification){
        
        if AuthServices.instance.isLoggedIn {
            userNameButton.setTitle(UserDataService.instance.name, for: .normal)
            
            userProfileImage.image = UIImage(named: UserDataService.instance.avatarName)
            
            userProfileImage.backgroundColor = UserDataService.instance.returnUIColorFromString(component: UserDataService.instance.avatarColor)
            
            print("çağrıldı1")
            
        }else{
            userNameButton.setTitle("Login", for: .normal)
            userProfileImage.image = UIImage(named: "menuProfileIcon")
            userProfileImage.backgroundColor = UIColor.clear
        }
        
        
    }
    
    
    
    @IBAction func prepareForUnwind(segue : UIStoryboardSegue){}
    
    
    @IBAction func loginButtonPrsd(_ sender: UIButton) {
        performSegue(withIdentifier: TO_LOGINVC_SEGUE, sender: nil)
    }

    
    
    
}
