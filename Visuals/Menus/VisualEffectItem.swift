//
//  VisualEffectItem.swift
//  Visuals
//
//  Created by Aristeidis Gaitanis on 7/10/26.
//


import SwiftUI

// Struct defining each showcase item
struct VisualEffectItem: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let subtitle: String
    let icon: String
    let accentColor: Color
    let viewType: EffectType

    enum EffectType {
        case metaballs
        case siriWaveform //SiriWave
        case glassmorphicCard //Glass Card
        case chromaticAberration //
        case particleConstellation // Constellation
        case appleIntelligenceGlow // AppleIntelligenceGlow
        case bouncingDots // BouncingDots
        case sphere // PhysicsParticleSphere
    }
}

struct EffectsShowcaseView: View {
    @State private var selectedEffect: VisualEffectItem.EffectType = .glassmorphicCard
    
    // Catalog of all 6 visual effects
    let effects: [VisualEffectItem] = [
        VisualEffectItem(
            name: "3D Glass Card",
            subtitle: "Materials & 3D Tilt Sheen",
            icon: "creditcard.fill",
            accentColor: .cyan,
            viewType: .glassmorphicCard
        ),
        VisualEffectItem(
            name: "Siri Glow",
            subtitle: "Angular Perimeter Flow",
            icon: "sparkles",
            accentColor: .purple,
            viewType: .appleIntelligenceGlow
        ),
        VisualEffectItem(
            name: "Liquid Blobs",
            subtitle: "Canvas Blur & Threshold",
            icon: "drop.fill",
            accentColor: .blue,
            viewType: .metaballs
        ),
        VisualEffectItem(
            name: "Siri Waveform",
            subtitle: "Trig Sine & Blend Modes",
            icon: "waveform.path",
            accentColor: .pink,
            viewType: .siriWaveform
        ),
        VisualEffectItem(
            name: "RGB Aberration",
            subtitle: "Channel Shift & Distortion",
            icon: "circle.grid.cross.fill",
            accentColor: .red,
            viewType: .chromaticAberration
        ),
        VisualEffectItem(
            name: "Constellation",
            subtitle: "Vector Links & Proximity",
            icon: "moon.stars",
            accentColor: .mint,
            viewType: .particleConstellation
        ),
        VisualEffectItem(
            name: "ParticleSphere",
            subtitle: "Vector Links & Proximity",
            icon: "circle.dotted.circle",
            accentColor: .cyan,
            viewType: .sphere
        ),
        VisualEffectItem(
            name: "BoundingDots",
            subtitle: "",
            icon: "text.bubble",
            accentColor: .gray,
            viewType: .bouncingDots
        )
    ]

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 0) {
                // --- TOP NAVIGATION HEADER ---
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("VISUAL EFFECTS")
                            .font(.system(size: 11, weight: .bold, design: .monospaced))
                            .foregroundStyle(.cyan)

                        Text("SwiftUI Gallery")
                            .font(.title2.bold())
                            .foregroundStyle(.white)
                    }

                    Spacer()

                    Image(systemName: "square.stack.3d.up.fill")
                        .font(.title2)
                        .foregroundStyle(.cyan)
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 12)

                // --- HORIZONTAL CATEGORY SELECTOR ---
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(effects) { item in
                            Button {
                                withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                                    selectedEffect = item.viewType
                                }
                            } label: {
                                HStack(spacing: 8) {
                                    Image(systemName: item.icon)
                                        .font(.subheadline)
                                    Text(item.name)
                                        .font(.system(size: 13, weight: .semibold))
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 10)
                                .background(
                                    Capsule()
                                        .fill(
                                            selectedEffect == item.viewType
                                            ? item.accentColor.opacity(0.25)
                                            : Color(.systemGray6).opacity(0.3)
                                        )
                                )
                                .overlay(
                                    Capsule()
                                        .stroke(
                                            selectedEffect == item.viewType
                                            ? item.accentColor.opacity(0.8)
                                            : Color.white.opacity(0.1),
                                            lineWidth: 1
                                        )
                                )
                                .foregroundStyle(
                                    selectedEffect == item.viewType ? .white : .gray
                                )
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 8)
                }

                // --- MAIN DISPLAY CONTAINER ---
                ZStack {
                    RoundedRectangle(cornerRadius: 32, style: .continuous)
                        .fill(Color(.systemGray6).opacity(0.15))
                        .overlay(
                            RoundedRectangle(cornerRadius: 32, style: .continuous)
                                .stroke(Color.white.opacity(0.08), lineWidth: 1)
                        )
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)

                    // Active Effect Stage
                    Group {
                        switch selectedEffect {
                        case .metaballs:
                            LiquidMetaballsView()
                        case .siriWaveform:
                            SiriWaveformView()
                        case .glassmorphicCard:
                            GlassmorphicCardView()
                        case .chromaticAberration:
                            ChromaticAberrationView()
                        case .particleConstellation:
                            ParticleConstellationView()
                        case .appleIntelligenceGlow:
                            AppleIntelligenceGlowView()
                        case .bouncingDots:
                            BouncingDotsView(
                                amountOfDots: 5,
                                dotSize: 40,
                                bounceHeight: -40.0
                            )
                            .frame(width:.infinity, height: 150)
                        case .sphere:
                            PhysicsParticleCloudView()
                        }
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                }

                // --- BOTTOM FOOTER INFO ---
                if let currentItem = effects.first(where: { $0.viewType == selectedEffect }) {
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(currentItem.name)
                                .font(.system(size: 14, weight: .bold))
                                .foregroundStyle(.white)

                            Text(currentItem.subtitle)
                                .font(.caption)
                                .foregroundStyle(.gray)
                        }

                        Spacer()

                        Text("Interactive Mode")
                            .font(.system(size: 10, weight: .bold, design: .monospaced))
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(Capsule().fill(currentItem.accentColor.opacity(0.2)))
                            .foregroundStyle(currentItem.accentColor)
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 16)
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    EffectsShowcaseView()
}
