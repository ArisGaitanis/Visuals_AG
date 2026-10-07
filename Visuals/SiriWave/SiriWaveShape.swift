//
//  SiriWaveShape.swift
//  Visuals
//
//  Created by Aristeidis Gaitanis on 7/10/26.
//


import SwiftUI

struct SiriWaveShape: Shape {
    var phase: Double
    var frequency: Double
    var amplitude: Double

    // Allow SwiftUI to animate shape properties smoothly
    var animatableData: AnimatablePair<Double, AnimatablePair<Double, Double>> {
        get {
            AnimatablePair(phase, AnimatablePair(frequency, amplitude))
        }
        set {
            phase = newValue.first
            frequency = newValue.second.first
            amplitude = newValue.second.second
        }
    }

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.width
        let height = rect.height
        let midY = height / 2

        path.move(to: CGPoint(x: 0, y: midY))

        // Step through x coordinates across the view width
        for x in stride(from: 0, through: width, by: 2) {
            let relativeX = x / width // Normalizes x to range [0, 1]
            
            // Envelope function: forces the wave amplitude to 0 at the left & right edges
            // so the wave smoothly anchors at both ends.
            let envelope = sin(.pi * relativeX)

            // Sine wave calculation
            let sine = sin(relativeX * .pi * 2 * frequency + phase)
            let y = midY + CGFloat(sine * envelope * amplitude)

            path.addLine(to: CGPoint(x: x, y: y))
        }

        // Close path along bottom edge for gradient fills if desired, or leave open for lines
        path.addLine(to: CGPoint(x: width, y: midY))
        return path
    }
}