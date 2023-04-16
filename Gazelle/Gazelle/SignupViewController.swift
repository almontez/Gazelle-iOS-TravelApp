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

            showMissingFieldsAlert()
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
            case .success(let user):
                // Post a notification that the user has successfully signed up.
                NotificationCenter.default.post(name: Notification.Name("login"), object: nil)

            case .failure(let error):
                // Failed sign up
                self?.showAlert(description: error.localizedDescription)
            }
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    private func showAlert(description: String?) {
        let alertController = UIAlertController(title: "Unable to Sign Up", message: description ?? "Unknown error", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(action)
        present(alertController, animated: true)
    }

    private func showMissingFieldsAlert() {
        let alertController = UIAlertController(title: "Opps...", message: "We need all fields filled out in order to sign you up.", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(action)
        present(alertController, animated: true)
    }

}
