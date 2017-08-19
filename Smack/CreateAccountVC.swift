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
    

    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()

    }
    
    func updateUI(){
        createAccountButton.layer.cornerRadius = 5
    }

    
    
    
    // Actions
    @IBAction func closeButtonPrsd(_ sender: UIButton) {
        performSegue(withIdentifier: UNWIND_TO_CHANNEL, sender: nil)
    }
    
    @IBAction func chooseAvatarButtonPrsd(_ sender: UIButton) {
    }
    
    @IBAction func generateBackgroundColorBtnPrsd(_ sender: UIButton) {
    }
    @IBAction func createAccountButtonPrsd(_ sender: UIButton) {
        
    }

}
