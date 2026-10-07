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
        case metalRipple // NEW MSL Shader Case
        case waterCaustics // NEW
        case metalGlitch
    }
}
