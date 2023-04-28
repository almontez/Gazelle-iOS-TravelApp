//
//  TripFormController.swift
//  Gazelle
//
//  Created by Angela Li Montez on 4/25/23.
//

import UIKit
import ParseSwift

class TripFormController: UIViewController {

    @IBOutlet weak var tripName: UITextField!
    @IBOutlet weak var tripDescription: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func saveBtnTapped(_ sender: UIButton) {
        if (tripName.text == "") {
            tripNameRequredAlert()
        } else {
            // Create new Trip object
            var newTrip = Trips()
            
            // Set Properties
            newTrip.title = tripName.text
            newTrip.description = tripDescription.text
            newTrip.userId = User.current?.objectId as String?
            
            // Save Trip
            newTrip.save { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(_):
                        print("✅ New Trip Saved!")

                        // Return to previous view controller
                        self?.dismiss(animated: true)
                        
                    case .failure(let error):
                        // Failed sign up
                        self?.showAlert(description: error.localizedDescription)
                    }
                }
            }
        }
    }
    
    private func showAlert(description: String?) {
        let alertController = UIAlertController(title: "Unable to Create Trip", message: description ?? "Unknown error", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(action)
        present(alertController, animated: true)
    }
    
    private func tripNameRequredAlert() {
        let alertController = UIAlertController(title: "Required", message: "The name or title of your trip is required.", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(action)
        present(alertController, animated: true)
    }
}
