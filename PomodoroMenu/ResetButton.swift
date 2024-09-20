//
//  ResetButton.swift
//  PomodoroMenu
//
//  Created by Alex Ryan on 9/19/24.
//

import SwiftUI

struct ResetButton: View {
    @ObservedObject var timerModel: TimerModel

    var body: some View {
            /// Reset Button with Enhanced Design
        Button(action: {
            timerModel.reset()
        }) {
            HStack {
                    // Reset icon
                Image(systemName: "arrow.counterclockwise.circle.fill")
                    .resizable()
                    .frame(width: 20, height: 20) // Reduced icon size for smaller button
                    .foregroundColor(.white)

                    // Button label
                Text("Reset")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
            }
            .padding(8) // Reduced padding for smaller button size
            .frame(width: 85, height: 40) // Fixed size for consistency
            .background(Color.mutedRed.opacity(0.7)) // Less bright color
            .cornerRadius(10) // Slightly smaller corner radius for elegance
            .shadow(color: Color.mutedRed.opacity(0.3), radius: 3, x: 0, y: 3) // Subtle shadow
        }
        .buttonStyle(PlainButtonStyle()) // Removes default button styling for custom appearance
    }
}
