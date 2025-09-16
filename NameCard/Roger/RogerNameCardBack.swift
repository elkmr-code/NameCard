//
//  RogerNameCardBack.swift
//  NameCard
//
//  Created by Roger on 12/30/24.
//

import SwiftUI

struct RogerNameCardBack: View {
    let contact: Contact
    @State private var qrCodeScale: CGFloat = 0.8
    @State private var organizationOpacity: Double = 0

    var body: some View {
        ZStack {
            // Modern gradient background matching front
            LinearGradient(
                colors: [
                    Color(.systemTeal).opacity(0.6),
                    Color(.systemPurple).opacity(0.4),
                    Color(.systemBlue).opacity(0.8)
                ],
                startPoint: .topTrailing,
                endPoint: .bottomLeading
            )
            
            VStack(spacing: 0) {
                // Top spacer
                Spacer(minLength: 16)
                
                // Organization info with modern styling
                VStack(spacing: 8) {
                    Text(contact.organization)
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.center)
                        .opacity(organizationOpacity)
                        .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 1)
                        .lineLimit(2)

                    Text(contact.department)
                        .font(.system(size: 12, weight: .medium, design: .rounded))
                        .foregroundStyle(.white.opacity(0.8))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(
                            Capsule()
                                .fill(.white.opacity(0.2))
                        )
                        .opacity(organizationOpacity)
                        .lineLimit(1)
                }
                
                // Middle spacer
                Spacer(minLength: 12)

                // QR Code section with modern design
                VStack(spacing: 8) {
                    ZStack {
                        // QR Code background
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.white)
                            .frame(width: 80, height: 80)
                            .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
                        
                        RogerQRCodeView(contactInfo: contact.toVCard())
                            .frame(width: 72, height: 72)
                            .scaleEffect(qrCodeScale)
                    }

                    Text("SCAN TO CONNECT")
                        .font(.system(size: 9, weight: .semibold, design: .rounded))
                        .foregroundStyle(.white.opacity(0.8))
                        .tracking(1.0)
                }

                // Bottom spacer
                Spacer(minLength: 16)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
        }
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .scaleEffect(x: -1, y: 1) // Flip horizontally for correct reading when card is flipped
        .onAppear {
            // Animate QR code appearance
            withAnimation(.interpolatingSpring(stiffness: 200, damping: 10).delay(0.3)) {
                qrCodeScale = 1.0
            }
            
            // Animate organization info
            withAnimation(.easeInOut(duration: 0.8).delay(0.1)) {
                organizationOpacity = 1.0
            }
        }
    }
}
