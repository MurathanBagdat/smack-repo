//
//  CreateChannelVC.swift
//  Smack
//
//  Created by Melisa Kısacık on 21.08.2017.
//  Copyright © 2017 MurathanBagdat. All rights reserved.
//

import UIKit

class CreateChannelVC: UIViewController {
    
    
    //Outlets
    @IBOutlet weak var nameTextLabel: UITextField!
    @IBOutlet weak var descriptionTextLabel: UITextField!
    @IBOutlet weak var bgView: UIView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextLabel.attributedPlaceholder = NSAttributedString(string: "name", attributes: [NSForegroundColorAttributeName : SMACK_PURPLE_PLACEHOLDER])
        descriptionTextLabel.attributedPlaceholder = NSAttributedString(string: "description", attributes: [NSForegroundColorAttributeName : SMACK_PURPLE_PLACEHOLDER])
        
        let tabGesRec = UITapGestureRecognizer(target: self, action: #selector(CreateChannelVC.dissmisTheVC))
        bgView.addGestureRecognizer(tabGesRec)
        
    }
    
    
    func dissmisTheVC(){
        dismiss(animated: true, completion: nil)
    }
    
 
    //Actions
    @IBAction func closeButtonPrsd(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createButtonPrsd(_ sender: UIButton) {
      
        if AuthServices.instance.isLoggedIn {
            guard let name = nameTextLabel.text , nameTextLabel.text != "" else {return}
            guard let description = descriptionTextLabel.text else {return}
            
            SocketService.instance.addChannel(name: name, description: description) { (succes) in
                if succes{
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
        
    }
}
