//
//  GradientView.swift
//  Smack
//
//  Created by Melisa Kısacık on 19.08.2017.
//  Copyright © 2017 MurathanBagdat. All rights reserved.
//

import UIKit


@IBDesignable
class GradientView: UIView {

    
    @IBInspectable var topColor : UIColor = #colorLiteral(red: 0.2308072448, green: 0.2386379838, blue: 0.8116227984, alpha: 1){
        didSet{
            self.setNeedsLayout()
        }
    }                                                               // when these functions called
                                                                    // view need to set new layouts
    
    @IBInspectable var bottomColor : UIColor = #colorLiteral(red: 0.3557877243, green: 0.7418265939, blue: 0.8129047751, alpha: 1) {
        didSet{
            self.setNeedsLayout()
        }
    }
    
    
    override func layoutSubviews() {                            // when the color changed and
                                                                // setneedlayouts called this func called
      
        
        let gradientLayer = CAGradientLayer() //gradient layer need (1)colors (2)starting and end point (3) how big going to be
        
        gradientLayer.colors = [topColor.cgColor , bottomColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.frame = self.bounds   
        self.layer.insertSublayer(gradientLayer, at: 0)
    }

    

}
