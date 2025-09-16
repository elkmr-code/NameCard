//
//  RogerAppView.swift
//  NameCard
//
//  Created by Roger on 12/30/24.
//

import SwiftUI
import SwiftData

struct RogerAppView: View {
    var body: some View {
        RogerContactListView()
            .modelContainer(for: [StoredContact.self, ContactCategory.self])
            .onAppear {
                // Add some sample data if needed
                addSampleDataIfNeeded()
            }
    }
    
    private func addSampleDataIfNeeded() {
        // This would typically check if data exists and add sample data if needed
        // For now, we'll leave this empty and let users add their own data
    }
}

#Preview {
    RogerAppView()
}
