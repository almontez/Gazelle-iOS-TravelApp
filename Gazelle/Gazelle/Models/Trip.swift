//
//  Trips.swift
//  Gazelle
//
//  Created by Angela Li Montez on 4/20/23.
//

import Foundation
import ParseSwift

struct Trip: ParseObject {
    // Required by `ParseObject`.
    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    var ACL: ParseACL?
    var originalData: Data?
    
    // Custom Trip properties
    var title: String?
    var description: String?
    var location: String?
    var startDate: String?
    var endDate: String?
    var userId: String?
}
