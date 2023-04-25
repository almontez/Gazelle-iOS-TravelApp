//
//  ItineraryFormController.swift
//  Gazelle
//
//  Created by Angela Li Montez on 4/24/23.
//

import UIKit

class ItineraryFormController: UIViewController {

    @IBOutlet weak var eventTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var startTimePicker: UIDatePicker!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    @IBOutlet weak var endTimePicker: UIDatePicker!
    @IBOutlet weak var descriptionTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // getCountriesList()
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        print(eventTextField.text ?? "No Event Title Provided")
        print(locationTextField.text ?? "No Location Provided")
        print(startDatePicker.date)
        print(startTimePicker.date)
        print(endDatePicker.date)
        print(endTimePicker.date)
        print(descriptionTextField.text ?? "No Description Provided")
    }

//  Citation https://stackoverflow.com/questions/27875463/how-do-i-get-a-list-of-countries-in-swift-ios
    func getCountriesList() -> [String] {
        var countriesList: [String] = []
        
        for code in NSLocale.isoCountryCodes  {
            let id = NSLocale.localeIdentifier(fromComponents: [NSLocale.Key.countryCode.rawValue: code])
            let name = NSLocale(localeIdentifier: "en_US").displayName(forKey: NSLocale.Key.identifier, value: id) ?? "Country not found for code: \(code)"
            countriesList.append(name)
        }
        
        return countriesList
    }
}
