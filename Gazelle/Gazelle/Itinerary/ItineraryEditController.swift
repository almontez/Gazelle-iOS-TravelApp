//
//  ItineraryEditController.swift
//  Gazelle
//
//  Created by Angela Li Montez on 5/11/23.
//

import UIKit
import ParseSwift

class ItineraryEditController: UIViewController {
    
    @IBOutlet weak var eventTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var startTimePicker: UIDatePicker!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    @IBOutlet weak var endTimePicker: UIDatePicker!
    @IBOutlet weak var descriptionTextField: UITextField!
    
    var itineraryItemId: String?
    private var foundItem = ItineraryItem()

    override func viewDidLoad() {
        super.viewDidLoad()
        initializeHideKeyboard()
        findSpecificEvent(id: itineraryItemId!)
    }
    
    private func findSpecificEvent(id eventId: String) {
        let query = ItineraryItem.query("objectId" == "\(eventId)")
        
        query.find { [weak self] result in
            switch result {
            case .success(let foundEvent):
                print("✅ Specific Trip Found")
                self?.foundItem = foundEvent[0]
                self?.fillInputFields()
            case .failure(let error):
                self?.showQueryAlert(description: error.localizedDescription)
            }
        }
    }
}


// MARK: - UI Related Functions
extension ItineraryEditController {
    private func fillInputFields() {
        eventTextField.text = foundItem.title
        locationTextField.text = foundItem.location
        descriptionTextField.text = foundItem.description
        startDatePicker.date = formatOldDate(foundItem.startDate)
        formatOldTime(date: foundItem.startDate, time: foundItem.startTime)
        endDatePicker.date = formatOldDate(foundItem.endDate)
    }
    
    private func formatOldDate(_ date: String?) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        let formattedDate = dateFormatter.date(from: date!)
        return formattedDate!
    }
    
    private func formatOldTime(date: String?, time: String?) {
        print(time)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy'T'HH:mm:ssZZZZZ"
        let formattedDate = dateFormatter.date(from: time!)
        print(formattedDate)
    }
    
    private func formatNewDate(_ date: UIDatePicker) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        let dateString = dateFormatter.string(from: date.date)
        return dateString
    }
    
}


// MARK: - Alerts
extension ItineraryEditController {
    private func showQueryAlert(description: String?) {
        let alertController = UIAlertController(title: "Oops...", message: "\(description ?? "Please try again...")", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(action)
        present(alertController, animated: true)
    }
    
    private func itineraryFieldRequredAlert() {
        let alertController = UIAlertController(title: "Required", message: "The the name, location, and dates of your itinerary event are required.", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(action)
        present(alertController, animated: true)
    }
}

// citation: https://www.cometchat.com/tutorials/how-to-dismiss-ios-keyboard-swift
extension ItineraryEditController {
    func initializeHideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissMyKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissMyKeyboard(){
        view.endEditing(true)
    }
}
