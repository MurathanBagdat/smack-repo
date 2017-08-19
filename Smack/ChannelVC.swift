//
//  ChannelVC.swift
//  Smack
//
//  Created by Melisa Kısacık on 18.08.2017.
//  Copyright © 2017 MurathanBagdat. All rights reserved.
//

import UIKit

class ChannelVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.revealViewController().rearViewRevealWidth = view.frame.size.width - 60 // rear vc nin ne kadar açılacağının ölçüsü
     
    }
    
    @IBAction func prepareForUnwind(segue : UIStoryboardSegue){}
    
    
    @IBAction func loginButtonPrsd(_ sender: UIButton) {
        performSegue(withIdentifier: TO_LOGINVC_SEGUE, sender: nil)
    }

    
    
    
}
