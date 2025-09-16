//
//  StoredContact.swift
//  NameCard
//
//  Created by Roger on 12/30/24.
//

import Foundation
import SwiftData

@Model
class StoredContact {
    var id: UUID
    var name: String
    var title: String
    var email: String
    
    var category: ContactCategory?
    
    init(id: UUID, name: String, title: String, email: String) {
        self.id = id
        self.name = name
        self.title = title
        self.email = email
    }
}
