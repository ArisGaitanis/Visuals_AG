//
//  Particle.swift
//  Visuals
//
//  Created by Aristeidis Gaitanis on 7/10/26.
//


import SwiftUI

struct Particle: Identifiable {
    let id = UUID()
    // Base spherical coordinates
    let radius: Double
    let theta: Double // Angle from vertical axis
    let phi: Double   // Angle around vertical axis
    let size: CGFloat
    let baseOpacity: Double
    let speedMultiplier: Double
}
