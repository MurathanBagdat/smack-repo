//
//  ProfileVC.swift
//  Smack
//
//  Created by Melisa Kısacık on 21.08.2017.
//  Copyright © 2017 MurathanBagdat. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var username: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
    }
    
    func setupView() {
        profileImage.image = UIImage(named: UserDataService.instance.avatarName)
        profileImage.backgroundColor = UserDataService.instance.returnUIColorFromString(component: UserDataService.instance.avatarColor)
        username.text = UserDataService.instance.name
        emailLabel.text = UserDataService.instance.email
        let tabGestureRec = UITapGestureRecognizer(target: self, action: #selector(ProfileVC.dismissTheVC))
        backgroundView.addGestureRecognizer(tabGestureRec)
    }

    
    //Actions
    @IBAction func closeButton(_ sender: UIButton) {
        
        dismiss(animated: true, completion: nil)
        
    }
    @IBAction func logOutButtonPrsd(_ sender: UIButton) {
        
        UserDataService.instance.logoutUser()
        NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGED, object: nil)
        dismiss(animated: true, completion: nil)
    }
    func dismissTheVC(){
        dismiss(animated: true, completion: nil)
    }

}
