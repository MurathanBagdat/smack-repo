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
        
        messageBodyLabel.text = message.message
        userAvatarImage.backgroundColor = UserDataService.instance.returnUIColorFromString(component: message.userAvatarColor)
        
        
        guard var isoDate = message.timeStamp else {return}
        
        
        let end = isoDate.index(isoDate.endIndex, offsetBy: -5)
        isoDate = isoDate.substring(to: end)
        
        let isoFormatter = ISO8601DateFormatter()
        let sendDate = isoFormatter.date(from: isoDate.appending("Z"))
        let currentDate = Date().addingTimeInterval(1)
        
        if let userSendDate = sendDate {
            
            var timeOffset = currentDate.offset(from: userSendDate)
            
            if timeOffset.contains("sn"){
                let end = timeOffset.index(timeOffset.endIndex, offsetBy: -2)
                let timeOffSetInt = Int(timeOffset.substring(to: end))
                
                if timeOffSetInt! < 10 {
                    timeOffset = "just now.."
                }
            }
            timeStampLabel.text = timeOffset
        }
        
        
        

        
        
        
        
        
        
        
    }

}
