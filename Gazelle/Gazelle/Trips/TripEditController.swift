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
    
    @IBAction func updateBtnTapped(_ sender: UIButton) {
        if (tripName.text == "" || tripLocation.text == "") {
            showMissingFieldsAlert()
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
            updatedTrip.startDate = formatDate(tripStartDate)
            updatedTrip.endDate = formatDate(tripEndDate)
            
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
}

// MARK: - CRUD Related Operations
extension TripEditController {
    private func findSpecificTrip(id tripId: String) {
        let query = Trip.query("objectId" == "\(tripId)")
        
        query.find { [weak self] result in
            switch result {
            case .success(let foundTrip):
                print("✅ Specific Trip Found")
                self?.foundTrip = foundTrip[0]
                self?.fillInputFields()
            case .failure(let error):
                self?.showFailureAlert(description: error.localizedDescription)
            }
        }
    }
}
