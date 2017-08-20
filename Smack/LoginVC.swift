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

    override func viewDidLoad() {
        super.viewDidLoad()

         updateUI()
    }
    
    func updateUI(){
        
        
        
    }
    //Actions
    @IBAction func closeBtnPrsd(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func loginButtonPrsd(_ sender: UIButton) {
    }
    
    @IBAction func createAccountButtonPrsd(_ sender: UIButton) {
        performSegue(withIdentifier: TO_CREATE_ACCOUNT_SEGUE, sender: nil)
    }


    //Keyboard Handling
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
