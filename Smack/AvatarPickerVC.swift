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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AVATAR_PICKER_CELL    , for: indexPath) as? AvatarPickerCell {
            
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
        
    }
    
    @IBAction func backButtonPrsd(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

    

}
