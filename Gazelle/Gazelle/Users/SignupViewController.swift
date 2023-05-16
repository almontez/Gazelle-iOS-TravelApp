//
//  SignupViewController.swift
//  Gazelle
//
//  Created by Dylan Canipe on 4/15/23.
//

import UIKit

class SignupViewController: UIViewController {
    
    
    @IBOutlet weak var fnameField: UITextField!
    @IBOutlet weak var lnameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    var backImageView: UIImageView = {
        let backImageView = UIImageView(frame: .zero)
        backImageView.image = UIImage(named: "bg_image")
        backImageView.contentMode = .scaleAspectFill
        backImageView.translatesAutoresizingMaskIntoConstraints = false
        return backImageView
    }()
    
    
    @IBAction func onSignupTapped(_ sender: Any) {
        guard let username = usernameField.text,
              let email = emailField.text,
              let password = passwordField.text,
              let fname = fnameField.text,
              let lname = lnameField.text,
              !username.isEmpty,
              !fname.isEmpty,
              !lname.isEmpty,
              !email.isEmpty,
              !password.isEmpty else {

            showMissingSignUpFieldsAlert()
            return
        }
        
        var newUser = User()
        newUser.username = username
        newUser.email = email
        newUser.password = password
        newUser.first_name = fname
        newUser.last_name = lname

        newUser.signup { [weak self] result in

            switch result {
            case .success(_):
                // Post a notification that the user has successfully signed up.
                NotificationCenter.default.post(name: Notification.Name("login"), object: nil)

            case .failure(let error):
                // Failed sign up
                self?.showSignUpAlert(description: error.localizedDescription)
            }
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.insertSubview(backImageView, at: 0)
        NSLayoutConstraint.activate([
            backImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
