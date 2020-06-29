//
//  ClassificacaoTableViewCell.swift
//  MegazordApp
//
//  Created by Elias Ferreira on 10/06/20.
//  Copyright © 2020 MegazordTeam. All rights reserved.
//

import UIKit

class ClassificacaoTableViewCell: UITableViewCell {

    @IBOutlet weak var classificacaoButton: UIButton!
    
    @IBOutlet weak var cellTitle: UILabel!
    @IBOutlet weak var cellPoints: UILabel!
    @IBOutlet weak var cellOrderNumber: UILabel!
    @IBOutlet weak var cellAvatar: UIImageView! 
    @IBOutlet weak var diamondImageView: UIImageView!

    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cellAvatar.layer.cornerRadius = cellAvatar.frame.width/2
    }

    func config(rankingItem: RankingItem, orderNumber: Int) {
        cellTitle.text = rankingItem.name
        cellAvatar.downloaded(from: rankingItem.avatar ?? "https://i.pinimg.com/564x/4f/d0/78/4fd078381532428226ff2bfcc43aec61.jpg")
        cellPoints.text = "\(rankingItem.points) points"
        cellOrderNumber.text = "\(String(orderNumber))º"
        
        
        if rankingItem.points == 0 {
            
            diamondImageView.tintColor = .mainBlue()
        } else if rankingItem.points < 1000 {
            
            diamondImageView.tintColor = .mainBronze()
        } else if rankingItem.points > 4000 {
            
            diamondImageView.tintColor = .mainYellow()
        } else {
            
            diamondImageView.tintColor = .gray
        }
    }
    
}
