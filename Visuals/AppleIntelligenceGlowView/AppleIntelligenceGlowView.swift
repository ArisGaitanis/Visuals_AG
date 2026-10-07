//
//  AppleIntelligenceGlowView.swift
//  Visuals
//
//  Created by Aristeidis Gaitanis on 7/10/26.
//


import SwiftUI

struct AppleIntelligenceGlowView: View {
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 35) {
                // --- GLOWING BORDER CARD CONTAINER ---
                ZStack {
                    // 1. BASE CARD CONTENT
                    VStack(spacing: 18) {
                        HStack {
                            Image(systemName: "sparkles")
                                .font(.system(size: 28, weight: .semibold))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [.cyan, .purple, .pink],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )

                            Spacer()

                            Text("SIRI INTELLIGENCE")
                                .font(.system(size: 11, weight: .bold, design: .monospaced))
                                .foregroundStyle(.gray)
                        }

                        Spacer()

                        VStack(alignment: .leading, spacing: 8) {
                            Text("Apple Intelligence")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundStyle(.white)

                            Text("Contextual awareness & dynamic visual glowing perimeter")
                                .font(.subheadline)
                                .foregroundStyle(.white.opacity(0.7))
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(26)
                    .frame(width: 330, height: 210)
                    .background(
                        RoundedRectangle(cornerRadius: 28, style: .continuous)
                            .fill(Color(.systemGray6).opacity(0.3))
                    )

                    // 2. ROTATING GLOWING BORDER OVERLAY
                    TimelineView(.animation) { timeline in
                        let time = timeline.date.timeIntervalSinceReferenceDate
                        let rotationAngle = Angle.degrees(time * 120.0) // 120 deg/sec spin

                        ZStack {
                            // Layer A: Ambient outer bloom glow
                            RoundedRectangle(cornerRadius: 28, style: .continuous)
                                .stroke(
                                    AngularGradient(
                                        colors: [.cyan, .blue, .purple, .pink, .orange, .cyan],
                                        center: .center,
                                        angle: rotationAngle
                                    ),
                                    lineWidth: 6
                                )
                                .blur(radius: 12)
                                .opacity(0.8)

                            // Layer B: Crisp inner border line
                            RoundedRectangle(cornerRadius: 28, style: .continuous)
                                .stroke(
                                    AngularGradient(
                                        colors: [.cyan, .blue, .purple, .pink, .orange, .cyan],
                                        center: .center,
                                        angle: rotationAngle
                                    ),
                                    lineWidth: 2.5
                                )
                        }
                        .frame(width: 330, height: 210)
                    }
                }

                // Subtitle
                Text("Continuous AngularGradient perimeter flow")
                    .font(.system(size: 14, weight: .medium, design: .monospaced))
                    .foregroundStyle(.gray)
            }
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    AppleIntelligenceGlowView()
}