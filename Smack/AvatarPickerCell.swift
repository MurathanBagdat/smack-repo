//
//  AvatarPickerCell.swift
//  Smack
//
//  Created by Melisa Kısacık on 20.08.2017.
//  Copyright © 2017 MurathanBagdat. All rights reserved.
//

import UIKit

enum AvatarType {
    case dark
    case light
}

class AvatarPickerCell: UICollectionViewCell {
 
    
    @IBOutlet weak var avatarImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    
    func setTheImages(index : Int , avatarType : AvatarType){
        
        if avatarType == .dark{
            avatarImage.image = UIImage(named: "dark\(index)")
            self.backgroundColor = UIColor.lightGray
        }else{
            avatarImage.image = UIImage(named: "light\(index)")
            self.backgroundColor = UIColor.gray
        }
        
    }
    
    
    func setupView(){
        self.layer.backgroundColor = UIColor.lightGray.cgColor
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
    }
    
    
}
