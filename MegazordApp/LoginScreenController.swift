//
//  LoginScreenController.swift
//  MegazordApp
//
//  Created by Joseph on 09/06/20.
//  Copyright © 2020 MegazordTeam. All rights reserved.
//

import UIKit

class LoginScreenController: UIViewController {

    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        userTextField?.delegate = self
        passwordTextField?.delegate = self
        
        navigationController?.navigationBar.isHidden = true
        
        configSignUpButton()
    }
    
    func configSignUpButton() {
        
        signUpButton.layer.borderWidth = 4
        signUpButton.layer.borderColor = UIColor(red: 244/255, green: 234/255, blue: 142/255, alpha: 1.0).cgColor
        signUpButton.layer.cornerRadius = 3
    }
    
    
    @IBAction func skipLogin(_ sender: UIButton) {
        
        UserDefaults.standard.set("Username", forKey: "nickname")
        
        let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
        let tabBarViewController = storyboard.instantiateViewController(withIdentifier: "TabBar")
        
        self.present(tabBarViewController, animated: true, completion: nil)
    }
    
    @IBAction func doLogin(_ sender: Any) {
        let user = userTextField.text
        let password = passwordTextField.text
        if user == "" || password == "" {
            let alertController = UIAlertController(title: "Oops", message:
                "Você esqueceu de preencher um dos campos", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Entendi", style: .default))
            self.present(alertController, animated: true, completion: nil)
            
        } else {
            doRequest(user: user!, password: password!, completionHandler: { [weak self] success, code in
                guard let self = self else { return }
                
                if success {
                    DispatchQueue.main.async {
                        let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
                        let tabBarViewController = storyboard.instantiateViewController(withIdentifier: "TabBar")
                        self.present(tabBarViewController, animated: true, completion: nil)
                    }
                    
                } else {
                    
                    DispatchQueue.main.async {
                        var errorMessage = "Ocorreu um erro na requisição!"
                        switch code {
                        case 1:
                            errorMessage = "Data nulo ou Erro ao fazer requisicao"
                            break
                        case 2:
                            errorMessage = "Nao foi possivel fazer o parse do resultado"
                            break
                        default:
                            break
                        }
                        
                        let alertController = UIAlertController(title: "Oops", message:
                            errorMessage, preferredStyle: .alert)
                        alertController.addAction(UIAlertAction(title: "Entendi", style: .default))
                        self.present(alertController, animated: true, completion: nil)
                    }
                }
            })
            
        }
    }
    
    
    @IBAction func signUp(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "RegisterScreen", bundle: nil)
        let registerScreenViewController = storyboard.instantiateViewController(withIdentifier: "RegisterScreen")
        
        registerScreenViewController.modalTransitionStyle = .crossDissolve
        
        
        navigationController?.pushViewController(registerScreenViewController, animated: true)
    }
    

}

extension LoginScreenController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        passwordTextField.resignFirstResponder()
        userTextField.resignFirstResponder()
        return true
    }
}


extension LoginScreenController {
    
    func doRequest(user: String, password: String, completionHandler: @escaping (Bool, Int) -> Void) {
        let url = URL(string: "https://megazordback.herokuapp.com/sessions")!
            
        guard url != nil else {
            print("error creating url object")
            completionHandler(false, 3)
            return
        }
    
        var request = URLRequest(url: url)
        
        request.allHTTPHeaderFields = ["Content-Type": "application/json"]
        
        
        let jsonObject = [
            "email" : user,
            "password" : password,
        ]
        
        do {
            let requestBody = try JSONSerialization.data(withJSONObject: jsonObject, options: .fragmentsAllowed)
            
            request.httpBody = requestBody
        }
        catch {
            print("Error creating the data object from json")
            completionHandler(false, 4)
        }
    
        request.httpMethod = "POST"
        
        getData(from: request, completionHandler: { success, code in
            completionHandler(success, code)
        })
    }
    
    func getData(from url: URLRequest, completionHandler: @escaping (Bool,Int) -> Void) {
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: url, completionHandler: {
            (data, response, error) in
    
            guard let data = data, error == nil else {
                completionHandler(false, 1)
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    print(httpResponse.statusCode)
                    completionHandler(true,0)
                } else {
                    completionHandler(false, 1)
                }
            }
            
            let result : Response
            do {
                result = try JSONDecoder().decode(Response.self, from: data)
                print(result)
                UserDefaults.standard.set(result.token, forKey: "token")
                UserDefaults.standard.set(result.user?.nickname, forKey: "nickname")
                completionHandler(true,0)
              
            }
            catch {
                print("failed to convert \(error), \(error.localizedDescription)")
                completionHandler(false,2)
            }
        })
        dataTask.resume()
    }
}


