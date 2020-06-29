//
//  CardRhymes.swift
//  MegazordApp
//
//  Created by Jessica Guiot on 19/06/20.
//  Copyright © 2020 MegazordTeam. All rights reserved.
//

import UIKit

struct CardRhymes: Codable {
    
    let id : String
    let term : String
    let image : String?
    let rhymeId : String
    let createdAt : String
    let updatedAt : String
    
    enum CodingKeys : String, CodingKey {
        
        case id
        case term
        case image
        case rhymeId = "rhyme_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
