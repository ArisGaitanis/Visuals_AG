//
//  ThreeBouncingDotsView.swift
//  Visuals
//
//  Created by Aristeidis Gaitanis on 7/10/26.
//

import SwiftUI

struct BouncingDotsView: View {
    // Configuration options
    var amountOfDots: Int = 3
    var dotSize: CGFloat = 8
    var dotColor: Color = .gray
    //Negatice value for bouncing upwards possitive for downwards
    var bounceHeight: CGFloat = -6

    @State private var isAnimating = false

    var body: some View {
        HStack(spacing: 5) {
            ForEach(0..<amountOfDots) { index in
                Circle()
                    .fill(dotColor)
                    .frame(width: dotSize, height: dotSize)
                    .offset(y: isAnimating ? bounceHeight : 0)
                    .animation(
                        Animation.easeInOut(duration: 0.5)
                            .repeatForever(autoreverses: true)
                            .delay(0.15 * Double(index)),
                        value: isAnimating
                    )
            }
        }
        .onAppear {
            isAnimating = true
        }
    }
}

#Preview {
    BouncingDotsView(
        amountOfDots: 5,
        dotSize: 30,
        dotColor: .gray,
        bounceHeight: -40
    )
    Spacer()
        .frame(height: 25)
    //Looks Like A Typing Indicator
    BouncingDotsView(dotSize: 30, dotColor: .secondary, bounceHeight: -10)
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color(.systemGray6))
            .clipShape(Capsule())
}
