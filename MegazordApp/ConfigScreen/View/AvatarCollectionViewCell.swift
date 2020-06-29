//
//  AvatarCollectionViewCell.swift
//  MegazordApp
//
//  Created by Jessica Guiot on 25/06/20.
//  Copyright © 2020 MegazordTeam. All rights reserved.
//

import UIKit

class AvatarCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var avatarView: UIView!
    @IBOutlet weak var avatarImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        avatarView.layer.borderWidth = 2
        avatarView.layer.borderColor = UIColor.mainBlue().cgColor
        avatarView.layer.cornerRadius = self.frame.width/2
        
        avatarImageView.clipsToBounds = true
        avatarImageView.layer.cornerRadius = self.frame.width/2
    }
    
    func config(urlImage: String) {
        avatarImageView.downloaded(from: urlImage)
    }
    
    static func identifier() -> String {
        return "AvatarCollectionViewCell"
    }
           
    static func nib() -> UINib {
        return UINib(nibName: AvatarCollectionViewCell.identifier(), bundle: nil)
    }

}
