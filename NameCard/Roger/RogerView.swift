//
//  RogerView.swift
//  NameCard
//
//  Created by Roger on 12/30/24.
//

import SwiftUI
import SwiftData

struct RogerView: View {
    @State private var isFlipped = false
    @State private var rotationAngle: Double = 0
    @State private var cardScale: CGFloat = 1.0
    
    let contact: Contact?
    let storedContact: StoredContact?
    
    init(contact: Contact) {
        self.contact = contact
        self.storedContact = nil
    }
    
    init(storedContact: StoredContact) {
        self.contact = nil
        self.storedContact = storedContact
    }
    
    // Convert StoredContact to Contact for display
    private var displayContact: Contact {
        if let contact = contact {
            return contact
        } else if let storedContact = storedContact {
            return Contact(
                firstName: storedContact.name.components(separatedBy: " ").first ?? "",
                lastName: storedContact.name.components(separatedBy: " ").dropFirst().joined(separator: " "),
                title: storedContact.title,
                organization: storedContact.category?.name ?? "Unknown Organization",
                email: storedContact.email,
                phone: "+1-555-000-0000", // Default phone
                address: "Unknown Address", // Default address
                website: "example.com", // Default website
                department: "Unknown Department" // Default department
            )
        } else {
            // Fallback to sample data
            return Contact.rogerSampleData
        }
    }

    var body: some View {
        ZStack {
            // Modern gradient background
            LinearGradient(
                colors: [
                    Color(.systemBlue).opacity(0.1),
                    Color(.systemPurple).opacity(0.05),
                    Color(.systemBackground)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            // Name Card with modern iOS 17+ styling
            ZStack {
                if !isFlipped {
                    // Front of card
                    RogerNameCardFront(contact: displayContact)
                        .opacity(isFlipped ? 0 : 1)
                } else {
                    // Back of card
                    RogerNameCardBack(contact: displayContact)
                        .opacity(isFlipped ? 1 : 0)
                }
            }
            .frame(width: 360, height: 230)
            .background(
                // Modern card background with materials
                RoundedRectangle(cornerRadius: 16)
                    .fill(.regularMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .strokeBorder(
                                LinearGradient(
                                    colors: [.white.opacity(0.3), .clear],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1
                            )
                    )
            )
            .shadow(
                color: .black.opacity(0.15),
                radius: 20,
                x: 0,
                y: 10
            )
            .scaleEffect(cardScale)
            .rotation3DEffect(
                .degrees(isFlipped ? 180 : 0),
                axis: (x: 0, y: 1, z: 0),
                perspective: 0.5
            )
            .onTapGesture {
                withAnimation(.interpolatingSpring(stiffness: 200, damping: 15)) {
                    isFlipped.toggle()
                }
                
                // Subtle scale animation
                withAnimation(.easeInOut(duration: 0.1)) {
                    cardScale = 0.98
                }
                withAnimation(.easeInOut(duration: 0.1).delay(0.1)) {
                    cardScale = 1.0
                }
            }
        }
    }
}

#Preview("With Contact") {
    RogerView(contact: Contact.rogerSampleData)
}

#Preview("With StoredContact") {
    let sampleCategory = ContactCategory(id: UUID(), name: "University")
    let sampleStoredContact = StoredContact(
        id: UUID(),
        name: "Roger Chen",
        title: "Senior Smooth Replies Manager",
        email: "roger@liftwithroger.com"
    )
    sampleStoredContact.category = sampleCategory
    
    return RogerView(storedContact: sampleStoredContact)
        .modelContainer(for: [StoredContact.self, ContactCategory.self], inMemory: true)
}
