//
//  TabBarViewController.swift
//  Exam2
//
//  Created by Shubhamsinh Rahevar on 02/03/23.
//

import UIKit
import FirebaseAuth

class TabBarViewController: UITabBarController {
    
    @IBAction func logoutPressed(_ sender: UIButton) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            UserDefaults.standard.removeObject(forKey: "email")
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.hidesBackButton = true
        // Do any additional setup after loading the view.
    }
    

}
