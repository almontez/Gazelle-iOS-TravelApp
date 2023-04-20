//
//  Destinations.swift
//  Gazelle
//
//  Created by Angela Li Montez on 4/20/23.
//

import Foundation
import ParseSwift

struct Destinations: ParseObject {
    // Required by `ParseObject`.
    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    var ACL: ParseACL?
    var originalData: Data?
    
    // Custom Destination properties
    var country: String?
    var state: String?
    var city: String?
    var startDate: String?  // fix property so it'll do dates
    var endDate: String?    // fix property so it'll do dates
    var tripId: String?     // figure out how to get this value from the db
}
