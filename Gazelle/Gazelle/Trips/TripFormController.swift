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
    @IBOutlet weak var tripLocation: UITextField!
    @IBOutlet weak var tripStartDate: UIDatePicker!
    @IBOutlet weak var tripEndDate: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeHideKeyboard()
    }
    
    @IBAction func saveBtnTapped(_ sender: UIButton) {
        if (tripName.text == "" || tripLocation.text == "") {
            tripFieldRequredAlert()
        } else {
            // Create new Trip object
            var newTrip = Trip()
            
            // Set Properties
            newTrip.title = tripName.text
            newTrip.description = tripDescription.text
            newTrip.userId = User.current?.objectId as String?
            newTrip.location = tripLocation.text
            newTrip.startDate = formatDate(tripStartDate)
            newTrip.endDate = formatDate(tripEndDate)
            
            // Save Trip
            newTrip.save { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(_):
                        print("✅ New Trip Saved!")

                        // Return to previous view controller
                        self?.dismiss(animated: true)
                        
                    case .failure(let error):
                        // Failed to save new trip
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
    
    private func tripFieldRequredAlert() {
        let alertController = UIAlertController(title: "Required", message: "The the name, location, and dates of your trip are required.", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(action)
        present(alertController, animated: true)
    }
    
    func formatDate(_ date: UIDatePicker) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        let dateString = dateFormatter.string(from: date.date)
        return dateString
    }
}

// citation: https://www.cometchat.com/tutorials/how-to-dismiss-ios-keyboard-swift
extension TripFormController {
    func initializeHideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissMyKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissMyKeyboard(){
        view.endEditing(true)
    }
}
