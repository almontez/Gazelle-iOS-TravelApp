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
        findSpecificTrip(id: tripId!)
    }
}


// MARK: Database Related Operations
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
                self?.showQueryAlert(description: error.localizedDescription)
            }
        }
    }
}

// MARK: - UI Related Functions
extension TripEditController {
    private func fillInputFields() {
        tripName.text = foundTrip.title
        tripLocation.text = foundTrip.location
        tripDescription.text = foundTrip.description
        tripStartDate.date = formatDate(foundTrip.startDate)
        tripEndDate.date = formatDate(foundTrip.endDate)
    }
    
    private func formatDate(_ date: String?) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        let formattedDate = dateFormatter.date(from: date!)
        return formattedDate!
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
}
