//
//  CreateAccountVC.swift
//  Smack
//
//  Created by Melisa Kısacık on 19.08.2017.
//  Copyright © 2017 MurathanBagdat. All rights reserved.
//

import UIKit


class CreateAccountVC: UIViewController {
    
    
    
    //Outlets
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var createAccountButton: UIButton!
    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    

    
    //Varibles
    
    var avatarName = "profileDefault"   //user kendine avatar şeçmezse default
    var avatarColor = "[0.5, 0.5, 0.5, 1]"  //lightgray color Jonnhy will explain later
    var bgColor : UIColor?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()

    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        if UserDataService.instance.avatarName != "" {
        
            userProfileImage.image = UIImage(named: UserDataService.instance.avatarName)
            
            avatarName = UserDataService.instance.avatarName
            
            if avatarName.contains("light") && bgColor == nil{
                
                self.userProfileImage.backgroundColor = UIColor.lightGray
            }
        }
    }
    
    
    func setupView(){
        
        userNameTextField.attributedPlaceholder = NSAttributedString(string: "username", attributes: [NSForegroundColorAttributeName : SMACK_PURPLE_PLACEHOLDER])
        emailTextField.attributedPlaceholder = NSAttributedString(string: "email", attributes: [NSForegroundColorAttributeName : SMACK_PURPLE_PLACEHOLDER])
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "password", attributes: [NSForegroundColorAttributeName : SMACK_PURPLE_PLACEHOLDER])
        
        spinner.isHidden = true
    }

    // Actions
    @IBAction func closeButtonPrsd(_ sender: UIButton) {
        performSegue(withIdentifier: UNWIND_TO_CHANNEL, sender: nil)
    }
    
    @IBAction func chooseAvatarButtonPrsd(_ sender: UIButton) {
        performSegue(withIdentifier: TO_AVATAR_PICKER, sender: nil)
    }
    
    @IBAction func generateBackgroundColorBtnPrsd(_ sender: UIButton) {
        
        let r  = CGFloat(arc4random_uniform(255)) / 255
        let g  = CGFloat(arc4random_uniform(255)) / 255
        let b  = CGFloat(arc4random_uniform(255)) / 255
        
        avatarColor = "[\(r), \(g), \(b), 1]"
        
        bgColor = UIColor(red: r, green: g, blue: b, alpha: 1)
        
        UIView.animate(withDuration: 0.2){
            self.userProfileImage.backgroundColor = self.bgColor
        }
    }
    
    @IBAction func createAccountButtonPrsd(_ sender: UIButton) {
        
        spinner.isHidden = false
        spinner.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        guard let email = emailTextField.text , emailTextField.text != "" , (emailTextField.text?.contains("@"))! else { return }
        guard let password = passwordTextField.text , passwordTextField.text != "" else {return}
        guard let userName = userNameTextField.text ,userNameTextField.text != "" else {return}
        
        
        AuthServices.instance.registerUser(email: email, password: password) { (success) in
            
            if success{
                
                AuthServices.instance.loginUser(email: email, password: password, completion: { (succes) in
                    
                    if succes {
                        print("user logged in!!")
                        
                        AuthServices.instance.createUser(name: userName, email: email, avatarName: self.avatarName, avatarColor: self.avatarColor, completion: { (succes) in
                            
                            if succes{
                                
                                self.spinner.isHidden = true
                                self.spinner.stopAnimating()
                                UIApplication.shared.endIgnoringInteractionEvents()
                                
                                self.performSegue(withIdentifier: UNWIND_TO_CHANNEL, sender: nil)
                                
                                NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGED, object: nil)
                                
                            }
                        })
                        
                        
                    }
                })
                
            }else{
                
            }
        }

        
    }

    
    // Keyboard Handling
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
