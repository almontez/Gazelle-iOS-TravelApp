//
//  TripUsers.swift
//  Gazelle
//
//  Created by Angela Li Montez on 4/20/23.
//

import Foundation
import ParseSwift

struct TripUsers: ParseObject {
    // Required by `ParseObject`.
    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    var ACL: ParseACL?
    var originalData: Data?
    
    // Custom TripUser properties
    var tripId: String?
    var userId: String?
}
