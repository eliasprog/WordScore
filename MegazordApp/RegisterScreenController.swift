
//  RegisterScreenController.swift
//  MegazordApp
//
//  Created by Joseph on 09/06/20.
//  Copyright © 2020 MegazordTeam. All rights reserved.
//

import UIKit

class RegisterScreenController: UIViewController {

    @IBOutlet weak var completeNameTextField: UITextField!
    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        completeNameTextField?.delegate = self
        userTextField?.delegate = self
        passwordTextField?.delegate = self
        emailTextField?.delegate = self
    }

    @IBAction func doRegister(_ sender: Any) {
        let completeName = completeNameTextField.text
        let user = userTextField.text
        let password = passwordTextField.text
        let email = emailTextField.text
        
        if user == "" || password == "" || completeName == "" || email == "" {
            let alertController = UIAlertController(title: "Oops", message:
                "Você esqueceu de preencher um dos campos", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Entendi", style: .default))
            self.present(alertController, animated: true, completion: nil)
            
        } else {
            doRequest(name: completeName!, email: email!, password: password!, nickname: user!, completionHandler: { [weak self] success, code in
                guard let self = self else { return }
                
                if success {
                    DispatchQueue.main.async {
                        let alertController = UIAlertController(title: "Parabéns", message:
                            "Cadastro feito com sucesso!", preferredStyle: .alert)
                        alertController.addAction(UIAlertAction(title: "Ir para o login", style: .default, handler: {
                            (UIAlertAction) in
                        
                            let storyboard = UIStoryboard(name: "LoginScreen", bundle: nil)
                            let loginScreenViewController = storyboard.instantiateViewController(withIdentifier: "LoginScreen")
                            self.present(loginScreenViewController, animated: true, completion: nil)
                        }))
                        
                        self.present(alertController, animated: true, completion: nil)
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
    
}

extension RegisterScreenController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        completeNameTextField.resignFirstResponder()
        userTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        return true
    }
}

extension RegisterScreenController {
    

    func doRequest(name: String, email: String, password: String, nickname: String, completionHandler: @escaping (Bool, Int) -> Void) {
        let url = URL(string: "https://megazordback.herokuapp.com/users")!
            
        guard url != nil else {
            print("error creating url object")
            completionHandler(false,2)
            return
        }
    
        var request = URLRequest(url: url)
        
        request.allHTTPHeaderFields = ["Content-Type": "application/json"]
        
        
        let jsonObject = [
            "name": name,
            "email" : email,
            "password" : password,
            "nickname" : nickname
        ]
        
        do {
            let requestBody = try JSONSerialization.data(withJSONObject: jsonObject, options: .fragmentsAllowed)
            
            request.httpBody = requestBody
        }
        catch {
            print("Error creating the data object from json")
            completionHandler(false,2)
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
                completionHandler(false, 2)
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
            
            let result : User
            
            do {
                result = try JSONDecoder().decode(User.self, from: data)
                print(result)
                completionHandler(true, 0)
              
            }
            catch {
                completionHandler(false, 2)
                print("failed to convert \(error), \(error.localizedDescription)")
            }
        })
        dataTask.resume()
    }
}

