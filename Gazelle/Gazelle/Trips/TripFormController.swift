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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let TripsViewController = segue.destination as? TripsViewController {
            // Create new Trip object
            var newTrip = Trip()
            
            // Set Properties
            newTrip.title = tripName.text
            newTrip.description = tripDescription.text
            newTrip.userId = User.current?.objectId as String?
            newTrip.location = tripLocation.text
            newTrip.startDate = formatDate(tripStartDate)
            newTrip.endDate = formatDate(tripEndDate)
            
            TripsViewController.newTrip = newTrip
        }
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
