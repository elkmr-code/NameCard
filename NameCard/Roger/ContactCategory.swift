//
//  ContactCategory.swift
//  NameCard
//
//  Created by Roger on 12/30/24.
//

import Foundation
import SwiftData

@Model
class ContactCategory {
    var id: UUID
    var name: String
    
    @Relationship(deleteRule: .nullify, inverse: \StoredContact.category)
    var contacts: [StoredContact] = []
    
    init(id: UUID, name: String) {
        self.id = id
        self.name = name
    }
}
