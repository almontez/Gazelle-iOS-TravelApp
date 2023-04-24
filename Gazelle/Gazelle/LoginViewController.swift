//
//  LoginViewController.swift
//  Gazelle
//
//  Created by Dylan Canipe on 4/15/23.
//

import UIKit
import ParseSwift

class LoginViewController: UIViewController {
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    var backImageView: UIImageView = {
        let backImageView = UIImageView(frame: .zero)
        backImageView.image = UIImage(named: "bg_image")
        backImageView.contentMode = .scaleAspectFill
        backImageView.translatesAutoresizingMaskIntoConstraints = false
        return backImageView
    }()
    
    
    
    @IBAction func onLoginTapped(_ sender: Any) {
        guard let username = usernameField.text,
              let password = passwordField.text,
              !username.isEmpty,
              !password.isEmpty else {

//            showMissingFieldsAlert()
            return
        }
        
        User.login(username: username, password: password){ [weak self] result in
            switch result {
            case .success(let user):
                // Post a notification that the user has successfully logged in.
                NotificationCenter.default.post(name: Notification.Name("login"), object: nil)
                
            case .failure(let error):
                self?.showAlert(description: error.localizedDescription)
            }
            
        }
    }
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        view.insertSubview(backImageView, at: 0)
        NSLayoutConstraint.activate([
            backImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        // Do any additional setup after loading the view.
    }
    

    private func showAlert(description: String?) {
        let alertController = UIAlertController(title: "Unable to Log in", message: description ?? "Unknown error", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(action)
        present(alertController, animated: true)
    }

}
