//
//  LiquidMetaballsView.swift
//  Visuals
//
//  Created by Aristeidis Gaitanis on 7/10/26.
//


import SwiftUI

struct LiquidMetaballsView: View {
    @State private var dragLocation: CGPoint = .zero
    @State private var isDragging: Bool = false

    var body: some View {
        GeometryReader { geometry in
            let center = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
            let activeDragPoint = isDragging ? dragLocation : center

            ZStack {
                Color.black.ignoresSafeArea()

                // Continuous 60/120fps timeline for smooth particle movement
                TimelineView(.animation) { timeline in
                    let time = timeline.date.timeIntervalSinceReferenceDate

                    Canvas { context, size in
                        // 1. Alpha Threshold: Makes any pixel with alpha > 0.5 solid cyan, and others transparent
                        context.addFilter(.alphaThreshold(min: 0.5, color: .cyan))
                        // 2. Blur: Blurs all items drawn within this canvas layer so their edges blend together
                        context.addFilter(.blur(radius: 28))

                        // Draw inside a layer so the filters apply to all shapes collectively
                        context.drawLayer { layerContext in
                            
                            // Draw 5 floating orbiting blobs
                            for i in 0..<5 {
                                let speed = 0.8 + Double(i) * 0.15
                                let angle = time * speed + Double(i) * (.pi * 0.4)
                                
                                let radiusX = 70.0 + Double(i * 10)
                                let radiusY = 50.0 + Double(i * 8)

                                let x = center.x + cos(angle) * radiusX
                                let y = center.y + sin(angle * 1.3) * radiusY

                                let blobRect = CGRect(x: x - 40, y: y - 40, width: 80, height: 80)
                                layerContext.fill(Path(ellipseIn: blobRect), with: .color(.white))
                            }

                            // Draw the main draggable blob
                            let mainBlobRect = CGRect(
                                x: activeDragPoint.x - 55,
                                y: activeDragPoint.y - 55,
                                width: 110,
                                height: 110
                            )
                            layerContext.fill(Path(ellipseIn: mainBlobRect), with: .color(.white))
                        }
                    }
                }

                // Instructions Overlay
                VStack {
                    Spacer()
                    Text("Drag the center blob to merge!")
                        .font(.system(size: 15, weight: .medium, design: .monospaced))
                        .foregroundStyle(.white.opacity(0.7))
                        .padding(.bottom, 40)
                }
            }
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        isDragging = true
                        dragLocation = value.location
                    }
                    .onEnded { _ in
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
                            isDragging = false
                        }
                    }
            )
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    LiquidMetaballsView()
}
