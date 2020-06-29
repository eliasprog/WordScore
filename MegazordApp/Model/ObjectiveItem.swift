//
//  ObjectiveItem.swift
//  MegazordApp
//
//  Created by Elias Ferreira on 22/06/20.
//  Copyright © 2020 MegazordTeam. All rights reserved.
//

import Foundation

struct ObjectiveItem: Codable {
    var title: String
    var content: String
    var isSelected: Bool
    
    init(title: String, content: String) {
        self.title = title
        self.content = content
        self.isSelected = false
    }
}
