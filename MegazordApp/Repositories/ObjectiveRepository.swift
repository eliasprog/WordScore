//
//  ObjectiveRepository.swift
//  MegazordApp
//
//  Created by Elias Ferreira on 22/06/20.
//  Copyright © 2020 MegazordTeam. All rights reserved.
//

import Foundation



class ObjectiveRepository {
    //Variables
    var objectives = [ObjectiveItem]()
    let fileUrl: URL
    let home = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    init() {
        fileUrl = home.appendingPathComponent("objetivos.json")
        // It creates the file if the same doesn`t exists.
        if (!FileManager.default.fileExists(atPath: fileUrl.path)) {
            do {
                let data = try JSONEncoder().encode([ObjectiveItem]())
                try data.write(to: fileUrl)
            } catch {
                print("Impossível escrever no arquivo.")
            }
        }
    }
    
    func deleteObjective(index: Int) {
    
        
        do {
            let data = try Data(contentsOf: fileUrl)
            objectives = try JSONDecoder().decode([ObjectiveItem].self, from: data)
        }
        catch {
            print(error.localizedDescription)
        }
        
        objectives.remove(at: index)
        self.saveObjectives()
        
    }
    
    
    func createDefaultItens() {
        
        objectives = [
            ObjectiveItem(title: "Rimas", content: "Completar 100 pontos."),
            ObjectiveItem(title: "Rimas", content: "Completar 300 pontos."),
            ObjectiveItem(title: "Silabas", content: "Completar 100 pontos."),
            ObjectiveItem(title: "Silabas", content: "Completar 200 pontos.")
        ]
        
        self.saveObjectives()
    
    }
    
    func createObjective(title: String, content: String) -> [ObjectiveItem] {
        self.objectives = self.gelAllObjectives()
        let objective = ObjectiveItem(title: title, content: content)
        self.objectives.append(objective)
        self.saveObjectives()
        
        return self.gelAllObjectives()
    }
    
    func gelAllObjectives() -> [ObjectiveItem] {
        
        do {
            let data = try Data(contentsOf: fileUrl)
            objectives = try JSONDecoder().decode([ObjectiveItem].self, from: data)
        }
        catch {
            print(error.localizedDescription)
        }
        
        return objectives
        
    }
    
    func updateObjectiveStatus(id: Int) {
        //objectives[id].isSelected = true
        objectives[id].isSelected = !objectives[id].isSelected
        self.saveObjectives()
    }
    
    // function to save objectives.
    func saveObjectives() {
        do {
            let data = try JSONEncoder().encode(self.objectives)
            try data.write(to: fileUrl)
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
}
