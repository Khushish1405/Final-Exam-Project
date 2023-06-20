//
//  ViewController.swift
//  Exam2
//
//  Created by Shubhamsinh Rahevar on 22/02/23.
//

import UIKit
import FirebaseCore
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBAction func registerButtonPressed(_ sender: UIButton) {
//        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
//        let destinationVC = mainStoryBoard.instantiateViewController(withIdentifier: "registerViewController") as! RegisterViewController
//        navigationController?.pushViewController(destinationVC, animated: true)
    }
    @IBAction func loginPressed(_ sender: UIButton) {
        
        if let email = emailTextField.text, let password = passwordTextField.text{
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let e = error{
                    print(e.localizedDescription)
                }
                else{
                    let alert = UIAlertController(title: "Login successfully!", message: "", preferredStyle: .alert)
                    let okay = UIAlertAction(title: "Okay", style: .destructive, handler: { action in
                        self.performSegue(withIdentifier: "goToHome", sender: self)
                        UserDefaults.standard.set(email, forKey: "email")
                    })
                    alert.addAction(okay)
                    self.present(alert, animated: true, completion: nil)
                    
                }
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setGradientBackground()
//        emailTextField.layer.cornerRadius = 50
//        loginButton.layer.cornerRadius = 25
    
        setupElements()
        // Do any additional setup after loading the view.
    }
    
    func setupElements(){
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
//        Utilities.styleHollowButton(loginButton)
    }

    
    override func viewWillAppear(_ animated: Bool) {
        if UserDefaults.standard.string(forKey: "email") != nil{
            performSegue(withIdentifier: "goToHome", sender: self)
        }
        
    }
    
    
    func setGradientBackground() {
        let colorTop =  UIColor(red: 0.0/255.0, green: 100/255.0, blue: 150/100, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 0.0/255.0, green: 180/255.0, blue: 255.0/200.0, alpha: 1.0).cgColor
                    
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.view.bounds
                
        self.view.layer.insertSublayer(gradientLayer, at:0)
    }
}

