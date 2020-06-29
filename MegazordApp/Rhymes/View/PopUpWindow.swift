//
//  PopUpWindow.swift
//  MegazordApp
//
//  Created by Jessica Guiot on 23/06/20.
//  Copyright © 2020 MegazordTeam. All rights reserved.
//

import UIKit

class PopUpWindow: UIView {

    //MARK: - Properties
    
    let separatorHorizontal : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let separatorVertical : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints             = false
        label.font                                                  = UIFont(name: "OpenDyslexicAlta-Regular", size: 25)
        label.textColor                                             = .white
        label.textAlignment                                         = .center
        return label
    }()
    
    let messageLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints             = false
        label.font                                                  = UIFont(name: "OpenDyslexicAlta-Regular", size: 18)
        label.textColor                                             = .white
        label.textAlignment                                         = .center
        label.numberOfLines                                         = 0
        label.lineBreakMode                                         = .byWordWrapping
        return label
    }()
    
    
    let exitButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sair", for: .normal)
        button.setTitleColor(.mainYellow(), for: .normal)
        button.titleLabel?.font                                     = UIFont(name: "OpenDyslexicAlta-Regular", size: 17)
        button.translatesAutoresizingMaskIntoConstraints            = false
        return button
    }()
    
    let rightButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font                                     = UIFont(name: "OpenDyslexicAlta-Regular", size: 17)
        button.translatesAutoresizingMaskIntoConstraints            = false
        return button
    }()
    
        
    //MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .mainBlue()
        self.layer.cornerRadius = 10
        
        setUpTitleLabelConstraints()
        setUpMessageLabelConstraints()
        setUpExitButtonConstraints()
        setUpCancelButtonConstraints()
        setUpSeparatorConstraints()
        setUpSeparatorVerticalConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func config(title: String, message: String, titleRightButton: String) {
        
        titleLabel.text         = title.uppercased()
        messageLabel.text       = message
        rightButton.setTitle(titleRightButton, for: .normal)
    }

    
    //MARK: - Constraints
    
    func setUpSeparatorConstraints() {
        
        self.addSubview(separatorHorizontal)
        separatorHorizontal.heightAnchor.constraint(equalToConstant: 0.5).isActive                                  = true
        separatorHorizontal.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive                          = true
        separatorHorizontal.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive                        = true
        separatorHorizontal.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 100).isActive           = true
    }
    
    func setUpSeparatorVerticalConstraints() {
        
        self.addSubview(separatorVertical)
        separatorVertical.widthAnchor.constraint(equalToConstant: 0.5).isActive                                = true
        separatorVertical.heightAnchor.constraint(equalToConstant: 50).isActive                                = true
        separatorVertical.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive          = true
        separatorVertical.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 125).isActive        = true
        
    }
    
    
    func setUpTitleLabelConstraints() {
        
        self.addSubview(titleLabel)
        titleLabel.heightAnchor.constraint(equalToConstant: 30).isActive                                = true
        titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -95).isActive        = true
        titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive          = true
    }
    
    func setUpMessageLabelConstraints() {
        
        self.addSubview(messageLabel)
        messageLabel.heightAnchor.constraint(equalToConstant: 150).isActive                               = true
        messageLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive          = true
        messageLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive         = true
        messageLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive      = true
    }
    
    
    func setUpExitButtonConstraints() {
        
        self.addSubview(exitButton)
        exitButton.heightAnchor.constraint(equalToConstant: 50).isActive                                = true
        exitButton.widthAnchor.constraint(equalToConstant: 159).isActive                                = true
        exitButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive            = true
        exitButton.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: -75).isActive        = true
    }
    
    func setUpCancelButtonConstraints() {
        
        self.addSubview(rightButton)
        rightButton.heightAnchor.constraint(equalToConstant: 50).isActive                                = true
        rightButton.widthAnchor.constraint(equalToConstant: 159).isActive                                = true
        rightButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive            = true
        rightButton.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 75).isActive         = true
    }
    
    
}
