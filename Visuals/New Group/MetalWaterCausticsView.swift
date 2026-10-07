//
//  MetalWaterCausticsView.swift
//  Visuals
//
//  Created by Aristeidis Gaitanis on 7/10/26.
//


import SwiftUI

struct MetalWaterCausticsView: View {
    @State private var startTime: Date = .now

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 24) {
                // --- DISPLAY CARD WITH CAUSTICS COLOR SHADER ---
                TimelineView(.animation) { timeline in
                    let elapsedTime = timeline.date.timeIntervalSince(startTime)

                    ZStack {
                        // Base gradient art
                        LinearGradient(
                            colors: [.blue, .teal, .indigo],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )

                        VStack(spacing: 12) {
                            Image(systemName: "water.waves")
                                .font(.system(size: 44, weight: .bold))
                                .foregroundStyle(.white)

                            Text("WATER CAUSTICS")
                                .font(.system(size: 20, weight: .black, design: .monospaced))
                                .foregroundStyle(.white)

                            Text("Procedural MSL caustic shimmer shader pass")
                                .font(.caption)
                                .foregroundStyle(.white.opacity(0.8))
                        }
                        .padding(20)
                    }
                    .frame(width: 320, height: 220)
                    .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                    )
                    // --- MSL COLOR EFFECT SHADER ---
                    .colorEffect(
                        ShaderLibrary.waterCaustics(
                            .float(elapsedTime),
                            .float(1.5) // Speed
                        )
                    )
                }

                Text("Powered by Swift MSL .colorEffect Shader")
                    .font(.system(size: 13, weight: .medium, design: .monospaced))
                    .foregroundStyle(.gray)
            }
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    MetalWaterCausticsView()
}