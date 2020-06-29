//
//  GamesViewController.swift
//  MegazordApp
//
//  Created by Jessica Guiot on 13/06/20.
//  Copyright © 2020 MegazordTeam. All rights reserved.
//

import UIKit

enum GamesCardsImages: String {
    case rhymes          = "rhymes"
    case syllables       = "syllables"
}


class GamesViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK: - Attributes
    
    let gamesTitles = ["Rhymes", "Syllables"]
    
    let gamesImages = [
        UIImage(named: GamesCardsImages.rhymes.rawValue)!,
        UIImage(named: GamesCardsImages.syllables.rawValue)!
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpNavigationBar()
        
        //Delegates
        setCollectionViewDelegates()
        
    }
    
    func setUpNavigationBar() {
        
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "OpenDyslexicAlta-Regular", size: 40) ?? UIFont.systemFont(ofSize: 40)]
        setUpSearchBar()
    }
    
    
    func setUpSearchBar() {
        
        let search = UISearchController(searchResultsController: nil)
        self.navigationItem.searchController = search
    }
    

}

extension GamesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func setCollectionViewDelegates() {
        collectionView.delegate         = self
        collectionView.dataSource       = self
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let numberOfGamesCards = 2
        return numberOfGamesCards
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let gameCardCell = collectionView.dequeueReusableCell(withReuseIdentifier: "GameCard", for: indexPath) as! CardsGamesCollectionViewCell
        
        gameCardCell.typeOfGame = gamesTitles[indexPath.item]
        gameCardCell.cardsGamesImageView.image = gamesImages[indexPath.item]
        gameCardCell.layer.cornerRadius = 10
        
        
        return gameCardCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cellSelected = collectionView.cellForItem(at: indexPath) as! CardsGamesCollectionViewCell
        
        
        let storyboard = UIStoryboard(name: "RhymesGame", bundle: nil)
        let rhymesViewController = storyboard.instantiateViewController(withIdentifier: "RhymesGame")
        
        if cellSelected.typeOfGame == "Rhymes" {
            navigationController?.pushViewController(rhymesViewController, animated: true)
        } else {
            print("Esse jogo não tá pronto")
        }
        
        
    }
    
}
