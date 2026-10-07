//
//  PhysicsParticleCloudView.swift
//  Visuals
//
//  Created by Aristeidis Gaitanis on 7/10/26.
//

import SwiftUI

struct PhysicsParticleCloudView: View {
    let particleColor = Color(red: 0.35, green: 0.65, blue: 1.0)
    let particleCount: Int = 500
    let cloudRadius: Double = 110
    let particles: [Particle]

    // Cumulative rotation angles
    @State private var rotationX: Double = 0
    @State private var rotationY: Double = 0

    // Rotational velocities (radians per second)
    @State private var velocityX: Double = 0
    @State private var velocityY: Double = 0

    // Tracking active drag gesture
    @State private var isDragging: Bool = false
    @State private var lastDragTranslation: CGSize = .zero
    @State private var lastFrameTime: Date = Date()

    init() {
        var generated: [Particle] = []
        for _ in 0..<particleCount {
            let u = Double.random(in: 0...1)
            let v = Double.random(in: 0...1)
            let theta = u * 2.0 * .pi
            let phi = acos(2.0 * v - 1.0)
            
            let r = 110.0 * cbrt(Double.random(in: 0.2...1.0))
            
            generated.append(Particle(
                radius: r,
                theta: theta,
                phi: phi,
                size: CGFloat.random(in: 1.5...3.5),
                baseOpacity: Double.random(in: 0.35...0.9),
                speedMultiplier: Double.random(in: 0.6...1.4)
            ))
        }
        self.particles = generated
    }

    var body: some View {
        TimelineView(.animation) { timeline in
            let now = timeline.date
            let deltaTime = min(now.timeIntervalSince(lastFrameTime), 0.033) // Cap delta time to prevent giant jumps
            let elapsedTime = now.timeIntervalSinceReferenceDate

            Canvas { context, size in
                let center = CGPoint(x: size.width / 2, y: size.height / 2)

                // Update particle positions using accumulated rotation
                for particle in particles {
                    // Base idle rotation + interactive rotation state
                    let currentTheta = particle.theta + (elapsedTime * 0.2 * particle.speedMultiplier) + rotationY
                    let currentPhi = particle.phi + (elapsedTime * 0.1 * particle.speedMultiplier) + rotationX

                    // 3D Cartesian coordinates
                    let x3D = particle.radius * sin(currentPhi) * cos(currentTheta)
                    let y3D = particle.radius * sin(currentPhi) * sin(currentTheta)
                    let z3D = particle.radius * cos(currentPhi)

                    // Perspective projection
                    let perspective = 300.0 / (300.0 + z3D)
                    let x2D = center.x + CGFloat(x3D * perspective)
                    let y2D = center.y + CGFloat(y3D * perspective)

                    let depthScale = CGFloat(perspective)
                    let adjustedSize = particle.size * depthScale
                    let depthOpacity = particle.baseOpacity * (0.3 + 0.7 * perspective)

                    let pulse = sin(elapsedTime * 2.0 + particle.theta) * 0.15 + 0.85

                    let rect = CGRect(
                        x: x2D - adjustedSize / 2,
                        y: y2D - adjustedSize / 2,
                        width: adjustedSize,
                        height: adjustedSize
                    )

                    context.opacity = depthOpacity * pulse
                    context.fill(
                        Path(ellipseIn: rect),
                        with: .color(particleColor)
                    )
                }

                // Update momentum physics on each frame
                DispatchQueue.main.async {
                    self.lastFrameTime = now

                    if !isDragging {
                        // Apply angular velocities to total rotation
                        rotationX += velocityX * deltaTime
                        rotationY += velocityY * deltaTime

                        // Apply friction coefficient (0.95 = smooth spin down)
                        let friction = pow(0.95, deltaTime * 60.0)
                        velocityX *= friction
                        velocityY *= friction

                        // Stop tiny sub-pixel updates
                        if abs(velocityX) < 0.001 { velocityX = 0 }
                        if abs(velocityY) < 0.001 { velocityY = 0 }
                    }
                }
            }
        }
        .frame(width: 300, height: 300)
        .background(
            RadialGradient(
                colors: [Color.blue.opacity(0.18), Color.clear],
                center: .center,
                startRadius: 20,
                endRadius: 150
            )
        )
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { value in
                    if !isDragging {
                        isDragging = true
                        velocityX = 0
                        velocityY = 0
                        lastDragTranslation = .zero
                    }

                    // Calculate translation delta since last gesture tick
                    let deltaX = value.translation.width - lastDragTranslation.width
                    let deltaY = value.translation.height - lastDragTranslation.height
                    lastDragTranslation = value.translation

                    // Direct rotation follow while dragging
                    let sensitivity = 0.008
                    rotationY += Double(deltaX) * sensitivity
                    rotationX += Double(deltaY) * sensitivity
                }
                .onEnded { value in
                    isDragging = false

                    // Convert end drag predicted velocity to rotational velocity (radians/sec)
                    let velocitySensitivity = 0.0015
                    velocityY = Double(value.predictedEndTranslation.width - value.translation.width) * velocitySensitivity
                    velocityX = Double(value.predictedEndTranslation.height - value.translation.height) * velocitySensitivity
                }
        )
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        PhysicsParticleCloudView()
    }
}
