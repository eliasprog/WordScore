//
//  Response.swift
//  MegazordApp
//
//  Created by Jessica Guiot on 25/06/20.
//  Copyright © 2020 MegazordTeam. All rights reserved.
//

import Foundation
import UIKit


struct Response: Codable {
    
    let user: User?
    let token: String?
    
    enum CodingKeys : String, CodingKey {

        case user
        case token
    }
}
