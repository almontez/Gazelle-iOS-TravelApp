//
//  Formatters.swift
//  Gazelle
//
//  Created by Angela Li Montez on 5/15/23.
//

import Foundation
import UIKit
import Contacts
import MapKit

extension UIViewController {
    
    // citation: https://stackoverflow.com/questions/44346811/extracting-hours-and-minutes-from-uidatepicker
    func formatDate(_ date: UIDatePicker) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        let dateString = dateFormatter.string(from: date.date)
        return dateString
    }
    
    func formatOldDate(_ date: String?) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        let formattedDate = dateFormatter.date(from: date!)
        return formattedDate!
    }
    
    func formatTime(_ time: UIDatePicker) -> String {
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
    
    // Citation: https://stackoverflow.com/questions/28985483/how-to-change-uidatepicker-to-a-specific-time-in-code
    func formatOldTime(time: String, picker: UIDatePicker) {
        // Time Separators
        let separatorIdx = time.firstIndex(of: ":")!
        let meridiemSeparator = time.firstIndex(of: " ")!
        // Get hr from string
        let hrIdx = time.index(before: separatorIdx)
        var hr = Int(time[...hrIdx])
        // Get mins from string
        let minStart = time.index(after: separatorIdx)
        let minEnd = time.index(before: meridiemSeparator)
        let min = Int(time[minStart...minEnd])
        // Get AM/PM from string
        let meridiemStart = time.index(after: meridiemSeparator)
        let meridiem = time[meridiemStart...]
        
        // Convert hr to 24 hr format
        if meridiem == "PM" && hr! != 12 {
            hr! += 12
        } else if meridiem == "AM" && hr! == 12 {
            hr! -= 12
        }
        
        // Update time on UIDatePicker
        let calendar = Calendar.current
        var components = DateComponents()
        components.hour = hr!
        components.minute = min!
        
        if picker.tag == 0 {
            picker.setDate(calendar.date(from: components)!, animated: false)
        } else {
            picker.setDate(calendar.date(from: components)!, animated: false)
        }
    }
}

extension UITableViewController {
    func formatCategories(_ categorySet: Set<String>) -> String {
        var cat_str = ""
        for item in categorySet {
            cat_str += "\(item), "
        }
        let formatted_str = cat_str.dropLast(2)
        return String(formatted_str)
    }
}

extension MKPlacemark {
    var formattedAddress: String? {
        guard let postalAddress = postalAddress else { return nil }
        return CNPostalAddressFormatter.string(from: postalAddress, style: .mailingAddress).replacingOccurrences(of: "\n", with: " ")
    }
}
