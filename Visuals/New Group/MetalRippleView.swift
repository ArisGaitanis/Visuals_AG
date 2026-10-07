//
//  MetalRippleView.swift
//  Visuals
//
//  Created by Aristeidis Gaitanis on 7/10/26.
//

import SwiftUI

struct MetalRippleView: View {
    @State private var touchLocation: CGPoint = .zero
    @State private var isTouching: Bool = false
    @State private var startTime: Date = .now

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 24) {
                // --- TARGET DISPLAY CARD DISTORTED BY SHADER ---
                TimelineView(.animation) { timeline in
                    let elapsedTime = timeline.date.timeIntervalSince(startTime)

                    ZStack {
                        // Background Art inside card
                        LinearGradient(
                            colors: [.indigo, .purple, .blue],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )

                        VStack(spacing: 12) {
                            Image(systemName: "cpu")
                                .font(.system(size: 44, weight: .bold))
                                .foregroundStyle(.white)

                            Text("METAL SHADER")
                                .font(.system(size: 20, weight: .black, design: .monospaced))
                                .foregroundStyle(.white)

                            Text("Touch card to send liquid distortion ripples")
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
                    // --- MSL METAL DISTORTION SHADER EFFECT ---
                    .distortionEffect(
                        ShaderLibrary.rippleDistortion(
                            .float2(isTouching ? touchLocation : CGPoint(x: 160, y: 110)),
                            .float(elapsedTime),
                            .float(12.0), // Speed
                            .float(0.15), // Frequency
                            .float(isTouching ? 14.0 : 0.0), // Amplitude
                            .float(0.015) // Decay
                        ),
                        maxSampleOffset: CGSize(width: 30, height: 30)
                    )
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { value in
                                isTouching = true
                                touchLocation = value.location
                            }
                            .onEnded { _ in
                                withAnimation(.easeOut(duration: 0.5)) {
                                    isTouching = false
                                }
                            }
                    )
                }

                // Helper Label
                Text("Powered by Swift MSL Stitchable Shader")
                    .font(.system(size: 13, weight: .medium, design: .monospaced))
                    .foregroundStyle(.gray)
            }
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    MetalRippleView()
}
