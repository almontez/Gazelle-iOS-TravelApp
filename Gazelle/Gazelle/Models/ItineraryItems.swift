//
//  ItineraryItems.swift
//  Gazelle
//
//  Created by Angela Li Montez on 4/20/23.
//

import Foundation
import ParseSwift

struct ItineraryItem: ParseObject {
    // Required by `ParseObject`.
    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    var ACL: ParseACL?
    var originalData: Data?
    
    // Custom ItineraryItem properties
    var title: String?
    var startDate: String?     // fix property so it'll do dates *might have to combine date/time
    var startTime: String?       // fix property so it'll do time
    var endDate: String?       // fix property so it'll do dates *might have to combine date/time
    var endTime: String?       // fix property so it'll do time
    var description: String?
    var tripId: String?        // figure out how to get this value from the db
}
