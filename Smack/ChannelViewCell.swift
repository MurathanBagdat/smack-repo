//
//  ChannelViewCell.swift
//  Smack
//
//  Created by Melisa Kısacık on 21.08.2017.
//  Copyright © 2017 MurathanBagdat. All rights reserved.
//

import UIKit

class ChannelViewCell: UITableViewCell {
    
    
    //Outlets
    @IBOutlet weak var channelTitle: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected{
            self.layer.backgroundColor = UIColor(white: 1, alpha: 0.2).cgColor
        }else{
            self.layer.backgroundColor = UIColor.clear.cgColor
        }
    }
    
    func configureCell(channel : Channel){
        if let title = channel.channelTitle{
            channelTitle.text = "#\(title)"
        }
        
        channelTitle.font = UIFont(name: "HelveticaNeue-Regular", size: 17)
        
        for id in MessagesService.instance.unreadChannels{
            
            if id == channel.id {
                channelTitle.font = UIFont(name: "HelveticaNeue-Bold", size: 22)
            }
        }
    }
    
}










