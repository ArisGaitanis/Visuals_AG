//
//  SiriWaveformView.swift
//  Visuals
//
//  Created by Aristeidis Gaitanis on 7/10/26.
//


import SwiftUI

struct SiriWaveformView: View {
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            TimelineView(.animation) { timeline in
                let time = timeline.date.timeIntervalSinceReferenceDate

                ZStack {
                    // Wave Layer 1: Cyan / Blue Base Wave
                    SiriWaveShape(
                        phase: time * 3.0,
                        frequency: 1.5,
                        amplitude: 50
                    )
                    .stroke(
                        LinearGradient(
                            colors: [.cyan, .blue, .purple],
                            startPoint: .leading,
                            endPoint: .trailing
                        ),
                        lineWidth: 3
                    )
                    .blur(radius: 2)

                    // Wave Layer 2: Pink / Magenta Offset Wave
                    SiriWaveShape(
                        phase: -time * 2.5 + 1.2,
                        frequency: 2.2,
                        amplitude: 40
                    )
                    .stroke(
                        LinearGradient(
                            colors: [.pink, .purple, .indigo],
                            startPoint: .leading,
                            endPoint: .trailing
                        ),
                        lineWidth: 2.5
                    )
                    .blendMode(.screen)

                    // Wave Layer 3: High Frequency Glowing Highlight
                    SiriWaveShape(
                        phase: time * 4.0 + 2.5,
                        frequency: 3.0,
                        amplitude: 25
                    )
                    .stroke(
                        LinearGradient(
                            colors: [.white, .cyan.opacity(0.8), .mint],
                            startPoint: .leading,
                            endPoint: .trailing
                        ),
                        lineWidth: 1.8
                    )
                    .blendMode(.plusLighter)

                    // Outer ambient glow pass
                    SiriWaveShape(
                        phase: time * 3.0,
                        frequency: 1.5,
                        amplitude: 55
                    )
                    .stroke(Color.cyan.opacity(0.4), lineWidth: 8)
                    .blur(radius: 12)
                }
                .frame(height: 200)
                .padding(.horizontal, 20)
            }

            // Foreground Text
            VStack {
                Spacer()
                Text("Siri Audio Waveform")
                    .font(.system(size: 15, weight: .medium, design: .monospaced))
                    .foregroundStyle(.white.opacity(0.7))
                    .padding(.bottom, 40)
            }
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    SiriWaveformView()
}