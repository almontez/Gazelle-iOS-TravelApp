//
//  ItineraryFormController.swift
//  Gazelle
//
//  Created by Angela Li Montez on 4/24/23.
//

import UIKit
import ParseSwift

class ItineraryFormController: UIViewController {
    
    var tripId: String?

    @IBOutlet weak var eventTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var startTimePicker: UIDatePicker!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    @IBOutlet weak var endTimePicker: UIDatePicker!
    @IBOutlet weak var descriptionTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeHideKeyboard()
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        if (eventTextField.text == "" || locationTextField.text == "") {
            itineraryItemFieldRequredAlert()
        } else {
            performSegue(withIdentifier: "unwindToItinerary", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let ItineraryViewController = segue.destination as? ItineraryViewController {
            // Create Itinerary Item
            var newItem = ItineraryItem()
            
            // Set Properties
            newItem.title = eventTextField.text
            newItem.location = locationTextField.text
            newItem.startDate = formatDate(startDatePicker)
            newItem.startTime = formatTime(startTimePicker)
            newItem.endDate = formatDate(endDatePicker)
            newItem.endTime = formatTime(endTimePicker)
            newItem.description = descriptionTextField.text
            newItem.tripId = tripId!
            
            ItineraryViewController.newEvent = newItem
        }
    }
    
    private func itineraryItemFieldRequredAlert() {
        let alertController = UIAlertController(title: "Required", message: "The the name, location, and dates of your itinerary event are required.", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(action)
        present(alertController, animated: true)
    }
    
    // citation: https://stackoverflow.com/questions/44346811/extracting-hours-and-minutes-from-uidatepicker
    private func formatDate(_ date: UIDatePicker) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        let dateString = dateFormatter.string(from: date.date)
        return dateString
    }
    
    private func formatTime(_ time: UIDatePicker) -> String {
        var meridiemFlag = "AM"
        var stringMins = ""
        var stringHrs = ""
        let timeComponents = Calendar.current.dateComponents([.hour, .minute], from: time.date)
        var hour = timeComponents.hour!
        let minutes = timeComponents.minute!
        
        if (hour > 11) {
            meridiemFlag = "PM"
            if (hour != 12) {
                hour -= 12
            }
            stringHrs = String(hour)
        } else {
            stringHrs = String(hour)
        }
        
        if (hour == 0 && meridiemFlag == "AM") {
            hour += 12
            stringHrs = String(hour)
        }
        
        if (minutes < 10) {
            stringMins = "0" + String(minutes)
        } else {
            stringMins = String(minutes)
        }
        
        return "\(stringHrs):\(stringMins) \(meridiemFlag)"
    }
}

// citation: https://www.cometchat.com/tutorials/how-to-dismiss-ios-keyboard-swift
extension ItineraryFormController {
    func initializeHideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissMyKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissMyKeyboard(){
        view.endEditing(true)
    }
}
