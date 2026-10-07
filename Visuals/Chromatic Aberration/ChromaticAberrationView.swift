//
//  ChromaticAberrationView.swift
//  Visuals
//
//  Created by Aristeidis Gaitanis on 7/10/26.
//


import SwiftUI

struct ChromaticAberrationView: View {
    @State private var dragOffset: CGSize = .zero
    @State private var isDragging: Bool = false
    
    // Default ambient glitch intensity when not dragging
    var effectiveOffset: CGSize {
        if isDragging {
            return dragOffset
        } else {
            return CGSize(width: 4, height: -3)
        }
    }

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 30) {
                // --- CHROMATIC ABERRATION CONTAINER ---
                ZStack {
                    // 1. RED CHANNEL (Shifted in positive offset direction)
                    cardContent
                        .colorMultiply(.red)
                        .offset(
                            x: effectiveOffset.width / 12,
                            y: effectiveOffset.height / 12
                        )
                        .blendMode(.plusLighter)

                    // 2. GREEN CHANNEL (Anchored near center)
                    cardContent
                        .colorMultiply(.green)
                        .blendMode(.plusLighter)

                    // 3. BLUE CHANNEL (Shifted in opposite negative direction)
                    cardContent
                        .colorMultiply(.blue)
                        .offset(
                            x: -effectiveOffset.width / 12,
                            y: -effectiveOffset.height / 12
                        )
                        .blendMode(.plusLighter)
                }
                .scaleEffect(isDragging ? 1.03 : 1.0)
                .shadow(color: .cyan.opacity(0.3), radius: isDragging ? 30 : 10)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            isDragging = true
                            dragOffset = value.translation
                        }
                        .onEnded { _ in
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.5)) {
                                dragOffset = .zero
                                isDragging = false
                            }
                        }
                )

                // Instruction Label
                Text("Drag anywhere to distort RGB channels")
                    .font(.system(size: 14, weight: .medium, design: .monospaced))
                    .foregroundStyle(.gray)
            }
        }
        .preferredColorScheme(.dark)
    }

    // --- BASE CONTENT VIEW ---
    // The subject view duplicated across all 3 color channels
    private var cardContent: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "cpu.fill")
                    .font(.system(size: 32))
                    .foregroundStyle(.white)
                
                Spacer()

                Text("0x89F2")
                    .font(.system(size: 14, weight: .bold, design: .monospaced))
                    .foregroundStyle(.white.opacity(0.8))
            }

            Spacer()

            VStack(alignment: .leading, spacing: 6) {
                Text("NEURAL MATRIX")
                    .font(.system(size: 22, weight: .black, design: .monospaced))
                    .foregroundStyle(.white)

                Text("Chromatic Lens Processing active")
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.7))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(24)
        .frame(width: 320, height: 200)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color(.systemGray6).opacity(0.4))
                .overlay(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                )
        )
    }
}

#Preview {
    ChromaticAberrationView()
}