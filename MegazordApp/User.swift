//
//  User.swift
//  MegazordApp
//
//  Created by Jessica Guiot on 25/06/20.
//  Copyright © 2020 MegazordTeam. All rights reserved.
//

import Foundation
import UIKit

struct User: Codable {
    
        let id : String
        let name : String
        let email : String
        let avatar : String?
        let nickname : String
        let points : Int
        let createdAt : String
        let updatedAt : String
        
        enum CodingKeys : String, CodingKey {
            
            case id
            case name
            case email
            case avatar
            case nickname
            case points
            case createdAt = "created_at"
            case updatedAt = "updated_at"
        }
}
