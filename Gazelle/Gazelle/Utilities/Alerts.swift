//
//  Alerts.swift
//  Gazelle
//
//  Created by Angela Li Montez on 5/15/23.
//

import Foundation
import UIKit

extension UIViewController {
    
    func showLoginAlert(description: String?) {
        let alertController = UIAlertController(title: "Unable to Log in", message: description ?? "Unknown error", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(action)
        present(alertController, animated: true)
    }
    
    func showSignUpAlert(description: String?) {
        let alertController = UIAlertController(title: "Unable to Sign Up", message: description ?? "Unknown error", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(action)
        present(alertController, animated: true)
    }

    func showMissingFieldsAlert() {
        let alertController = UIAlertController(title: "Required Fields Missing", message: "All fields marked with an asterisk must be completed.", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(action)
        present(alertController, animated: true)
    }
    
    func showSucessAlert() {
        let alertController = UIAlertController(title: "Success!", message: "Your request has been processed!", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(action)
        present(alertController, animated: true)
    }
    
    func showFailureAlert(description: String?) {
        let alertController = UIAlertController(title: "Failure! Unable to process request", message: description ?? "Unknown error", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(action)
        present(alertController, animated: true)
    }
    
    func displayError(_ error: Error?) {
        guard let error = error as NSError? else { return }
        let alertController = UIAlertController(title: "Oops...", message: error.description, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(action)
        present(alertController, animated: true)
    }
}
