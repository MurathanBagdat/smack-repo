//
//  LoginVC.swift
//  Smack
//
//  Created by Melisa Kısacık on 19.08.2017.
//  Copyright © 2017 MurathanBagdat. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {
    
    
    //Outlets
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var spinner: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()

         setUpView()
    }
    
    
    //View
    func setUpView(){
        
        spinner.isHidden = true
        userNameTextField.attributedPlaceholder = NSAttributedString(string: "username", attributes: [NSForegroundColorAttributeName : SMACK_PURPLE_PLACEHOLDER])
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "password", attributes: [NSForegroundColorAttributeName : SMACK_PURPLE_PLACEHOLDER])
        
    }
    

    //Actions
    @IBAction func closeBtnPrsd(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func loginButtonPrsd(_ sender: UIButton) {
        spinner.isHidden = false
        spinner.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        guard let email = userNameTextField.text , userNameTextField.text != "" else {return}
        guard let password = passwordTextField.text , passwordTextField.text != "" else {return}

        AuthServices.instance.loginUser(email:email, password: password) { (success) in
            
            if success {
                
                AuthServices.instance.findUserByEmail(completion: { (success) in
                    
                    if success {
                        
                        self.spinner.isHidden = true
                        self.spinner.stopAnimating()
                        UIApplication.shared.endIgnoringInteractionEvents()
                        
      
                        NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGED, object: nil)
                        self.dismiss(animated: true, completion: nil)
                    }
                })
            }
            
        }
        
    }
    
    @IBAction func createAccountButtonPrsd(_ sender: UIButton) {
        performSegue(withIdentifier: TO_CREATE_ACCOUNT_SEGUE, sender: nil)
    }


    //Keyboard Handling
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
