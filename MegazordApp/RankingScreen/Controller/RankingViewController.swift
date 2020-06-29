//
//  RankingViewController.swift
//  MegazordApp
//
//  Created by Elias Ferreira on 10/06/20.
//  Copyright © 2020 MegazordTeam. All rights reserved.
//

import UIKit

class RankingViewController: UIViewController, ObjectiveDelegate, ObjetiveCellDelegate {
    
    
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!

    @IBAction func addObjectiveTapped(_ sender: Any) {
        print("Clicou!")
        // Instances the new Selection Screen.
        let storyboard = UIStoryboard(name: "AddObjectiveView", bundle: nil)
        let addObjective = storyboard.instantiateViewController(withIdentifier: "AddObjectiveViewController") as! AddObjectiveViewController
        addObjective.delegate = self
        // Shows up the Selection Screen.
        present(addObjective, animated: true, completion: nil)
    }
    
    //let rankingRep = RankingRepository()
    let objectiveRep = ObjectiveRepository()
    var objectiveList = [ObjectiveItem]()
    var rankingList: [RankingItem] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    // Load Some View Configs
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addButton.layer.cornerRadius = addButton.frame.size.width / 2
        self.view.insertSubview(UIView(frame: .zero), at: 0)
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "OpenDyslexicAlta-Bold", size: 34) ?? UIFont.systemFont(ofSize: 34)]
        
        collectionView.delegate = self
        collectionView.dataSource = self
        tableView.delegate = self
        tableView.dataSource = self
        
        collectionView.register(UINib.init(nibName: "ObjetivoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ObjetivoCell")
        tableView.register(UINib.init(nibName: "ClassificacaoTableViewCell", bundle: nil), forCellReuseIdentifier: "ClassificacaoCell")
        
        //objectiveRep.createDefaultItens()
        //objectiveRep.createObjective(title: "Cartas", content: "Ganhar 100 pontos.")
        self.objectiveList = objectiveRep.gelAllObjectives()
        

        RankingRepository.getRanking { (ranking) in
            DispatchQueue.main.async {
               
            self.rankingList = ranking
            self.tableView.reloadData()
        }
       }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        RankingRepository.getRanking { (ranking) in
             DispatchQueue.main.async {
                
             self.rankingList = ranking
             self.tableView.reloadData()
         }
        }
    }
    
    
    
    
    func createNewObjective(title: String, content: String) {
        print("Creating")
        objectiveList = objectiveRep.createObjective(title: title, content: content)
        collectionView.reloadData()
    }
    
    func updateCellStatus(id: Int) {
        objectiveRep.updateObjectiveStatus(id: id)
        objectiveList = objectiveRep.gelAllObjectives()
        collectionView.reloadData()
    }
    func deleteObjective(index: Int) {
        objectiveRep.deleteObjective(index: index)
        objectiveList = objectiveRep.gelAllObjectives()
        collectionView.reloadData()
    }

}

// MARK: - Objetivos

extension RankingViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        objectiveList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ObjetivoCell", for: indexPath) as! ObjetivoCollectionViewCell
        cell.cellDelegate = self
        cell.config(objectiveItem: objectiveList[indexPath.row], id: indexPath.row)
        
        return cell
    }

}

// MARK: - Ranking
extension RankingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        rankingList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ClassificacaoCell", for: indexPath) as! ClassificacaoTableViewCell
        
        cell.config(rankingItem: rankingList[indexPath.row], orderNumber: indexPath.row + 1)
        
        return cell
    }
    
}
