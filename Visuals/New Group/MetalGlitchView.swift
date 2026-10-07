//
//  MetalGlitchView.swift
//  Visuals
//
//  Created by Aristeidis Gaitanis on 7/10/26.
//


import SwiftUI

struct MetalGlitchView: View {
    @State private var glitchIntensity: CGFloat = 0.0
    @State private var startTime: Date = .now

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 24) {
                // --- TARGET DISPLAY CARD WITH GLITCH LAYER SHADER ---
                TimelineView(.animation) { timeline in
                    let elapsedTime = timeline.date.timeIntervalSince(startTime)

                    ZStack {
                        // Card Content
                        LinearGradient(
                            colors: [.purple, .indigo, .black],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )

                        VStack(spacing: 12) {
                            Image(systemName: "terminal.fill")
                                .font(.system(size: 44, weight: .bold))
                                .foregroundStyle(.cyan)

                            Text("HOLOGRAPHIC GLITCH")
                                .font(.system(size: 20, weight: .black, design: .monospaced))
                                .foregroundStyle(.white)

                            Text("Drag to adjust MSL layer block displacement")
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
                    // --- MSL LAYER EFFECT SHADER ---
                    .layerEffect(
                        ShaderLibrary.holographicGlitch(
                            .float(elapsedTime),
                            .float(glitchIntensity)
                        ),
                        maxSampleOffset: CGSize(width: 40, height: 40)
                    )
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { value in
                                // Map horizontal drag distance to intensity (0.0 to 1.0)
                                let progress = max(0.0, min(1.0, value.translation.width / 200.0))
                                glitchIntensity = progress > 0 ? progress : abs(value.translation.width / 200.0)
                            }
                            .onEnded { _ in
                                withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                                    glitchIntensity = 0.0
                                }
                            }
                    )
                }

                Text("Drag horizontally to scale MSL .layerEffect")
                    .font(.system(size: 13, weight: .medium, design: .monospaced))
                    .foregroundStyle(.gray)
            }
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    MetalGlitchView()
}