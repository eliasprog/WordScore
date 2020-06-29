//
//  RankingModel.swift
//  MegazordApp
//
//  Created by Elias Ferreira on 22/06/20.
//  Copyright © 2020 MegazordTeam. All rights reserved.
//

import Foundation

class RankingRepository {
    
    static func getRanking(completion: @escaping ([RankingItem]) -> Void) {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "megazordback.herokuapp.com"
        components.path = "/users/ranking"
        
        guard let url = components.url else {
            completion([])
            return
        }
        
        let session = URLSession(configuration: .default)
        
        let getRankingTask = session.dataTask(with: url) { (data, response, error) in
            if let data = data {
                print(data)
                if let ranking = try? JSONDecoder().decode([RankingItem].self, from: data) {
                    completion(ranking)
                } else {
                    print("Error no decode")
                    completion([])
                }
            }
        }
        
        getRankingTask.resume()
        
    }
}
