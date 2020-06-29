//
//  AddObjectiveViewController.swift
//  MegazordApp
//
//  Created by Elias Ferreira on 23/06/20.
//  Copyright © 2020 MegazordTeam. All rights reserved.
//

import UIKit

protocol ObjectiveDelegate {
    func createNewObjective(title: String, content: String)
}

class AddObjectiveViewController: UIViewController {

    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var descriptionField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    var delegate: ObjectiveDelegate!
    
    // Do any additional setup after loading the view.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cancelButton.layer.borderWidth = 4
        cancelButton.layer.borderColor = UIColor(red: 244/255, green: 234/255, blue: 142/255, alpha: 1.0).cgColor
        cancelButton.layer.cornerRadius = 3
        saveButton.layer.cornerRadius = 3

        
    }
    
    // Save
    @IBAction func saveButtonTapped(_ sender: Any) {
        
        if let title = titleField.text {
            if let content = descriptionField.text {
                if(title != "" && content != "") {
                    delegate.createNewObjective(title: title, content: content)
                }
            }
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    // Cancel
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

}
