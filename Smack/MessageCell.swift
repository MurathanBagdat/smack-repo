//
//  MessageCell.swift
//  Smack
//
//  Created by Melisa Kısacık on 22.08.2017.
//  Copyright © 2017 MurathanBagdat. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {
    
    
    
    //Outlets
    @IBOutlet weak var userAvatarImage: CircleImage!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var timeStampLabel: UILabel!
    @IBOutlet weak var messageBodyLabel: UILabel!
    
    
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func configureCell(message : Message){
        
        userName.text = message.userName
        userAvatarImage.image = UIImage(named: message.userAvatar)
        timeStampLabel.text = message.timeStamp
        messageBodyLabel.text = message.message
        userAvatarImage.backgroundColor = UserDataService.instance.returnUIColorFromString(component: message.userAvatarColor)
        
        
    }

}
