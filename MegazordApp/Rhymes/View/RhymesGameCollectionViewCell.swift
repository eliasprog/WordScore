//
//  RhymesGameCollectionViewCell.swift
//  MegazordApp
//
//  Created by Jessica Guiot on 13/06/20.
//  Copyright © 2020 MegazordTeam. All rights reserved.
//

import UIKit
import AVFoundation


class RhymesGameCollectionViewCell: UICollectionViewCell, AVSpeechSynthesizerDelegate{
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var cardLabel: UILabel!
    @IBOutlet weak var cardImageView: UIImageView!
    
    //MARK: - Card Back Elements
    
    let cardViewBack : UIView = {
        let view = UIView()
        view.backgroundColor =  UIColor(red: 244/255, green: 228/255, blue: 142/255, alpha: 1.0)
        return view
    }()
    
    let speechButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "mic.circle.fill"), for: .normal)
        button.tintColor  = .black
        return button
    }()
    
    
    //MARK: - Attributes
    var showingBack = false
    var idCard    = ""
    let synth = AVSpeechSynthesizer()
    var isMatched = false
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 10
        
        configCardViewBack()
        configGestureRecognizer()
        
        synth.delegate = self
        
    }
    
    //MARK:  -  Configs Methods
    
    func config(word: CardRhymes) {
        
        cardLabel.text          =   word.term.uppercased()
        idCard                  =   word.rhymeId
        
        guard let urlImage = word.image else {return}
        
        cardImageView.downloaded(from: urlImage)
        
    }
    
    func configGestureRecognizer() {
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(flipCardAnimation))
        longPressGesture.minimumPressDuration = 0.5
        self.addGestureRecognizer(longPressGesture)
    }
    
    func configCardViewBack() {
        
        self.addSubview(cardViewBack)
        cardViewBack.isHidden = true
        
        setCardViewBackConstaints()
        configSpeechButton()
    }
    
    func configSpeechButton() {
        cardViewBack.addSubview(speechButton)
        setSpeechButtonConstaints()
        
        speechButton.addTarget(self, action: #selector(textToSpeech), for: .touchUpInside)
    }
    
    //MARK: - @objc Methods
    
    @objc func flipCardAnimation(longPress: UILongPressGestureRecognizer) {
        
        if longPress.state == .ended {
            
            UIView.transition(with: self, duration: 0.7, options: .transitionFlipFromLeft, animations: {
                
                print(self.showingBack)
                if self.showingBack {
                    self.cardViewBack.isHidden = true
                } else {
                    self.cardViewBack.isHidden = false
                }
            }, completion: nil)
            
            showingBack = !showingBack
        }
    }
    
    @objc func textToSpeech() {
        
         do {
               try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, mode: .default, options: .defaultToSpeaker)
               try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
           } catch {
               print("audioSession properties weren't set because of an error.")
           }
        
       
        
        let utterance           = AVSpeechUtterance(string: self.cardLabel!.text ?? "")
        
        utterance.rate          = 0.3
        utterance.voice         = AVSpeechSynthesisVoice(language: "pt-BR")
        utterance.volume        = 1.0
       
        synth.speak(utterance)
        
        
    }
    
    
    //MARK: - Contraints Methods
    
    func setCardViewBackConstaints() {
        
        cardViewBack.translatesAutoresizingMaskIntoConstraints                           = false
        cardViewBack.topAnchor.constraint(equalTo: self.topAnchor).isActive              = true
        cardViewBack.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive    = true
        cardViewBack.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive        = true
        cardViewBack.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive      = true
    }
    
    func setSpeechButtonConstaints() {
        
        speechButton.translatesAutoresizingMaskIntoConstraints                                            = false
        speechButton.centerXAnchor.constraint(equalTo: cardViewBack.centerXAnchor).isActive               = true
        speechButton.centerYAnchor.constraint(equalTo: cardViewBack.centerYAnchor).isActive               = true
        speechButton.heightAnchor.constraint(equalToConstant: 50).isActive                                = true
        speechButton.widthAnchor.constraint(equalToConstant: 50).isActive                                 = true
    }
    
    
    static func identifier() -> String{
           return "RhymesGameCollectionViewCell"
    }
        
    static func nib() -> UINib{
           return UINib(nibName: RhymesGameCollectionViewCell.identifier(), bundle: nil)
    }
    
}

extension UIImageView {
    
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}
