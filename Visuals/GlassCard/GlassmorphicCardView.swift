//
//  GlassmorphicCardView.swift
//  Visuals
//
//  Created by Aristeidis Gaitanis on 7/10/26.
//


import SwiftUI

struct GlassmorphicCardView: View {
    @State private var dragOffset: CGSize = .zero
    @State private var isDragging: Bool = false

    var body: some View {
        ZStack {
            // Ambient radial background glow
            Color.black.ignoresSafeArea()

            RadialGradient(
                colors: [.indigo.opacity(0.6), .purple.opacity(0.3), .black],
                center: .center,
                startRadius: 50,
                endRadius: 400
            )
            .ignoresSafeArea()

            // Main Card Component
            ZStack {
                // 1. Base Glass Material Layer
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(.ultraThinMaterial)

                // 2. Dynamic Specular Light Sheen (Follows Finger Drag)
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [
                                .white.opacity(isDragging ? 0.45 : 0.25),
                                .white.opacity(0.05),
                                .clear
                            ],
                            startPoint: UnitPoint(
                                x: 0.5 + (dragOffset.width / 300),
                                y: 0.5 + (dragOffset.height / 300)
                            ),
                            endPoint: UnitPoint(
                                x: 0.5 - (dragOffset.width / 300),
                                y: 0.5 - (dragOffset.height / 300)
                            )
                        )
                    )

                // 3. Inner Card Content & Typography
                VStack(alignment: .leading, spacing: 20) {
                    HStack {
                        Image(systemName: "creditcard.circle.fill")
                            .font(.system(size: 38))
                            .foregroundStyle(.cyan)

                        Spacer()

                        Image(systemName: "wave.3.right")
                            .font(.title2)
                            .foregroundStyle(.white.opacity(0.7))
                    }

                    Spacer()

                    Text("1234 •••• •••• 1234")
                        .font(.system(size: 22, weight: .bold, design: .monospaced))
                        .foregroundStyle(.white)

                    HStack {
                        VStack(alignment: .leading) {
                            Text("CARD HOLDER")
                                .font(.caption2)
                                .foregroundStyle(.gray)
                            Text("ARIS GAITANIS")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundStyle(.white)
                        }

                        Spacer()

                        VStack(alignment: .leading) {
                            Text("EXPIRES")
                                .font(.caption2)
                                .foregroundStyle(.gray)
                            Text("10/29")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundStyle(.white)
                        }
                    }
                }
                .padding(28)

                // 4. Glowing Frosted Rim Border
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .stroke(
                        LinearGradient(
                            colors: [
                                .white.opacity(0.6),
                                .cyan.opacity(0.4),
                                .white.opacity(0.1)
                            ],
                            startPoint: UnitPoint(
                                x: 0.2 + (dragOffset.width / 400),
                                y: 0.2 + (dragOffset.height / 400)
                            ),
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1.5
                    )
            }
            .frame(width: 340, height: 210)
            .shadow(color: .cyan.opacity(isDragging ? 0.35 : 0.15), radius: 25, x: 0, y: 15)
            // Apply 3D pitch and roll pitch according to drag offsets
            .rotation3DEffect(
                .degrees(Double(-dragOffset.height / 10)),
                axis: (x: 1.0, y: 0.0, z: 0.0)
            )
            .rotation3DEffect(
                .degrees(Double(dragOffset.width / 10)),
                axis: (x: 0.0, y: 1.0, z: 0.0)
            )
            // Gesture handling
            .gesture(
                DragGesture()
                    .onChanged { value in
                        isDragging = true
                        dragOffset = value.translation
                    }
                    .onEnded { _ in
                        withAnimation(.spring(response: 0.45, dampingFraction: 0.6)) {
                            dragOffset = .zero
                            isDragging = false
                        }
                    }
            )

            // Instruction Label
            VStack {
                Spacer()
                Text("Drag card to tilt & reflect light")
                    .font(.system(size: 15, weight: .medium, design: .monospaced))
                    .foregroundStyle(.white.opacity(0.7))
                    .padding(.bottom, 40)
            }
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    GlassmorphicCardView()
}
