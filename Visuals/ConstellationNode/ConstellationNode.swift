//
//  ConstellationNode.swift
//  Visuals
//
//  Created by Aristeidis Gaitanis on 7/10/26.
//


import SwiftUI

// Struct representing an individual particle node
struct ConstellationNode {
    var position: CGPoint
    var velocity: CGVector
    var radius: CGFloat
}

struct ParticleConstellationView: View {
    @State private var nodes: [ConstellationNode] = []
    @State private var touchLocation: CGPoint? = nil
    
    let nodeCount = 35
    let maxDistance: CGFloat = 110.0 // Proximity threshold for drawing vector lines

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.black.ignoresSafeArea()

                TimelineView(.animation) { timeline in
                    Canvas { context, size in
                        let bounds = CGRect(origin: .zero, size: size)

                        // --- 1. DRAW CONNECTING VECTOR LINES ---
                        for i in 0..<nodes.count {
                            // Connect to other nodes
                            for j in (i + 1)..<nodes.count {
                                let p1 = nodes[i].position
                                let p2 = nodes[j].position
                                
                                let dx = p2.x - p1.x
                                let dy = p2.y - p1.y
                                let dist = hypot(dx, dy)

                                if dist < maxDistance {
                                    // Line opacity fades as distance increases
                                    let alpha = Double(1.0 - (dist / maxDistance)) * 0.6
                                    
                                    var path = Path()
                                    path.move(to: p1)
                                    path.addLine(to: p2)
                                    
                                    context.stroke(
                                        path,
                                        with: .color(.cyan.opacity(alpha)),
                                        lineWidth: 1.0
                                    )
                                }
                            }

                            // Connect to touch point if active
                            if let touch = touchLocation {
                                let p1 = nodes[i].position
                                let dx = touch.x - p1.x
                                let dy = touch.y - p1.y
                                let dist = hypot(dx, dy)

                                if dist < maxDistance * 1.4 {
                                    let alpha = Double(1.0 - (dist / (maxDistance * 1.4))) * 0.9
                                    
                                    var path = Path()
                                    path.move(to: p1)
                                    path.addLine(to: touch)
                                    
                                    context.stroke(
                                        path,
                                        with: .color(.mint.opacity(alpha)),
                                        lineWidth: 1.5
                                    )
                                }
                            }
                        }

                        // --- 2. DRAW NODE POINTS ---
                        for node in nodes {
                            let nodeRect = CGRect(
                                x: node.position.x - node.radius,
                                y: node.position.y - node.radius,
                                width: node.radius * 2,
                                height: node.radius * 2
                            )
                            context.fill(Path(ellipseIn: nodeRect), with: .color(.white))
                        }
                    }
                    .onChange(of: timeline.date) { _, _ in
                        updatePhysics(bounds: geometry.size)
                    }
                }

                // Interactive Touch Layer
                Color.clear
                    .contentShape(Rectangle())
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { value in
                                touchLocation = value.location
                            }
                            .onEnded { _ in
                                touchLocation = nil
                            }
                    )

                // Overlay Text
                VStack {
                    Spacer()
                    Text("Touch & drag to draw constellation links")
                        .font(.system(size: 14, weight: .medium, design: .monospaced))
                        .foregroundStyle(.gray)
                        .padding(.bottom, 40)
                }
            }
            .onAppear {
                initializeNodes(in: geometry.size)
            }
        }
        .preferredColorScheme(.dark)
    }

    // Initialize random particle nodes across screen bounds
    private func initializeNodes(in size: CGSize) {
        guard nodes.isEmpty else { return }
        
        nodes = (0..<nodeCount).map { _ in
            ConstellationNode(
                position: CGPoint(
                    x: CGFloat.random(in: 20...max(300, size.width - 20)),
                    y: CGFloat.random(in: 20...max(300, size.height - 20))
                ),
                velocity: CGVector(
                    dx: CGFloat.random(in: -0.8...0.8),
                    dy: CGFloat.random(in: -0.8...0.8)
                ),
                radius: CGFloat.random(in: 2.0...3.5)
            )
        }
    }

    // Bounce nodes off screen edges
    private func updatePhysics(bounds: CGSize) {
        guard bounds.width > 0 && bounds.height > 0 else { return }

        for i in 0..<nodes.count {
            var node = nodes[i]

            node.position.x += node.velocity.dx
            node.position.y += node.velocity.dy

            // Bounce horizontal
            if node.position.x <= 0 || node.position.x >= bounds.width {
                node.velocity.dx *= -1
            }

            // Bounce vertical
            if node.position.y <= 0 || node.position.y >= bounds.height {
                node.velocity.dy *= -1
            }

            nodes[i] = node
        }
    }
}

#Preview {
    ParticleConstellationView()
}
