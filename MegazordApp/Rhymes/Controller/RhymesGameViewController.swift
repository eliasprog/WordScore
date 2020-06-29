//
//  RhymesGameViewController.swift
//  MegazordApp
//
//  Created by Jessica Guiot on 13/06/20.
//  Copyright © 2020 MegazordTeam. All rights reserved.
//

import UIKit



struct APIBody  {
    
    let numberOfRhymes = 6
    let numberOfWords = 2
}


class RhymesGameViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pointsLabel: UILabel!
    
    
    //MARK: - Attributes
    
    var firstFlipCardIndex:IndexPath?
    var points = 0
    
    let wordsDontRhymeAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
    
    let exitPopUpWindow : PopUpWindow = {
        let view = PopUpWindow()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let endedGamePopWindow: PopUpWindow = {
        let view = PopUpWindow()
        view.translatesAutoresizingMaskIntoConstraints  = false
        return view
    }()
    
    let visualEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .light)
        let view = UIVisualEffectView(effect: blurEffect)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var numberOfCardsSelected = 0
    
    //MARK: - Elements of help view
     
    let helpView : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let closeHelpViewButton : UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        button.tintColor = UIColor(red: 10/255, green: 151/255, blue: 176/255, alpha: 1.0)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let instructionsLabel : UILabel = {
        
        let label                         = UILabel()
        
        label.text                        = "Instruções".uppercased()
        label.font                        = UIFont(name: "OpenDyslexicAlta-Regular", size: 25)
        label.textColor                   = .black
        label.textAlignment               = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
        
    }()
    
    let messageInstructionsLabel : UILabel = {
           
        let label                                       = UILabel()
           
        label.text                                      = "Nesse jogo você vai aprimorar a sua habilidade com as rimas!\n" + "Você ganha pontos quando consegue achar os pares de palavras que rimam.\n" + "Para escutar as palavras basta segurar a carta da palavra que você quer ouvir.\n" + "Boa sorte e bom jogo!"
            
        label.font                                      = UIFont(name: "OpenDyslexicAlta-Regular", size: 16)
        label.textColor                                 = .black
        label.textAlignment                             = .center
        label.numberOfLines                             = 0
        label.translatesAutoresizingMaskIntoConstraints = false
           
        return label
           
    }()
    
    var helpViewCenterYAnchor = NSLayoutConstraint()
    
    let exitButton : UIButton = {
          let button = UIButton()
          button.setTitle("Sair", for: .normal)
          button.setTitleColor(.red, for: .normal)
          button.frame = CGRect(x: -5, y: 125, width: 150, height: 50)
          button.titleLabel?.font = UIFont(name: "OpenDyslexicAlta-Regular", size: 18)
          return button
      }()
    
    
    //MARK: - API Elements
    
    var dataSource = [CardRhymes]()
    var indexPaths : [IndexPath] = []
    var token = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configNavigationBar()
        
        //Delegates
        setCollectionViewDelegates()
        registerRhymesGameCell()
    
        //getting data from API
        getData()
    }
    
    
    //MARK: - IBActions
    
    @IBAction func exitGameButton(_ sender: UIButton) {
        
        configVisualEffectView()
        configPopWindowView()
    }
    
    @IBAction func helpButton(_ sender: UIButton) {
        
        configVisualEffectView()
        configHelpView()
    }
    
    
    //MARK: - Configure Methods
    
    func registerRhymesGameCell() {
        
        collectionView.register(RhymesGameCollectionViewCell.nib(), forCellWithReuseIdentifier: RhymesGameCollectionViewCell.identifier())
    }
    
    func configNavigationBar(){
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func configHelpView() {
        
        view.addSubview(helpView)
        setHelpViewConstraints()
        
        helpView.addSubview(closeHelpViewButton)
        setCloseHelpButtonContraints()
        closeHelpViewButton.addTarget(self, action: #selector(closeHelpView), for: .touchUpInside)
        
        helpView.addSubview(instructionsLabel)
        setInstructionsLabelConstraints()
        
        helpView.addSubview(messageInstructionsLabel)
        setMessageLabelConstraints()
        
        helpView.isHidden = false
    }
    

    func configPopWindowView() {
        
        view.addSubview(exitPopUpWindow)
        exitPopUpWindow.isHidden = false
        exitPopUpWindow.config(title: "Sair do Jogo", message: "Você está saindo do jogo, você tem certeza disso?\n Se sair, perderá todos os pontos!", titleRightButton: "Cancelar")
        setExitPopViewWindowConstraints()
        exitPopUpWindow.exitButton.addTarget(self, action: #selector(exit), for: .touchUpInside)
        exitPopUpWindow.rightButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
    }
    
    func configEndedGamePopViewWindow() {
        
        view.addSubview(endedGamePopWindow)
        endedGamePopWindow.isHidden = false
        endedGamePopWindow.config(title: "Parabéns!!", message: "Você completou todas as rimas.\n Ganhou o jogo!!\n Vai continuar jogando?", titleRightButton: "Jogar de novo")
        setEndedGamePopViewWindowConstraints()
        endedGamePopWindow.exitButton.addTarget(self, action: #selector(exitEndedGame), for: .touchUpInside)
        endedGamePopWindow.rightButton.addTarget(self, action: #selector(continueGame), for: .touchUpInside)
    }
    
    func configVisualEffectView() {
        
        view.addSubview(visualEffectView)
        visualEffectView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive               = true
        visualEffectView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive           = true
        visualEffectView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive             = true
        visualEffectView.topAnchor.constraint(equalTo: view.topAnchor).isActive                 = true
        
        visualEffectView.alpha = 1
    }
    
    
    //MARK: - @objc Methods
    
    @objc func closeHelpView() {
        
        visualEffectView.alpha = 0
        helpView.isHidden = true
    }
    
    @objc func exit() {
        
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.popViewController(animated: true)
        self.exitPopUpWindow.isHidden = true
        
        visualEffectView.alpha = 0
    }
    
    @objc func cancel() {
        
        self.navigationController?.isNavigationBarHidden = true
        self.exitPopUpWindow.isHidden = true
        
        visualEffectView.alpha = 0
    }
    
    //MARK: - Constraints
    
    func setHelpViewConstraints() {
        
        helpView.heightAnchor.constraint(equalToConstant: view.frame.width - 45).isActive                                                       = true
        helpView.widthAnchor.constraint(equalToConstant: view.frame.width - 45).isActive                                                        = true
        helpView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive                                                                 = true
        
        helpViewCenterYAnchor = helpView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0)
        helpViewCenterYAnchor.isActive                                                                                                          = true
    }
    
    func setCloseHelpButtonContraints() {
        
        closeHelpViewButton.heightAnchor.constraint(equalToConstant: 30).isActive                                           = true
        closeHelpViewButton.widthAnchor.constraint(equalToConstant: 30).isActive                                            = true
        closeHelpViewButton.topAnchor.constraint(equalTo: helpView.topAnchor, constant: 12).isActive                        = true
        closeHelpViewButton.trailingAnchor.constraint(equalTo: helpView.trailingAnchor, constant: -10).isActive             = true
    }
    
    func setInstructionsLabelConstraints() {
        
        instructionsLabel.centerXAnchor.constraint(equalTo: helpView.centerXAnchor, constant: 0).isActive                   = true
        instructionsLabel.centerYAnchor.constraint(equalTo: helpView.centerYAnchor, constant: -120).isActive                = true
        instructionsLabel.heightAnchor.constraint(equalToConstant: 30).isActive                                             = true
    }
    
    func setMessageLabelConstraints() {
        
        messageInstructionsLabel.topAnchor.constraint(equalTo: instructionsLabel.bottomAnchor, constant: 5).isActive               = true
        messageInstructionsLabel.leadingAnchor.constraint(equalTo: helpView.leadingAnchor, constant: 5).isActive                   = true
        messageInstructionsLabel.trailingAnchor.constraint(equalTo: helpView.trailingAnchor, constant: -5).isActive                = true
        messageInstructionsLabel.bottomAnchor.constraint(equalTo: helpView.bottomAnchor, constant: 5).isActive                     = true
    }
    
    func setExitPopViewWindowConstraints() {
        
        exitPopUpWindow.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -40).isActive                           = true
        exitPopUpWindow.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive                                          = true
        exitPopUpWindow.heightAnchor.constraint(equalToConstant: view.frame.width - 75).isActive                                = true
        exitPopUpWindow.widthAnchor.constraint(equalToConstant: view.frame.width - 75).isActive                                 = true
    }
   
    func setEndedGamePopViewWindowConstraints() {
        
        endedGamePopWindow.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -40).isActive                           = true
        endedGamePopWindow.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive                                          = true
        endedGamePopWindow.heightAnchor.constraint(equalToConstant: view.frame.width - 75).isActive                                = true
        endedGamePopWindow.widthAnchor.constraint(equalToConstant: view.frame.width - 75).isActive                                 = true
    }
    
}

extension RhymesGameViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func setCollectionViewDelegates() {
        
        collectionView.dataSource       = self
        collectionView.delegate         = self
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return dataSource.count
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        let cardCell = collectionView.dequeueReusableCell(withReuseIdentifier: RhymesGameCollectionViewCell.identifier(), for: indexPath) as! RhymesGameCollectionViewCell
        
        cardCell.config(word: dataSource[indexPath.item])
        
        indexPaths.append(indexPath)
        
        return cardCell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! RhymesGameCollectionViewCell
        
        cell.cardView.backgroundColor = .mainBlue()
        cell.cardLabel.textColor = .white
        cell.cardViewBack.backgroundColor = .mainBlue()
        cell.speechButton.tintColor = .white
    
        
        if firstFlipCardIndex == nil {
            
            firstFlipCardIndex = indexPath
        } else {
            
            checkForMatches(indexPath)
        }
    
    }
    
    
    func deselectedCard(_ card: RhymesGameCollectionViewCell) {
        
        card.cardView.backgroundColor = .mainYellow()
        card.cardLabel.textColor = .black
        
        card.cardViewBack.backgroundColor = .mainYellow()
        card.speechButton.tintColor = .black
    }
    
    func checkForMatches(_ secondFlippedCardIndex: IndexPath){
        
        let cardOne = collectionView.cellForItem(at: firstFlipCardIndex!) as? RhymesGameCollectionViewCell
        let cardTwo = collectionView.cellForItem(at: secondFlippedCardIndex) as? RhymesGameCollectionViewCell
        
        if cardOne?.cardLabel.text == cardTwo?.cardLabel.text {
            
            deselectedCard(cardOne!)
            deselectedCard(cardTwo!)
            firstFlipCardIndex = nil
            
        } else {
            if cardOne?.idCard == cardTwo?.idCard {
                
                points += 50
                pointsLabel.text = "\(points) pontos"
                
                cardOne?.isUserInteractionEnabled = false
                cardTwo?.isUserInteractionEnabled = false
            
            
                
                //counting the number of cards selected
                numberOfCardsSelected += 2
                
               
                
            } else {
                createErrorMessage()
                
                deselectedCard(cardOne!)
                deselectedCard(cardTwo!)
                
                dismissAlert()
            }
            
            firstFlipCardIndex = nil
            
            checkGameEnded()
            
        }
        
    }
    
    func checkGameEnded() {
        
        if numberOfCardsSelected == dataSource.count {
            
            configVisualEffectView()
            configEndedGamePopViewWindow()
            numberOfCardsSelected = 0
        }
    }
    
    
    @objc func exitEndedGame() {
        
        visualEffectView.alpha = 0
        
        let pointsScored  =  self.pointsLabel?.text?.split(separator: " ")
                        
        let points = pointsScored?.first
        
        guard let number = Int(String(points ?? "0")) else {return}
            
        self.savePointsScored(number)
            
        self.getData()
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.popViewController(animated: true)
        endedGamePopWindow.isHidden = true
    }
    
    
    @objc func continueGame() {
        
        visualEffectView.alpha = 0
        
        self.dataSource.removeAll()
        self.pointsLabel.text = "0 pontos"
        
        for index in self.indexPaths {
            let cell = self.collectionView.cellForItem(at: index) as? RhymesGameCollectionViewCell
            self.deselectedCard(cell!)
            cell?.isUserInteractionEnabled = true
        }
        
        self.getData()
        endedGamePopWindow.isHidden = true
    }
    

    func createErrorMessage() {
        
        wordsDontRhymeAlertController.title = "Tente novamente".uppercased()
    
        
        let attributedString = NSMutableAttributedString(string: wordsDontRhymeAlertController.title ?? "")
        
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range:  NSRange(location: 0, length: wordsDontRhymeAlertController.title?.count ?? 0))
        attributedString.addAttributes([NSAttributedString.Key.font: UIFont(name: "OpenDyslexicAlta-Regular", size: 20)!], range: NSRange(location: 0, length: wordsDontRhymeAlertController.title?.count ?? 0))
        
        wordsDontRhymeAlertController.setValue(attributedString, forKey: "attributedTitle")
        
        self.present(wordsDontRhymeAlertController, animated: true)
    }
    
    func dismissAlert() {
        UIView.animate(withDuration: 100.0, delay: 1.0, options: .curveEaseIn, animations: {

        }) { (completed) in
            self.dismiss(animated: false, completion: nil)
        }
    }
    
}

extension UIAlertController {
    
    func setTitlet(font: UIFont?) {
        
        guard let title = self.title else { return }
        
        let attributedString = NSMutableAttributedString(string: title)
        
        if let titleFont = font {
            attributedString.addAttributes([NSAttributedString.Key.font: titleFont], range: NSRange(location: 0, length: title.count))
        }
        
        self.setValue(attributedString, forKey: "attributedTitle")
    }
    
    func setMessage(font: UIFont?) {
        
        guard let message = self.message else { return }
        
        let attributedString = NSMutableAttributedString(string: message)
        
        if let messageFont = font {
            attributedString.addAttributes([NSAttributedString.Key.font: messageFont], range: NSRange(location: 0, length: message.count))
        }
        
        self.setValue(attributedString, forKey: "attributedMessage")
    }
}


extension  RhymesGameViewController {
    
    func getData(){
        
        //create URL
        let url = URL(string: "https://megazordback.herokuapp.com/game/rhyme")!
        
        //create URLRequest
        
        var request = URLRequest(url: url)
        
        //create URLRequest header
        request.allHTTPHeaderFields = [
            "Content-Type": "application/json"
        ]
        
        //create URLRequest body
        
        let jsonObject = [
            "numberOfRhymes" : APIBody().numberOfRhymes,
            "numberOfWords" : APIBody().numberOfWords
        ]
        
        
        do {
            let requestBody = try JSONSerialization.data(withJSONObject: jsonObject, options: .fragmentsAllowed)
            request.httpBody = requestBody
        
            
        }
        catch {
            print("error creating the data object from json")
        }
        
        request.httpMethod = "POST"
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: request, completionHandler: {
            
            (data, response, error) in
            
            guard let data = data, error == nil else {
                print("error getting the data")
                return
            }
            
            var responseAPI: [[CardRhymes]]?
        
            do {
                responseAPI = try JSONDecoder().decode([[CardRhymes]].self, from: data)
                
                
                print(self.dataSource.map({$0.term}))
                
            }
            catch {
                print("failed to convert, \(error.localizedDescription)")
            }
            
            DispatchQueue.main.sync {
                
                responseAPI?.forEach { words in
                    self.dataSource.append(contentsOf: words)
                }
                self.dataSource.shuffle()
                print(self.dataSource.map({$0.term}))
                self.collectionView.reloadData()
            }
           
        })
        
        dataTask.resume()
        
    }
    
    
    func savePointsScored(_ pointsScored: Int) {
        
        //create URL
        let url = URL(string: "https://megazordback.herokuapp.com/users/points")!
        
        //create URLRequest
        
        var request = URLRequest(url: url)
        
        token = UserDefaults.standard.value(forKey: "token") as! String
        
        //create URLRequest header
        request.allHTTPHeaderFields = [
            "Content-Type": "application/json",
        ]
        
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        //create URLRequest body
        
        let jsonObject = [
            "points": pointsScored
        ]
        
        do {
            let requestBody = try JSONSerialization.data(withJSONObject: jsonObject, options: .fragmentsAllowed)
            request.httpBody = requestBody
            
        }
        catch {
            print("error creating the data object from json")
        }
        
        request.httpMethod = "PATCH"
        
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: request, completionHandler: {
            
            (data, response, error) in
            
            guard let data = data, error == nil else {
                print("error getting the data")
                return
            }
            
            var responseAPI: User?
        
            do {
                responseAPI = try JSONDecoder().decode(User.self, from: data)
                print(responseAPI?.name ?? "Não tem nada aqui")
                print(responseAPI?.points ?? 0)
                
            }
            catch {
                print("failed to convert the name, \(error.localizedDescription)")
            }
            
            
           
        })
        
        dataTask.resume()
    }
}

extension Array
{
    /** Randomizes the order of an array's elements. */
    mutating func shuffle()
    {
        for _ in 0..<10
        {
            sort { (_,_) in arc4random() < arc4random() }
        }
    }
}




extension UIColor {
    
    static func mainBlue() -> UIColor {
        return UIColor(red: 10/255, green: 151/255, blue: 176/255, alpha: 1.0)
    }
    
    static func mainYellow() -> UIColor {
           return UIColor(red: 244/255, green: 228/255, blue: 142/255, alpha: 1.0)
    }
    
    static func mainBronze() -> UIColor {
        return UIColor(red: 186/255, green: 143/255, blue: 120/255, alpha: 1.0)
    }
    
}
