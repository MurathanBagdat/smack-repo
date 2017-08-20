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
    

    
    //Varibles
    
    var avatarName = "profileDefault"   //user kendine avatar şeçmezse default
    var avatarColor = "[0.5 , 0.5, 0.5, 1]"  //lightgray color Jonnhy will explain later
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()

    }
    
    func updateUI(){
        
    }

    
    
    
    // Actions
    @IBAction func closeButtonPrsd(_ sender: UIButton) {
        performSegue(withIdentifier: UNWIND_TO_CHANNEL, sender: nil)
    }
    
    @IBAction func chooseAvatarButtonPrsd(_ sender: UIButton) {
        performSegue(withIdentifier: TO_AVATAR_PICKER, sender: nil)
    }
    
    @IBAction func generateBackgroundColorBtnPrsd(_ sender: UIButton) {
    }
    
    @IBAction func createAccountButtonPrsd(_ sender: UIButton) {
        
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
                                print("user added!")
                                print(UserDataService.instance.name,
                                      UserDataService.instance.avatarName)
                                self.performSegue(withIdentifier: UNWIND_TO_CHANNEL, sender: nil)
                                
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
