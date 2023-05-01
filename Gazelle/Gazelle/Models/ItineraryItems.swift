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
    var location: String?
    var startDate: String?
    var startTime: String?
    var endDate: String?
    var endTime: String?
    var description: String?
    var tripId: String?
}
