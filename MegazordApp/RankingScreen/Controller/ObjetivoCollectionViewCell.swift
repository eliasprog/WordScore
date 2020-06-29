//
//  ObjetivoCollectionViewCell.swift
//  MegazordApp
//
//  Created by Elias Ferreira on 10/06/20.
//  Copyright © 2020 MegazordTeam. All rights reserved.
//

import UIKit

protocol ObjetiveCellDelegate {
    func updateCellStatus(id: Int)
    func deleteObjective(index: Int)
}



class ObjetivoCollectionViewCell: UICollectionViewCell {

    
   
    

    @IBOutlet weak var chekButton: UIButton!
    @IBOutlet weak var cellTitle: UILabel!
    @IBOutlet weak var cellContent: UILabel!
  
    
    let selectedImage = UIImage(systemName: "checkmark.circle.fill")
    let unSelectedImage = UIImage(systemName: "circle")
    var id: Int?
    var cellDelegate: ObjetiveCellDelegate?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.layer.cornerRadius = 11
    }

    @IBAction func checkButtonTapped(_ sender: UIButton) {
        
        if let id = self.id {
            cellDelegate?.updateCellStatus(id: id)
        }
    
    }
    
    @IBAction func deleteButton(_ sender: UIButton) {
        
        guard let index  = id else { return }
        cellDelegate?.deleteObjective(index: index)
    }
    
    override func prepareForReuse() {
        self.cellTitle.text = ""
        self.cellContent.text = ""
        self.chekButton.setImage(unSelectedImage, for: UIControl.State.normal)
    }
    
    func config(objectiveItem: ObjectiveItem, id: Int) {
        self.cellTitle.text = objectiveItem.title
        self.cellContent.text = objectiveItem.content
        
        if(objectiveItem.isSelected) {
            chekButton.setImage(selectedImage, for: UIControl.State.normal)
        } else {
            chekButton.setImage(unSelectedImage, for: UIControl.State.normal)
        }
        
        self.id = id
    }
}
