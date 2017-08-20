//
//  AvatarPickerVC.swift
//  Smack
//
//  Created by Melisa Kısacık on 20.08.2017.
//  Copyright © 2017 MurathanBagdat. All rights reserved.
//

import UIKit

class AvatarPickerVC: UIViewController , UICollectionViewDelegate,UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {

    //Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var segmentContorller: UISegmentedControl!
  
    //Variables
    var avatarType : AvatarType = .dark
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AVATAR_PICKER_CELL    , for: indexPath) as? AvatarPickerCell {
            
            cell.setTheImages(index: indexPath.item, avatarType: avatarType)
            
            return cell
        }
        
        return AvatarPickerCell()
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 28
    }
    
    
    @IBAction func avatarColorChanged(_ sender: UISegmentedControl) {
        
        if segmentContorller.selectedSegmentIndex == 0{
            avatarType = .dark
            
        }else{
            avatarType = .light
            
        }
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if segmentContorller.selectedSegmentIndex == 0 {
            let selecetedImageName = "dark\(indexPath.item)"
            UserDataService.instance.setAvatarNama(avatarName: selecetedImageName)
            
        } else {
            
            avatarType = .light
            let selecetedImageName = "light\(indexPath.item)"
            UserDataService.instance.setAvatarNama(avatarName: selecetedImageName)
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var numberOfColumn : CGFloat = 3
            
        if UIScreen.main.bounds.width > 320{
            numberOfColumn = 4
        }
        
        let padding : CGFloat = 40
        
        let spaceBetweenCell : CGFloat = 10
        
        let cellDimension = (UIScreen.main.bounds.width - padding - (spaceBetweenCell*numberOfColumn))/numberOfColumn
        
        return CGSize(width: cellDimension, height: cellDimension)
        
    }
    
    
    @IBAction func backButtonPrsd(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

    

}
