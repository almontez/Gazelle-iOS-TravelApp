//
//  User.swift
//  Gazelle
//
//  Created by Dylan Canipe on 4/15/23.
//

import ParseSwift
import Foundation

struct User : ParseUser {
    var emailVerified: Bool?
    var originalData: Data?
    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    var ACL: ParseSwift.ParseACL?
    
    var authData: [String : [String : String]?]?
    
    var user_id: Int?
    var first_name: String?
    var last_name: String?
    var email: String?
    var username: String?
    var password: String?
    
}
