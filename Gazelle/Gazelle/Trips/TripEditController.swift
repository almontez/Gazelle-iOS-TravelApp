//
//  TripEditController.swift
//  Gazelle
//
//  Created by Angela Li Montez on 5/10/23.
//

import UIKit
import ParseSwift

class TripEditController: UIViewController {

    @IBOutlet weak var tripName: UITextField!
    @IBOutlet weak var tripLocation: UITextField!
    @IBOutlet weak var tripDescription: UITextField!
    @IBOutlet weak var tripStartDate: UIDatePicker!
    @IBOutlet weak var tripEndDate: UIDatePicker!
    
    var tripId: String?
    private var foundTrip = Trip()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeHideKeyboard()
        findSpecificTrip(id: tripId!)
    }
    
    private func findSpecificTrip(id tripId: String) {
        let query = Trip.query("objectId" == "\(tripId)")
        
        query.find { [weak self] result in
            switch result {
            case .success(let foundTrip):
                print("✅ Specific Trip Found")
                self?.foundTrip = foundTrip[0]
                self?.fillInputFields()
            case .failure(let error):
                self?.showQueryAlert(description: error.localizedDescription)
            }
        }
    }
    
    @IBAction func updateBtnTapped(_ sender: UIButton) {
        if (tripName.text == "" || tripLocation.text == "") {
            tripFieldRequredAlert()
        } else {
            performSegue(withIdentifier: "unwindToUpdatedTrips", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let TripsViewController = segue.destination as? TripsViewController {
            // Create new Trip object
            var updatedTrip = Trip()
            
            // Set Properties
            updatedTrip.title = tripName.text
            updatedTrip.description = tripDescription.text
            updatedTrip.userId = User.current?.objectId as String?
            updatedTrip.location = tripLocation.text
            updatedTrip.startDate = formatNewDate(tripStartDate)
            updatedTrip.endDate = formatNewDate(tripEndDate)
            
            TripsViewController.updatedTrip = updatedTrip
            TripsViewController.updatedTripId = tripId
        }
    }
}


// MARK: - UI Related Functions
extension TripEditController {
    private func fillInputFields() {
        tripName.text = foundTrip.title
        tripLocation.text = foundTrip.location
        tripDescription.text = foundTrip.description
        tripStartDate.date = formatOldDate(foundTrip.startDate)
        tripEndDate.date = formatOldDate(foundTrip.endDate)
    }
    
    private func formatOldDate(_ date: String?) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        let formattedDate = dateFormatter.date(from: date!)
        return formattedDate!
    }
    
    private func formatNewDate(_ date: UIDatePicker) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        let dateString = dateFormatter.string(from: date.date)
        return dateString
    }
    
}


// MARK: - Alerts
extension TripEditController {
    private func showQueryAlert(description: String?) {
        let alertController = UIAlertController(title: "Oops...", message: "\(description ?? "Please try again...")", preferredStyle: .alert)
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
}

// citation: https://www.cometchat.com/tutorials/how-to-dismiss-ios-keyboard-swift
extension TripEditController {
    func initializeHideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissMyKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissMyKeyboard(){
        view.endEditing(true)
    }
}
