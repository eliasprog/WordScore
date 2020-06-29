//
//  ConfigViewController.swift
//  MegazordApp
//
//  Created by Elias Ferreira on 15/06/20.
//  Copyright © 2020 MegazordTeam. All rights reserved.
//

import UIKit



class ConfigViewController: UIViewController {

    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var volumeSlider: UISlider!
    @IBOutlet weak var notifySwitch: UISwitch!
    @IBOutlet weak var userView: UIView!
    @IBOutlet weak var volumeView: UIView!
    @IBOutlet weak var notifyView: UIView!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var avatar: UIImageView!
    
    
    let pickerAvatarView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        return view
    }()
    
    fileprivate let collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.scrollDirection = .horizontal
        cv.translatesAutoresizingMaskIntoConstraints   = false
        cv.register(AvatarCollectionViewCell.nib(), forCellWithReuseIdentifier: AvatarCollectionViewCell.identifier())
        return cv
    }()
    
    let okButton : UIButton = {
        
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Fechar", for: .normal)
        button.titleLabel?.font = UIFont(name: "OpenDyslexicAlta-Regular", size: 16)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .mainBlue()
        button.layer.cornerRadius = 8
        return button
    }()
    
    
    let avatarImages = [
        
        "https://i.pinimg.com/564x/80/da/ea/80daeaf6ff87b18a546dc1bfc3c4686a.jpg",
        "https://i.pinimg.com/564x/80/60/99/806099165aabc67b66cc5566faa3fbd8.jpg",
        "https://i.pinimg.com/564x/33/a3/e8/33a3e8491a7ae101a1a7b4e41f6aa400.jpg",
        "https://i.pinimg.com/564x/76/8c/ac/768cac1db4940be216562468354c5e5f.jpg",
        "https://i.pinimg.com/564x/4f/d0/78/4fd078381532428226ff2bfcc43aec61.jpg"
    ]
    

    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Set the title font
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "OpenDyslexicAlta-Bold", size: 34) ?? UIFont.systemFont(ofSize: 34)]
        //set the border
        userView.layer.borderWidth = 1
        volumeView.layer.borderWidth = 1
        notifyView.layer.borderWidth = 1
        userView.layer.borderColor = UIColor(red:222/255, green:225/255, blue:227/255, alpha: 1).cgColor
        volumeView.layer.borderColor = UIColor(red:222/255, green:225/255, blue:227/255, alpha: 1).cgColor
        notifyView.layer.borderColor = UIColor(red:222/255, green:225/255, blue:227/255, alpha: 1).cgColor
        // put a corner radius on the button
        logoutButton.layer.cornerRadius = 11
        configAvatar()
        
        nicknameLabel.text = UserDefaults.standard.value(forKey: "nickname") as? String
        avatar.downloaded(from: UserDefaults.standard.value(forKey: "avatar") as? String ?? "https://i.pinimg.com/474x/e0/26/d4/e026d468467199ef600f144a7f6d2079.jpg")
    }
    
    func configAvatar() {
        
        avatar.layer.cornerRadius  = avatar.frame.width/2
    }
    
    
    func configPickerAvatarView() {
        
        view.addSubview(pickerAvatarView)
        setPickerViewConstraints()
        pickerAvatarView.layer.borderWidth = 1
        pickerAvatarView.layer.borderColor = UIColor.mainBlue().cgColor
        
        
        pickerAvatarView.addSubview(collectionView)
        collectionView.backgroundColor = .white
        setCollectionViewDelegates()
        setCollectionViewConstraints()
        
        pickerAvatarView.addSubview(okButton)
        okButton.addTarget(self, action: #selector(dismissPickerView), for: .touchUpInside)
        setOkButtonConstraints()
    }
    

    
    func setPickerViewConstraints() {
        
        pickerAvatarView.widthAnchor.constraint(equalToConstant: view.frame.width - 65).isActive    = true
        pickerAvatarView.heightAnchor.constraint(equalToConstant: view.frame.width - 65).isActive   = true
        pickerAvatarView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive             = true
        pickerAvatarView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50).isActive             = true
    }
    
    
    func setCollectionViewConstraints() {
        
        collectionView.topAnchor.constraint(equalTo: pickerAvatarView.topAnchor, constant: 30).isActive                                       = true
        collectionView.trailingAnchor.constraint(equalTo: pickerAvatarView.trailingAnchor).isActive                             = true
        collectionView.heightAnchor.constraint(equalTo: collectionView.widthAnchor, multiplier: 0.5).isActive                   = true
        collectionView.leadingAnchor.constraint(equalTo: pickerAvatarView.leadingAnchor).isActive                               = true
    }
    
    func setOkButtonConstraints() {
        
        okButton.leadingAnchor.constraint(equalTo: pickerAvatarView.leadingAnchor, constant: 20).isActive = true
        okButton.trailingAnchor.constraint(equalTo: pickerAvatarView.trailingAnchor, constant: -20).isActive = true
        okButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        okButton.bottomAnchor.constraint(equalTo: pickerAvatarView.bottomAnchor, constant: -20).isActive = true
    }
    
    @objc func dismissPickerView() {
        
        pickerAvatarView.isHidden = true
    }
    
    
    
    @IBAction func pickerAvatar(_ sender: UIButton) {
        pickerAvatarView.isHidden = false
        configPickerAvatarView()
        
    }
    
    
    
    @IBAction func logoutButtonTapped(_ sender: UIButton) {
        // Action to logout the user
    }
}

extension ConfigViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    func setCollectionViewDelegates() {
        
        collectionView.delegate    = self
        collectionView.dataSource  = self
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return avatarImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AvatarCollectionViewCell.identifier(), for: indexPath) as! AvatarCollectionViewCell
    
        cell.config(urlImage: avatarImages[indexPath.item])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        avatar.downloaded(from: avatarImages[indexPath.item])
        pickerAvatarView.isHidden = true
        saveAvatar(avatarForSave: avatarImages[indexPath.item])
    }
    
}

extension ConfigViewController {
    func saveAvatar(avatarForSave: String) {
        
            let token = UserDefaults.standard.value(forKey: "token") as! String
        
            let urlString = "https://megazordback.herokuapp.com/users/avatar"
        
            //create URL
            let url = URL(string: urlString)!
            
            //create URLRequest
            
            var request = URLRequest(url: url)
            
            //create URLRequest header
            request.allHTTPHeaderFields = [
                "Content-Type": "application/json"
            ]
        
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            
            //create URLRequest body
            
            let jsonObject = [
                "image": avatarForSave
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
            
                do {
                    let response = try JSONDecoder().decode(User.self, from: data)
                     UserDefaults.standard.set(response.avatar, forKey: "avatar")
                    
                }
                catch {
                    print("failed to convert the name, \(error.localizedDescription)")
                }
               
            })
            
            dataTask.resume()
        }
    
}

