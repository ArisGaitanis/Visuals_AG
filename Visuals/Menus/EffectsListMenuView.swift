//
//  EffectsListMenuView.swift
//  Visuals
//
//  Created by Aristeidis Gaitanis on 7/10/26.
//


import SwiftUI

struct EffectsListMenuView: View {
    @State private var selectedEffect: VisualEffectItem?

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
            name: "Particle Sphere",
            subtitle: "Interactive 3D Point Cloud",
            icon: "circle.dotted.circle",
            accentColor: .cyan,
            viewType: .sphere
        ),
        VisualEffectItem(
            name: "Bouncing Dots",
            subtitle: "Animated Loader Feedback",
            icon: "text.bubble",
            accentColor: .orange,
            viewType: .bouncingDots
        )
    ]

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()

                ScrollView {
                    LazyVStack(spacing: 14) {
                        ForEach(effects) { item in
                            Button {
                                selectedEffect = item
                            } label: {
                                EffectRowView(item: item)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                    .padding(.bottom, 30)
                }
            }
            .navigationTitle("Visual Effects")
            .navigationBarTitleDisplayMode(.large)
            .toolbarBackground(.black, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .navigationDestination(item: $selectedEffect) { item in
                EffectDetailStageView(item: item)
            }
        }
        .preferredColorScheme(.dark)
    }
}

// MARK: - Custom List Row Component
private struct EffectRowView: View {
    let item: VisualEffectItem

    var body: some View {
        HStack(spacing: 16) {
            // Icon Badge
            ZStack {
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(item.accentColor.opacity(0.18))
                    .frame(width: 48, height: 48)

                Image(systemName: item.icon)
                    .font(.title3)
                    .foregroundStyle(item.accentColor)
            }

            // Text Metadata
            VStack(alignment: .leading, spacing: 4) {
                Text(item.name)
                    .font(.headline)
                    .foregroundStyle(.white)

                if !item.subtitle.isEmpty {
                    Text(item.subtitle)
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                }
            }

            Spacer()

            // Disclosure Chevron
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(.white.opacity(0.3))
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color(.systemGray6).opacity(0.25))
                .overlay(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .stroke(Color.white.opacity(0.08), lineWidth: 1)
                )
        )
    }
}

// MARK: - Dedicated Detail Stage View
private struct EffectDetailStageView: View {
    let item: VisualEffectItem

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 0) {
                // Interactive Stage Container
                ZStack {
                    RoundedRectangle(cornerRadius: 28, style: .continuous)
                        .fill(Color(.systemGray6).opacity(0.15))
                        .overlay(
                            RoundedRectangle(cornerRadius: 28, style: .continuous)
                                .stroke(Color.white.opacity(0.08), lineWidth: 1)
                        )

                    // Target View Router
                    Group {
                        switch item.viewType {
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
                            .frame(maxWidth: .infinity, maxHeight: 150)
                        case .sphere:
                            PhysicsParticleCloudView()
                        }
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                    .padding(12)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 16)

                // Footer Metadata
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(item.name)
                            .font(.system(size: 15, weight: .bold))
                            .foregroundStyle(.white)

                        if !item.subtitle.isEmpty {
                            Text(item.subtitle)
                                .font(.caption)
                                .foregroundStyle(.gray)
                        }
                    }

                    Spacer()

                    Text("Interactive Mode")
                        .font(.system(size: 10, weight: .bold, design: .monospaced))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(Capsule().fill(item.accentColor.opacity(0.2)))
                        .foregroundStyle(item.accentColor)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 20)
            }
        }
        .navigationTitle(item.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark, for: .navigationBar)
    }
}

#Preview {
    EffectsListMenuView()
}
